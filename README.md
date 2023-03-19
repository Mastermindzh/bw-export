# bw-export

bw-export is a simple bash script that exports a raw, encrypted JSON copy of your Bitwarden vault.
It will encrypt the JSON file with OpenSSL and lock it, by default, with your vault password.

[![Build Status](https://ci.mastermindzh.tech/api/badges/mastermindzh/bw-export/status.svg)](https://ci.mastermindzh.tech/mastermindzh/bw-export)

<!-- toc -->

- [bw-export](#bw-export)
  - [getting started](#getting-started)
  - [getting started with docker](#getting-started-with-docker)
  - [Decrypting the backup file](#decrypting-the-backup-file)
  - [Environment variables](#environment-variables)

<!-- tocstop -->

## getting started

Either edit the variables in the script itself or use the [Environment variables](#environment-variables) to configure the script and simply run it:
`bash export.sh`

## getting started with docker

Run the following command to quickly create an encrypted backup of your vault:

`docker run --rm -e BW_ACCOUNT='your_email' -e BW_PASS='your_password' -v "$PWD:/export" mastermindzh/bw-export`

## Decrypting the backup file

By default, bw-export will use the following settings to make your backup:

`-aes-256-cbc -pbkdf2 -iter 100000 -k "<Your Vault password>"`

To decrypt that simply run OpenSSL with the same params in export mode:

`openssl enc -aes-256-cbc -pbkdf2 -iter 100000 -d -nopad -in input.enc -out output.json`

## Environment variables

You can tweak a lot of the internal workings of bw-export with simple environmental variables.
The list below outlines most of them:

| Variable            | Default value                            | Description                                                    |
| ------------------- | ---------------------------------------- | -------------------------------------------------------------- |
| BW_ACCOUNT          | `bitwarden_vault_test@mastermindzh.tech` | Bitwarden email address                                        |
| BW_PASS             | `VGhpc0lzQVZhdWx0UGFzc3dvcmQK`           | Bitwarden password                                             |
| BW_FILENAME_PREFIX  | `bitwarden_vault_export_`                | Prefix to use for generated files ($prefix$timestamp.enc)      |
| BW_TIMESTAMP        | `Y-%m-%d %H:%M:%S`                       | Timestamp to use for generated files                           |
| BW_EXPORT_FOLDER    | `export`                                 | Folder to put export files in                                  |
| BW_FOLDER_STRUCTURE | `Y/%m`                                   | Date/timestamp to generate folders                             |
| BW_PASSWORD_ENCODE  | `base64`                                 | "plain", or "base64", depending on whether you encoded BW_PASS |
| BW_OPENSSL_OPTIONS  | `aes-256-cbc -pbkdf2 -iter 100000`       | Options passed to openssl's "enc" command                      |
