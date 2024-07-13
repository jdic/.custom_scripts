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
extension="${basename##*.}"

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

ffmpeg -i "$input" -c copy -map 0 -segment_time "$time" -f segment -reset_timestamps 1 "${output_path}/${filename}_%03d.${extension}"
