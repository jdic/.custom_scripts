#!/bin/bash

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  echo "Usage: $0 <time> <path> [path]"
  exit 1
fi

SPLIT_TIME=$1
INPUT_PATH=$2
OUTPUT_DIR=${3:-$(dirname "$INPUT_PATH")}

if [ ! -f "$INPUT_PATH" ]; then
  echo "File not found."
  exit 1
fi

basename=$(basename "$INPUT_PATH")
filename="${basename%.*}"
extension="${basename##*.}"

output_path="$OUTPUT_DIR/$filename"

mkdir -p "$output_path"

if ! command -v ffmpeg &> /dev/null; then
  echo "ffmpeg not found."
  exit 1
fi

case "$extension" in
  webm)
    video_codec="libvpx"
    audio_codec="libvorbis"
    output_extension="webm"
    ;;
  mp4)
    video_codec="libx264"
    audio_codec="aac"
    output_extension="mp4"
    ;;
  *)
    video_codec="copy"
    audio_codec="copy"
    output_extension="$extension"
    ;;
esac

ffmpeg -i "$INPUT_PATH" -c:v $video_codec -c:a $audio_codec -b:a 192k -force_key_frames "expr:gte(t,n_forced*${SPLIT_TIME})" -f segment -segment_time "$SPLIT_TIME" -reset_timestamps 1 -map 0 "${output_path}/${filename}_%03d.$output_extension"
