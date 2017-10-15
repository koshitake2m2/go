#!/bin/sh
#
# go.sh
#
# REQUIRE:
# gcc, g++
# bash

Usage_Exit() {
cat <<EOF
OVERVIEW: compile C++ (or C) file and execute

USAGE : go  [-h][--help][-i][-nc][-pt][-gl][-bg][-k][-x c | cpp][-ne][any GCC options] [file] [args...]

OPTIONS
  -h,--help  you can make sure of Usage
  -nc,       -lncurses
  -pt,       -pthread
  -gl,	     -L/usr/X11R6/lib -lglut -lGLU -lXmu -lGL -lX11 -lm
  -i,        prompt before every removal
             if the file with same name already exits
  -nm,       execute with no massage
  -bg,       execute in the background
  -k,        kill the same process
  -x <language>,
             Treat subsequent input files as having type <language=(c|cpp)>
  -xc,       use gcc to compile c file
  -ne,       non-execution
And you can choose any g++ (or gcc) options
EOF
exit 1
}

nc_on=0
pt_on=0
gl_on=0
i_on=0
bg_on=0
k_on=0
x_on=0
ne_on=0

CFLAGS="-O2 -Wall"

if test $# = 0; then
  Usage_Exit
fi

# OPTIONS
while test "$1" != ""; do
  case $1 in
    -h|--help) Usage_Exit ;;
    -nc) nc_on=1 ;;
    -pt) pt_on=1 ;;
    -gl) gl_on=1 ;;
    -i) i_on=1 ;;
    -nm) i_on=2 ;;
    -b) bg_on=1 ;;
    -k) k_on=1 ;;
    -x) x_on=1 shift
    if test "$1" != 'cpp' && test "$1" != 'c'; then Usage_Exit; fi
    language="$1" ;;
	-xc) x_on=1
	language="c" ;;
    -ne) ne_on=1 ;;
    -*) CFLAGS="$CFLAGS $1" ;;
    *) break ;;
  esac
  shift
done

# FILE
file=$1
filename=${file%.*}
compiler=""
shift
ARGUMENTS="$@"

if test -d $filename; then
  echo "The directory with the same name called \"$file\" already exits."
  exit 1
fi

# PROGRAMING LANGUAGE (C++ OR C)
if test $x_on -eq 1; then
  if ! test -f $filename.$language; then 
      echo "No \"$filename.$language\"."
	  Usage_Exit
  fi
else
  if test $(echo $file | tr '.' '\n' | grep -c "") = "1"; then
    if test -f $file.cpp; then
      language="cpp"
	  compiler="g++"
    elif test -f $file.c; then
      language="c"
	  compiler="gcc"
    else
      echo "No \"$file.cpp\" or \"$file.c\"."
      Usage_Exit
    fi
  else
    language=$(echo $file | tr '.' '\n' | tail -n 1)
    if test $language = 'cpp'; then
	  compiler="g++"
	elif test $language = 'c'; then
	  compiler="gcc"
	else
	  echo "The file which is cpp or c as an extension is required."
	  exit 1
    fi
  fi
fi

if test $i_on -eq 1; then
  if test -f $filename; then
    echo -n "Overwrite? [n,N/Other] : "
    read answer
    case $answer in
      [nN]) echo "Stop."; exit 0 ;;
      *) ;;
    esac
  fi
fi

rm -f $filename

# COMPILE
if test $nc_on -eq 1; then
  CFLAGS="$CFLAGS -lncurses"
fi
if test $pt_on -eq 1; then
  CFLAGS="$CFLAGS -pthread"
fi
if test $gl_on -eq 1; then
  CFLAGS="$CFLAGS -L/usr/X11R6/lib -lglut -lGLU -lXmu -lGL -lX11 -lm"
fi

if ! test -f $filename.$language; then
    echo "\"$filename.$language\" does not exists."
	exit 1
fi
if test $i_on -ne 2; then
  echo Compile : $compiler $CFLAGS $filename.$language -o $filename
fi
$compiler $CFLAGS $filename.$language -o $filename

if test $? -ne 0; then
  exit 1
fi

# EXECUTE
if test $ne_on -eq 0;then
  if test $i_on -ne 2; then
    echo Execute : ./$filename $ARGUMENTS
  fi

  if test $k_on -eq 1; then
    /usr/bin/killall $filename
  fi

  if test $bg_on -eq 1; then
    ./$filename $ARGUMENTS &
  else
    ./$filename $ARGUMENTS
  fi
fi
