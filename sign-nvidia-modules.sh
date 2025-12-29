#!/bin/bash
KEY="/usr/share/secureboot/keys/db.key"
CERT="/usr/share/secureboot/keys/db.pem"
SIGNFILE="/usr/lib/modules/$(uname -r)/build/scripts/sign-file"

for mod in $(find /usr/lib/modules/$(uname -r) -type f -name 'nvidia*.ko*'); do
  echo "Signing $mod"
  zstd -d "$mod" -o "${mod%.zst}" && \
  "$SIGNFILE" sha256 "$KEY" "$CERT" "${mod%.zst}" && \
  zstd -f "${mod%.zst}" -o "$mod" && \
  rm "${mod%.zst}"
done

