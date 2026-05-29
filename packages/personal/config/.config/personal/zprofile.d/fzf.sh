change_directory_fuzzy() {
    new_dir=$(find * -type d -maxdepth 4 | fzf)
    if [ -z "${new_dir}" ]; then new_dir=$(PWD); fi
    cd $new_dir
}
