FROM nvidia/cuda:11.7.1-base-ubuntu22.04

RUN apt-get update && \
    apt-get install -y ruby-full

COPY app.rb /app.rb

CMD ruby app.rb
