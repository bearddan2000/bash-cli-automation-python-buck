#! /bin/bash

function apt-requirements(){

    local a=""
    local b=""
    local c=""

    for b in `cat requirements.txt`; do
        a=$(echo $b | ruby -e 'puts gets.split.uniq.map { |e| [ "#{e}".downcase, ]}')
        c=$(echo $c " python3-${a}")
    done
    apt install -y $c
}

function pipx-framework(){

    local a=""
    local framework=""

    for a in `cat frameworks`; do
        if grep -q $a requirements.txt; then
            framework=$a
        fi
    done

    if [[ -z $framework ]]; then
        echo "Framework not found"
        exit 0
    fi

    pipx install $framework
}

function main(){
    pipx-framework
    apt-requirements
}

if [[ -e requirements.txt ]]; then
    main
fi
