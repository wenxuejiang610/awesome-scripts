#!/bin/bash
# @Function
# Open file in file explorer.
#
# @Usage
#   $ ./xpf file
#
# @author Jerry Lee

PROG=`basename $0`

usage() {
    cat <<EOF
Usage: ${PROG} [OPTION] [FILE]...
Open file in file explorer.
Example: ${PROG} file.txt

Options:
    -s, --selected  select the file or dir
    -h, --help      display this help and exit
EOF
    exit $1
}

ARGS=`getopt -a -o sh -l selected,help -- "$@"`
[ $? -ne 0 ] && usage 1
eval set -- "${ARGS}"

while true; do
    case "$1" in
    -s|--selected)
        selected=true
        shift
        ;;
    -h|--help)
        usage
        ;;
    --)
        shift
        break
        ;;
    esac
done

# if program name is xpf, set option selected!
[ "xpf" == "${PROG}" ] && selected=true

name=$(uname | tr A-Z a-z)
[ $# == 0 ] && files=( "." ) || files=( "$@" )
for file in "${files[@]}" ; do
    case "${name}" in 
    darwin*)
        [ -f "${file}" ] && selected=true
        open ${selected:+-R} ${file}
        ;;
    cygwin*)
        [ -f "${file}" ] && selected=true
        explorer ${selected:+/select,} $(cygpath -w "${file}")
        ;;
    *)
        if [ -f "${file}" ] ; then
            nautilus "$(basedir "${file}")"
        else
            if [ -n "${selected}" ] ; then
                nautilus "$(basedir "${file}")"
            else
                nautilus "${file}"
            fi
        fi
        ;;
    esac 
done
