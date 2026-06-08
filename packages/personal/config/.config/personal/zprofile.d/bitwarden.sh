bw-init() {
  if [ -z "$BW_SESSION" ]; then
    export BW_SESSION=$(bw unlock --raw)
  else
    echo "Bitwarden session already set!"
  fi
}
