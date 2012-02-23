#!/bin/bash -x

usage_and_exit() {
  echo "Usage: $0 [-n <ruby-name>] [-h] [-c] <ruby-versions>" 1>&2
  echo "For example, $0 -n tiss will install to ${rvm_path}/rubies/ruby-1.9.2-p290-tiss" 1>&2
  echo "If -c is given, cleanup old patch sets from ${rvm_path}" 1>&2
  exit 0;
}

while getopts "chn:" opt
do
  case $opt in
  h) usage_and_exit ;;
  n) NAME="-n $OPTARG" ;;
  c) echo "zak" ; DO_CLEANUP="yes"
  esac
done

if [ "$DO_CLEANUP" == "yes" ]
then
  find $rvm_path/patches $rvm_path/patchsets -name '*railsexpress*' | xargs rm -rf
fi

while [ $OPTIND -gt 1 ]
do
  shift
  OPTIND=$[ $OPTIND-1 ]
done

cp -rp patches patchsets $rvm_path
for i in "$@"; do
  rvm install $i --force --patch railsexpress ${NAME}
done
