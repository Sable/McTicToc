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
        -compilearg )	shift
						compilearg=$1
						;;
        * )				shift
						;;
    esac
    shift
done

template=run.f95

rm -r $benchdst
mkdir -p $benchdst
replace {{##benchmark##}} $benchdrv < "$backsrc$template" > "$benchdst$template"

cp -r $benchsrc. $benchdst
cp $backsrc/zeros.f95 $benchdst

# Compiling logic
java -jar "$backsrc/Mc2For.jar" -nocheck "$benchdst$benchdrv.m" -args "dble&1*1&REAL" $compilearg

gfortran $benchdst*.f95 -J $benchdst -O3 -o $benchdst$benchdrv
gfortran $benchdst*.f95 -J $benchdst -O3 -o $benchdst$benchdrv
gfortran $benchdst*.f95 -J $benchdst -O3 -o $benchdst$benchdrv

f95 $benchdst*.f95 -O3 -o $benchdst/run

