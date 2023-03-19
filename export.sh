#!/usr/bin/env bash

# input password might be encrypted/hashed/etc

set -e
export LC_CTYPE=C
export LC_ALL=C

bw_logout() {
    bw logout &>/dev/null || true
}

# environment variables
BW_ACCOUNT=${BW_ACCOUNT:-"bitwarden_vault_test@mastermindzh.tech"}
BW_PASS=${BW_PASS:-"VGhpc0lzQVZhdWx0UGFzc3dvcmQK"}
BW_FILENAME_PREFIX=${BW_FILENAME_PREFIX:-"bitwarden_vault_export_"}
BW_TIMESTAMP=${BW_TIMESTAMP:-"+%Y-%m-%d %H:%M:%S"}
BW_EXPORT_FOLDER=${BW_EXPORT_FOLDER:-"/export"}
BW_FOLDER_STRUCTURE=${BW_FOLDER_STRUCTURE:-"+%Y/%m"}
BW_PASSWORD_ENCODE=${BW_PASSWORD_ENCODE:-"base64"}
BW_OPENSSL_OPTIONS=${BW_OPENSSL_OPTIONS:-"-aes-256-cbc -pbkdf2 -iter 100000"}

# construct internal variables
BW_INTERNAL_TIMESTAMP=$(date "$BW_TIMESTAMP")
BW_INTERNAL_PASSWORD="$BW_PASS"
BW_INTERNAL_FOLDER_STRUCTURE="$BW_EXPORT_FOLDER"
BW_ENC_OUTPUT_FILE="$BW_FILENAME_PREFIX$BW_INTERNAL_TIMESTAMP.enc"
if [ -n "$BW_FOLDER_STRUCTURE" ]; then
    BW_INTERNAL_FOLDER_STRUCTURE="$BW_INTERNAL_FOLDER_STRUCTURE/$(date "$BW_FOLDER_STRUCTURE")"
    mkdir -p "$BW_INTERNAL_FOLDER_STRUCTURE"
    BW_ENC_OUTPUT_FILE="$BW_INTERNAL_FOLDER_STRUCTURE/$BW_ENC_OUTPUT_FILE"
fi

# we need to control the session so we're making sure to logout if we are logged in
bw_logout

case $BW_PASSWORD_ENCODE in

"base64")
    BW_INTERNAL_PASSWORD=$(echo "$BW_INTERNAL_PASSWORD" | base64 -d)
    ;;
"none" | "plain")
    echo "using un-encoded password."
    ;;

*)
    echo "unrecognized encoding method. Aborting."
    exit 1
    ;;
esac

#login
BW_SESSION=$(bw login "$BW_ACCOUNT" "$BW_INTERNAL_PASSWORD" --raw)

# commands
echo "Exporting to \"$BW_ENC_OUTPUT_FILE\""
echo "$BW_ENCRYPTION_PASSWORD"
bw --raw --session "$BW_SESSION" export --format json | openssl enc $BW_OPENSSL_OPTIONS -k "$BW_INTERNAL_PASSWORD" -out "$BW_ENC_OUTPUT_FILE"
bw_logout

# make sure none of these are available later
unset BW_SESSION
unset BW_PASS
unset BW_ACCOUNT
unset BW_INTERNAL_PASSWORD
