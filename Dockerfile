FROM node:22.12.0-alpine3.19

# install openssl
RUN apk update && \
    apk add --no-cache openssl expect

# install bitwarden-cli
RUN npm install -g @bitwarden/cli

# add the export script
RUN mkdir -p /opt/bw-export
COPY export.sh /opt/bw-export/export.sh

WORKDIR /opt/bw-export
ENTRYPOINT [ "bash", "export.sh" ]