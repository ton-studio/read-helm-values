FROM alpine:latest

RUN apk add --no-cache bash wget && \
    wget https://github.com/mikefarah/yq/releases/download/v4.46.1/yq_linux_amd64 -O /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq && \
    apk del wget && \
    rm -rf /var/cache/apk/*

WORKDIR /action/workspace
COPY entrypoint.sh /entrypoint.sh
COPY read-values.sh /read-values.sh
ENTRYPOINT ["/entrypoint.sh"]
