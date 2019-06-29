#!/bin/bash
array=($*)
install="--install"
slave="--slave"
prefix="/code/.fun/root"
if [ !$FUN_INSTALL_LOCAL ] || [ $FUN_INSTALL_LOCAL = "false" ]; then

    update-alternatives-origin $*
    
elif [ $FUN_INSTALL_LOCAL] && [ $FUN_INSTALL_LOCAL = "true" ]; then

    for ((i = 0; i < ${#array[@]}; i++)); do
        if [[ ${array[i]} == $install || ${array[i]} == $slave ]]; then
            array[i + 1]=$prefix${array[i + 1]}
            array[i + 3]=$prefix${array[i + 3]}
        fi
    done

    update-alternatives-origin ${array[@]} --altdir /code/.fun/root/etc/alternatives/
fi
