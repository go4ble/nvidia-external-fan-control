DEFAULT_CURVE = [
  [40, 25],
  [50, 30],
  [60, 40],
  [70, 55],
  [80, 75],
  [90, 100]
]

DEFAULT_INTERVAL = 5

DEFAULT_FAN = '/mnt/fan'

def main(verbose:, curve:, interval:, fan:)
  puts "Starting..."
  loop do
    sleep(interval)
    temp = get_temp()
    speed = apply_curve(curve: curve, temp: temp)
    print "\r#{temp}°C => #{speed}%  " if verbose
    set_fan_speed(fan, speed)
  end
end

def apply_curve(curve:, temp:)
  i = 0
  loop do
    return curve.first.last if i == 0 and temp <= curve.first.first
    return curve.last.last if i >= curve.length - 1
    if temp >= curve[i].first && temp <= curve[i + 1].first
      slope = (curve[i + 1].last - curve[i].last).to_f / (curve[i + 1].first - curve[i].first)
      intercept = curve[i].last - (slope * curve[i].first)
      return slope * temp + intercept
    end
    i += 1
  end
end

def get_temp()
  `nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader`.to_i
end

def set_fan_speed(file, speed)
  pwm = (speed / 100.0 * 255).round
  File.write(file, pwm.to_s)
end

main(verbose: false, curve: DEFAULT_CURVE, interval: DEFAULT_INTERVAL, fan: DEFAULT_FAN)
