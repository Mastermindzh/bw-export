FROM node:25.6.1-bullseye-slim

# install openssl
RUN apt-get update && \
    apt-get install -y openssl expect && \
    rm -rf /var/lib/apt/lists/*

# install bitwarden-cli
RUN npm install -g @bitwarden/cli

# add the export script
RUN mkdir -p /opt/bw-export
COPY export.sh /opt/bw-export/export.sh

WORKDIR /opt/bw-export
ENTRYPOINT [ "bash", "export.sh" ]