#!/usr/bin/env bash

basefile="install"
logfile="general.log"
timestamp=`date '+%Y-%m-%d %H:%M:%S'`

if [ "$#" -ne 1 ]; then
  msg="[ERROR]: $basefile failed to receive enough args"
  echo "$msg"
  echo "$msg" >> $logfile
  exit 1
fi

function setup-logging(){
  scope="setup-logging"
  info_base="[$timestamp INFO]: $basefile::$scope"

  echo "$info_base started" >> $logfile

  echo "$info_base removing old logs" >> $logfile

  rm -f $logfile

  echo "$info_base ended" >> $logfile

  echo "================" >> $logfile
}

function root-check(){
  scope="root-check"
  info_base="[$timestamp INFO]: $basefile::$scope"

  echo "$info_base started" >> $logfile

  #Make sure the script is running as root.
  if [ "$UID" -ne "0" ]; then
    echo "[$timestamp ERROR]: $basefile::$scope you must be root to run $0" >> $logfile
    echo "==================" >> $logfile
    echo "You must be root to run $0. Try the following"
    echo "sudo $0"
    exit 1
  fi

  echo "$info_base ended" >> $logfile
  echo "================" >> $logfile
}

function docker-check() {
  scope="docker-check"
  info_base="[$timestamp INFO]: $basefile::$scope"
  cmd=`docker -v`

  echo "$info_base started" >> $logfile

  if [ -z "$cmd" ]; then
    echo "$info_base docker not installed"
    echo "$info_base docker not installed" >> $logfile
  fi

  echo "$info_base ended" >> $logfile
  echo "================" >> $logfile

}

function usage() {
    echo ""
    echo "Usage: "
    echo ""
    echo "-u: start."
    echo "-d: tear down."
    echo "-h: Display this help and exit."
    echo ""
}
function create_custom_image(){
  local dir=$1
  local image_name=$2
  cd $dir
  docker build -t $image_name .
  cd ../
}
function start-up(){

    local scope="start-up"
    local docker_img_name=`head -n 1 README.md | sed 's/# //'`
    local info_base="[$timestamp INFO]: $basefile::$scope"

    create_custom_image "buck2build-base" "buck2build:base"

    echo "$info_base started" >> $logfile

    echo "$info_base build image" >> $logfile

    echo "$info_base running image" >> $logfile
    
    docker build -t $docker_img_name .

    case $docker_img_name in
      *bottle-ssl* ) 
        docker run --rm -p 443:443 $docker_img_name;;
      *bottle* ) 
        docker run --rm -p 80:8000 $docker_img_name;;
      *cherrypy* ) 
        docker run --rm -p 80:8080 $docker_img_name;;
      *dash* ) 
        docker run --rm -p 80:8050 $docker_img_name;;
      *falcon* ) 
        docker run --rm -p 80:8000 $docker_img_name;;
      *fastapi* ) 
        docker run --rm -p 80:8000 $docker_img_name;;
      *flask-ssl* ) 
        docker run --rm -p 443:443 $docker_img_name;;
      *flask* ) 
        docker run --rm -p 80:5000 $docker_img_name;;
      *pyramid* ) 
        docker run --rm -p 80:6543 $docker_img_name;;
      *tornado* ) 
        docker run --rm -p 80:8000 $docker_img_name;;
      /? ) 
        echo "can not determin forwarding port"
        exit 1 ;;
      esac

    echo "$info_base ended" >> $logfile

    echo "================" >> $logfile
}
function tear-down(){

    scope="tear-down"
    info_base="[$timestamp INFO]: $basefile::$scope"

    echo "$info_base started" >> $logfile

    echo "$info_base services removed" >> $logfile

    echo "$info_base ended" >> $logfile

    echo "================" >> $logfile
}

root-check
docker-check

while getopts ":udh" opts; do
  case $opts in
    u)
      setup-logging
      start-up ;;
    d)
      tear-down ;;
    h)
      usage
      exit 0 ;;
    /?)
      usage
      exit 1 ;;
  esac
done
