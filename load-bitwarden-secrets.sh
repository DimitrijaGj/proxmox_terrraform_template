# Use with:
# source ./load-bitwarden-secrets.sh

load_bw_tf_secrets() {
  local BW_ITEM="${BW_ITEM:-terraform-proxmox}"

  if ! command -v bw >/dev/null 2>&1; then
    echo "Missing bw CLI"
    return 1
  fi

  if ! command -v jq >/dev/null 2>&1; then
    echo "Missing jq"
    return 1
  fi

  local STATUS
  STATUS="$(bw status 2>/dev/null | jq -r '.status')"

  if [ "$STATUS" = "unauthenticated" ]; then
    echo "You need to login first:"
    echo "bw login"
    return 1
  fi

  if [ "$STATUS" != "unlocked" ]; then
    local SESSION
    SESSION="$(bw unlock --raw)" || return 1
    export BW_SESSION="$SESSION"
  fi

  bw sync >/dev/null || return 1

  local ITEM_JSON
  ITEM_JSON="$(bw get item "$BW_ITEM")" || return 1

  if ! printf '%s' "$ITEM_JSON" | jq -e . >/dev/null 2>&1; then
    echo "Bitwarden returned invalid JSON for item: $BW_ITEM"
    echo "Run this to inspect it:"
    echo "bw get item $BW_ITEM"
    return 1
  fi

  export TF_VAR_proxmox_endpoint="$(
    printf '%s' "$ITEM_JSON" | jq -r '.fields[]? | select(.name == "proxmox_endpoint") | .value // empty' | head -n 1
  )"

  export TF_VAR_proxmox_api_token="$(
    printf '%s' "$ITEM_JSON" | jq -r '.fields[]? | select(.name == "proxmox_api_token") | .value // empty' | head -n 1
  )"

  if [ -z "$TF_VAR_proxmox_endpoint" ]; then
    echo "Missing proxmox_endpoint in Bitwarden item: $BW_ITEM"
    echo "Available custom fields:"
    printf '%s' "$ITEM_JSON" | jq -r '.fields[]?.name'
    return 1
  fi

  if [ -z "$TF_VAR_proxmox_api_token" ]; then
    echo "Missing proxmox_api_token in Bitwarden item: $BW_ITEM"
    echo "Available custom fields:"
    printf '%s' "$ITEM_JSON" | jq -r '.fields[]?.name'
    return 1
  fi

  echo "Loaded Proxmox secrets from Bitwarden."
  echo "Endpoint: $TF_VAR_proxmox_endpoint"
}

load_bw_tf_secrets
unset -f load_bw_tf_secrets
