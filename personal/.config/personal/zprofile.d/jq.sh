fws_to_form_data() {
    jq '. | to_entries | map("-F \(.key)=\(.value)") | .[]' -r
}
