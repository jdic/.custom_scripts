#!/bin/bash

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <time> <input> [output]"
  exit 1
fi

time=$1
input=$2
output_dir=${3:-$(dirname "$input")}

basename=$(basename "$input")
filename="${basename%.*}"

if [ "$output_dir" = "." ]; then
  output_path="./$filename"
else
  output_path="$output_dir/$filename"
fi

mkdir -p "$output_path"

if ! command -v ffmpeg &> /dev/null; then
  echo "ffmpeg not found."
  exit 1
fi

ffmpeg -i $input -c:v libx264 -c:a aac -strict experimental -b:a 192k -force_key_frames "expr:gte(t,n_forced*${time})" -f segment -segment_time $time -reset_timestamps 1 -map 0 "${output_path}/${filename}_%03d.${basename##*.}"
