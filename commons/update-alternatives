#!/bin/bash
array=($*)
install="--install"
slave="--slave"
prefix="/code/.fun/root"

if [ "$FUN_INSTALL_LOCAL" = "true" ]; then
    for ((i = 0; i < ${#array[@]}; i++)); do
        if [[ ${array[i]} == $install || ${array[i]} == $slave ]]; then
            array[i + 1]=$prefix${array[i + 1]}
            array[i + 3]=$prefix${array[i + 3]}
        fi
    done
    mkdir -p /code/.fun/root/usr/bin
    mkdir -p /code/.fun/root/etc/alternatives

    update-alternatives-origin ${array[@]} --altdir /code/.fun/root/etc/alternatives
else
    update-alternatives-origin $*
fi
