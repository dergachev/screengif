#!/usr/bin/env bash

if [[ ! ( $# -eq 2 && -e "$1" && -n "$2") ]]; then
  echo -e "Usage: `basename $0` INPUTFILE.mov OUTPUTFILE.gif" >&1
  exit 1;
fi

#Sanity check: Test if commands are in $PATH
for t_cmd in "ffmpeg convert gifsicle ruby"
do
  type -P $t_cmd >> /dev/null && : || {
  echo -e "$t_cmd not found in PATH." >&2
  exit 1
}
done

STARTTIME=$(date +%s)

INFILE=$1
OUTFILE=$2

FRAMERATE=10 #frames-per-second

# Testing
# FRAMERATE=3 #frames-per-second

ffmpeg -i $INFILE -r $FRAMERATE -f image2pipe -vcodec ppm - \
  |  $(dirname $0)/screengif-rmagick.rb \
  | gifsicle --loop --optimize=3 --multifile - \
  > $OUTFILE

ffmpeg -i $INFILE 2>&1 | grep Duration
ls -alh $OUTFILE $INFILE

ENDTIME=$(date +%s)
ELAPSED=$(echo "$ENDTIME - $STARTTIME"|bc)
echo "Conversion of $INFILE into $OUTFILE completed; $ELAPSED seconds elapsed."
