#! /bin/bash

function normalize_entrypoint(){
    local dir=$1
    
    if [[ -e $dir/bin/app.py ]]; then
      mv $dir/bin/app.py $dir/bin/main.py
    elif [[ -e $dir/py-srv/bin/app.py ]]; then
      mv $dir/py-srv/bin/app.py $dir/py-srv/bin/main.py
    fi
}

function replace_Dockerfile(){
    local dir=$1

    if [[ -e $dir/Dockerfile ]]; then
        rm -f $dir/Dockerfile
        case $dir in
            *web* )
                cp .src/Dockerfile $dir;;
            *desktop* )
                cp .src/Dockerfile-desktop $dir;;
            *cli* )
                cp .src/Dockerfile $dir;;
        esac
    else
        rm -f $dir/py-srv/Dockerfile
        case $dir in
            *web* )
                cp .src/Dockerfile $dir/py-srv;;
            *desktop* )
                cp .src/Dockerfile-desktop $dir/py-srv;;
            *cli* )
                cp .src/Dockerfile $dir/py-srv;;
        esac
    fi
}

function replace_install(){
    local dir=$1

    if [[ -e $dir/docker-compose.yml ]]; then
        exit 0
    fi

    case $dir in
        *web* )
            rm -f $dir/install.sh &&
            cp .src/install-web.sh $dir/install.sh;;
        *desktop* )
            rm -f $dir/install.sh &&
            cp .src/install-desktop.sh $dir/install.sh;;
        *cli* )
            rm -f $dir/install.sh &&
            cp .src/install-cli.sh $dir/install.sh;;
    esac
}

function build_buck2(){
  local dir=$1

  cp -R .src/buck2build-base $d/buck2build-base

  #copy BUILD file from src folder
  cp .src/BUILD $dir

  cp .src/frameworks $dir

  cp .src/requirements.sh $dir
  
}

d=$1
e=$d/bin
f=$d/py-srv/bin

if [[ -e $e ]]; then
  build_buck2 $e
else
  build_buck2 $f
fi

normalize_entrypoint $d
replace_Dockerfile $d
replace_install $d