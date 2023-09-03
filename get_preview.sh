#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <file-with-urls> <markdown-file-to-write-to>"
  exit 1
fi

filename="$1"

output_file="$2"

if [ ! -f "$filename" ]; then
  echo "Error: File '$filename' does not exist."
  exit 1
fi

if [ -f "$output_file" ]; then
  echo "Error: File '$output_file' already exists."
  exit 1
fi

while IFS= read -r url; do
  rawpreview=$(webpreview "$url")
  exit_status=$?
  if [ "$exit_status" != 0 ]; then
    echo "Error while getting preview, skipping $url"
    continue
  fi
  title=$(echo "$rawpreview" | rg -o 'title:.*' | awk -F ': ' '{print $2}')
  description=$(echo "$rawpreview" | rg -o 'description:.*' | awk -F ': ' '{print $2}')
  
  echo "- [$title]($url): $description"
  if [ -n "$title" ]; then
    echo "- [$title]($url): $description" >> "$output_file"
  fi
  echo >> "$output_file"

done < "$filename"
