#!/usr/bin/env bash
set -euo pipefail

IDENTITY_NAME="${1:-Prompt Favorite Local Codesign}"
KEYCHAIN="${PROMPT_FAVORITE_KEYCHAIN:-$HOME/Library/Keychains/login.keychain-db}"
P12_PASSWORD="${PROMPT_FAVORITE_CODESIGN_P12_PASSWORD:-prompt-favorite-local}"
FORCE="${PROMPT_FAVORITE_FORCE_CODESIGN_IDENTITY:-0}"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

if [ "$FORCE" != "1" ] && security find-identity -v -p codesigning | awk -v name="$IDENTITY_NAME" 'index($0, "\"" name "\"") { found = 1 } END { exit found ? 0 : 1 }'; then
  if security find-certificate -c "$IDENTITY_NAME" -p "$KEYCHAIN" > "$TMP_DIR/cert.pem"; then
    security add-trusted-cert \
      -r trustRoot \
      -p codeSign \
      -k "$KEYCHAIN" \
      "$TMP_DIR/cert.pem" >/dev/null
  fi
  echo "Code-signing identity already exists: $IDENTITY_NAME"
  exit 0
fi

security delete-certificate -c "$IDENTITY_NAME" "$KEYCHAIN" >/dev/null 2>&1 || true

cat > "$TMP_DIR/openssl.cnf" <<EOF
[ req ]
distinguished_name = dn
x509_extensions = codesign_ext
prompt = no

[ dn ]
commonName = $IDENTITY_NAME

[ codesign_ext ]
basicConstraints = critical, CA:true
keyUsage = critical, digitalSignature, keyCertSign
extendedKeyUsage = critical, codeSigning
subjectKeyIdentifier = hash
EOF

openssl req \
  -new \
  -x509 \
  -newkey rsa:2048 \
  -nodes \
  -sha256 \
  -days 3650 \
  -config "$TMP_DIR/openssl.cnf" \
  -keyout "$TMP_DIR/key.pem" \
  -out "$TMP_DIR/cert.pem" >/dev/null 2>&1

openssl pkcs12 \
  -export \
  -inkey "$TMP_DIR/key.pem" \
  -in "$TMP_DIR/cert.pem" \
  -name "$IDENTITY_NAME" \
  -out "$TMP_DIR/identity.p12" \
  -passout "pass:$P12_PASSWORD" >/dev/null 2>&1

security import "$TMP_DIR/identity.p12" \
  -f pkcs12 \
  -k "$KEYCHAIN" \
  -P "$P12_PASSWORD" \
  -T /usr/bin/codesign >/dev/null

security add-trusted-cert \
  -r trustRoot \
  -p codeSign \
  -k "$KEYCHAIN" \
  "$TMP_DIR/cert.pem" >/dev/null

if ! security find-identity -v -p codesigning | awk -v name="$IDENTITY_NAME" 'index($0, "\"" name "\"") { found = 1 } END { exit found ? 0 : 1 }'; then
  echo "error: imported certificate, but macOS did not expose it as a valid code-signing identity." >&2
  echo "Open Keychain Access, verify the certificate and private key, then rerun this script." >&2
  exit 1
fi

echo "Created local code-signing identity: $IDENTITY_NAME"
echo "Rebuild and reinstall Prompt Favorite, then grant Accessibility permission once for the installed app."
