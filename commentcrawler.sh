#!/bin/bash

# Function to display a progress bar
function show_progress() {
  local progress
  local total_length
  local completed_length
  local bar_length
  local percentage

  progress=$1
  total_length=50
  completed_length=$((progress * total_length / 100))
  bar_length=$((total_length - completed_length))
  percentage=$((progress * 100 / total_length))

  printf "\r[%-${completed_length}s%${bar_length}s] %3d%%" "█" "" "$percentage"
}

# Print script name and ASCII art
echo "Comment Crawler"
echo ""
echo "   / \\"
echo "  [ o o ]"
echo "   \\=_=/"
echo "   /   \\"
echo "  /_____\\"
echo ""

# Check if URL/IP address is provided as an argument
if [ -z "$1" ]; then
  echo "Please provide a URL or IP address."
  exit 1
fi

# Store the supplied URL/IP
url_ip=$1

# Fetch the page source
page_source=$(curl -s "$url_ip")

# Extract and report comments using grep
comments=$(echo "$page_source" | grep -oP '<!--[\s\S]*?-->')

# Check if any comments are found
if [ -z "$comments" ]; then
  echo "No comments found on $url_ip."
else
  echo "Comments found on $url_ip:"

  # Calculate total number of comments
  total_comments=$(echo "$comments" | wc -l)

  # Set initial progress to 0
  progress=0

  # Iterate through each comment and display progress bar
  while IFS= read -r comment; do
    echo "$comment"

    # Increment progress by 1 for each comment
    progress=$((progress + 1))

    # Display progress bar
    show_progress $((progress * 100 / total_comments))
  done <<< "$comments"

  # Move to the next line after the progress bar is complete
  echo ""
fi
