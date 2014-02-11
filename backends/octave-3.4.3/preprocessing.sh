#!/usr/bin/env bash

# Preprocessing

# $1 -> source directory for benchmarks
# $2 -> Destination directory for benchmarks
# $3 -> Benchmark driver name
# $4 -> backend directory
# $5 -> template file name
# $6 -> compile arguments
benchsrc=
benchdst=
benchdrv=
backsrc=
template=
compilearg=


while [ "$1" != "" ]; do
    case $1 in
        -benchsrc )		shift
						benchsrc=$1
						;;
        -benchdst )		shift
						benchdst=$1
						;;
        -benchdrv )		shift
						benchdrv=$1
						;;
        -backsrc )		shift
						backsrc=$1
						;;
        * )				shift
						;;
    esac
    shift
done

template=run.m

rm -r $benchdst
mkdir -p $benchdst

cp -r $benchsrc. $benchdst
replace {{##benchmark##}} $benchdrv < "$backsrc$template" > "$benchdst$template"

# Compiling logic

