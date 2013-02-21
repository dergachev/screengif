#!/usr/bin/env bash

FRAMERATE=10 # frames-per-second
FRAMEDELAY=8 # delay, in tens of ms
# Testing
# FRAMERATE=3 #frames-per-second

# -------------------
# Argument validation
# -------------------

if [[ ! ( $# -eq 2 && -e "$1" && -n "$2") ]]; then
  echo -e "Usage: `basename $0` INPUTFILE.mov OUTPUTFILE.gif" >&1
  exit 1;
fi

# -------------------------------------------
# Sanity check: Test if commands are in $PATH
# -------------------------------------------

for t_cmd in ffmpeg convert gifsicle ruby
do
  type -P $t_cmd >> /dev/null && : || {
  echo -e "'$t_cmd' executable not found in PATH. Unable to proceed." >&2
  exit 1
}
done


INFILE=$1
OUTFILE=$2
STARTTIME=$(date +%s)

ffmpeg -i $INFILE -r $FRAMERATE -f image2pipe -vcodec ppm - \
  |  $(dirname $0)/screengif-rmagick.rb --no-coalesce --progressbar --delay=$FRAMEDELAY \
  | gifsicle --loop --optimize=3 --multifile - \
  > $OUTFILE

ffmpeg -i $INFILE 2>&1 | grep Duration
ls -lh $OUTFILE $INFILE | awk '{ print $9 ": " $5}'

ENDTIME=$(date +%s)
ELAPSED=$(echo "$ENDTIME - $STARTTIME"|bc)
echo "Conversion of $INFILE into $OUTFILE completed; $ELAPSED seconds elapsed."
