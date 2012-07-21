#!/bin/sh

if [ $# -lt 1 ];then
    echo Usage: $0 harfbuzz-git-snapshot-date
    exit 2
fi

DIR=harfbuzz-$1

mkdir $DIR
mv hb pango index.html $DIR

echo Do you want to compress the directory?
read answer

if [ $answer == 'y' -o $answer == 'yes' ]; then
    tar -cvf - $DIR | xz -9 > $DIR.tar.xz
fi

