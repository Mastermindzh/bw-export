FROM node:22.12.0-alpine3.19

# install openssl
RUN apt-get update && \
    apt-get install -y --no-install-recommends openssl expect && \
    rm -rf /var/cache/apk/*

# install bitwarden-cli
RUN npm install -g @bitwarden/cli

# add the export script
RUN mkdir -p /opt/bw-export
COPY export.sh /opt/bw-export/export.sh

WORKDIR /opt/bw-export
ENTRYPOINT [ "bash", "export.sh" ]