#!/usr/bin/env bash
set -euo pipefail

USAGE="$(basename "$0") [-f|--force] <hostname> <output_file>
Generates a SOPS-encrypted JSON with two Ed25519 SSH key pairs
(\"host_key\" and \"boot_key\"), and an age keypair (\"host_age\")
derived from \"host_key\", embedding public fields in cleartext and
encrypting private keys.

Options:
  -f, --force    Overwrite output file if it exists

Example:
  $(basename "$0") my-host secrets/hosts/my-host/host_keys.enc.json
"

FORCE=false
POSITIONAL=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--force)
      FORCE=true
      shift
      ;;
    -h|--help)
      echo "$USAGE"
      exit 0
      ;;
    *)
      POSITIONAL+=("$1")
      shift
      ;;
  esac
done

set -- "${POSITIONAL[@]}"

[[ $# -eq 2 ]] || { echo "Usage: $USAGE" >&2; exit 1; }
HOSTNAME="$1"
OUTPUT_FILE="$2"

if [[ -e "$OUTPUT_FILE" ]]; then
  if [[ "$FORCE" == true ]]; then
    echo "Warning: Overwriting existing file $OUTPUT_FILE" >&2
  else
    echo "Error: $OUTPUT_FILE already exists. Move or remove it first, or use -f to force overwrite." >&2
    exit 1
  fi
fi

# Create temporary directory for key generation
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

# Generate key pairs
declare -A KEYS
for KEY_TYPE in host boot; do
  echo "Generating $KEY_TYPE Ed25519 SSH key pair for '$HOSTNAME'..." >&2
  ssh-keygen -t ed25519 -N "" -C "nix_${KEY_TYPE}_ed25519_$HOSTNAME" \
    -f "$TMPDIR/${KEY_TYPE}_ed25519" >/dev/null 2>&1
  KEYS["${KEY_TYPE}_private"]="$(< "$TMPDIR/${KEY_TYPE}_ed25519")"
  KEYS["${KEY_TYPE}_public"]="$(< "$TMPDIR/${KEY_TYPE}_ed25519.pub")"
  KEYS["${KEY_TYPE}_fingerprint"]="$(
    ssh-keygen -lf "$TMPDIR/${KEY_TYPE}_ed25519.pub" | awk '{print $2}'
  )"
done

echo "Generating age key pair from 'host_key'"
KEYS["host_age_private"]="$(ssh-to-age -private-key <<< "${KEYS[host_private]}")"
KEYS["host_age_public"]="$(ssh-to-age <<< "${KEYS[host_public]}")"

# Create JSON with properly escaped strings for the keys
TMPFILE="$TMPDIR/keys.json"

cat <<EOF > "$TMPFILE"
{
  "host_key": {
    "private": $(jq -Rs . <<<"${KEYS["host_private"]}"),
    "public_unencrypted": $(jq -Rs . <<<"${KEYS["host_public"]}"),
    "fingerprint_unencrypted": $(jq -Rs . <<<"${KEYS["host_fingerprint"]}")
  },
  "host_age": {
    "private": $(jq -Rs . <<<"${KEYS["host_age_private"]}"),
    "public_unencrypted": $(jq -Rs . <<<"${KEYS["host_age_public"]}")
  },
  "boot_key": {
    "private": $(jq -Rs . <<<"${KEYS["boot_private"]}"),
    "key_unencrypted": $(jq -Rs . <<<"${KEYS["boot_public"]}"),
    "fingerprint_unencrypted": $(jq -Rs . <<<"${KEYS["boot_fingerprint"]}")
  }
}
EOF

echo "Encrypting private keys into $OUTPUT_FILE..." >&2
if ! sops --encrypt --filename-override "$OUTPUT_FILE" "$TMPFILE" > "$OUTPUT_FILE.tmp"; then
  echo "Error: SOPS encryption failed" >&2
  exit 1
fi

# Only move the file into place if SOPS succeeded
mv "$OUTPUT_FILE.tmp" "$OUTPUT_FILE"

echo "Done! Created $OUTPUT_FILE."
echo "Host public key (ssh):"
echo "${KEYS['host_public']}"
echo "Boot public key (ssh):"
echo "${KEYS['boot_public']}"
echo "Host public key (age):"
echo "${KEYS['host_age_public']}"
