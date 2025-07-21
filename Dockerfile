FROM ubuntu:latest

RUN apt update
RUN apt install -y wget

RUN wget https://github.com/mikefarah/yq/releases/download/v4.46.1/yq_linux_amd64 -O /usr/local/bin/yq
RUN chmod +x /usr/local/bin/yq

WORKDIR /action/workspace
COPY entrypoint.sh ./
COPY read-values.sh ./
ENTRYPOINT ["./entrypoint.sh"]
