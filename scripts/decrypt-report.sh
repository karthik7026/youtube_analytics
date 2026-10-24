#!/bin/bash
# Decrypt a downloaded "youtube-analytics-report-encrypted" artifact.
# Usage: scripts/decrypt-report.sh <artifact dir> <private key pem> <output dir>
set -euo pipefail
in="$1"; keyfile="$2"; out="$3"
key="$(openssl pkeyutl -decrypt -inkey "$keyfile" -pkeyopt rsa_padding_mode:oaep -pkeyopt rsa_oaep_md:sha256 -in "$in/report.key.enc")"
mkdir -p "$out"
openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 -pass "pass:$key" -in "$in/report.tgz.enc" | tar xz -C "$out"
echo "Report decrypted to $out/report"
