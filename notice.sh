#!/bin/bash

empty_repo_message="🚫🙅 Mendigo Carlos no ha subido nada al repo 🚫🙅"

url="https://github.com/CarlosP1e/Repository-Carlos"
query="This repository is empty."

if command -v ponysay >/dev/null 2>&1; then
  has_ponysay=true
else
  has_ponysay=false
fi

if curl -s $url | grep -q "$query"; then
  found=true
else
  found=false
fi

if [ $found = true ]; then
  if [ $has_ponysay ]; then
    ponysay --pony fluttershy "$empty_repo_message"
  fi
fi
