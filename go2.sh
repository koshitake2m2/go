#!/bin/bash

CFLAGS="-g -Wall"

while test "$1" != ""; do
  case $1 in
    -nc) CFLAGS="$CFLAGS -lncurses" ;;
    -pt) CFLAGS="$CFLAGS -pthread" ;;
    -gl) CFLAGS="$CFLAGS -L/usr/X11R6/lib -lglut -lGLU -lXmu -lGL -lX11 -lm" ;;
    -*) CFLAGS="$CFLAGS $1" ;; 
    *) break ;;
  esac
  shift
done

filename=${1%.*}

shift
ARGUMENTS="$@"

g++ $CFLAGS $filename.cpp -o $filename && ./$filename $ARGUMENTS
