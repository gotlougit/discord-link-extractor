#!/usr/bin/env bash

# Define the initial offset value
offset=0

# Specify the output JSON file
output_file="links"

# Define a variable to track if an error occurred
error_occurred=false

# Loop to make the API calls until an error is encountered or response is empty
while true; do
  # Make the GET request with the current offset

  # NOTE: FILL THESE IN!
  # You can get `authorization` and `cookie` values by looking at `/api/v9/science` calls
  # in the browser version of Discord using Network tools of browser

  # Fill in guild ID and author ID using Discord dev mode
  authorization=''
  cookie=''
  guild=1234
  author_id=1223

  response=$(curl -s "https://discord.com/api/v9/guilds/$guild/messages/search?author_id=$author_id&has=link&include_nsfw=true&offset=$offset" \
        --compressed \
        -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' \
        -H "$authorization" -H 'X-Discord-Locale: en-US' -H 'X-Discord-Timezone: UTC' \
        -H 'X-Debug-Options: bugReporterEnabled' -H 'Connection: keep-alive'\
        -H "$cookie" -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors'\
        -H 'Sec-Fetch-Site: same-origin' -H 'TE: trailers')

  # Check if the response is empty (indicating no more data)
  if [ -z "$response" ]; then
    break
  fi

  # Check if being rate limited
  if [ "$(echo "$response" | jq '.message')" != "null" ]; then
    echo "Being rate limited, slowing down..."
    sleep "$(echo "$response" | jq '.retry_after')"
    continue
  fi

  # Get URL from the JSON output
  url=$(echo "$response" | jq '.messages[][].content' | rg --only-matching "https://[A-Za-z0-9_.#/\-~%:?=]*")
  if [ -z "$url" ]; then
    echo "Got no URL, stopping further network requests..."
    break
  fi
  echo "$url"
  echo "$url" >> $output_file".tmp"
 
  # Increment the offset by 25
  offset=$((offset + 25))
done

echo "Sorting obtained URLs..."
sort -u $output_file".tmp" > $output_file
rm $output_file".tmp"
if [ "$error_occurred" = true ]; then
  echo "An error occurred during API calls."
else
  echo "API calls completed successfully, and unique URLs saved to $output_file."
fi
