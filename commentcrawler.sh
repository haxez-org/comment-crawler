#!/bin/bash
echo "
 ██████╗ ██████╗ ███╗   ███╗███╗   ███╗███████╗███╗   ██╗████████╗     ██████╗██████╗  █████╗ ██╗    ██╗██╗     ███████╗██████╗
██╔════╝██╔═══██╗████╗ ████║████╗ ████║██╔════╝████╗  ██║╚══██╔══╝    ██╔════╝██╔══██╗██╔══██╗██║    ██║██║     ██╔════╝██╔══██╗
██║     ██║   ██║██╔████╔██║██╔████╔██║█████╗  ██╔██╗ ██║   ██║       ██║     ██████╔╝███████║██║ █╗ ██║██║     █████╗  ██████╔╝
██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║       ██║     ██╔══██╗██╔══██║██║███╗██║██║     ██╔══╝  ██╔══██╗
╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║███████╗██║ ╚████║   ██║       ╚██████╗██║  ██║██║  ██║╚███╔███╔╝███████╗███████╗██║  ██║
 ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝        ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝╚═╝  ╚═╝

About:
        Built By ChatGPT, Concept by Haxez.
        Comment Crawler is a bash script that looks for comments. 
        Supply an IP address or URL.
        It will then recursivly crawl and report comments.
        You can pipe the output to tee and save it.
        You can then grep for key words to find sensitve content. 

Disclaimer:
        Haxez does not condine the use of this tool for malicious purposes.
        It should only be used on targets you have permission to test.
        The purpose of this tool is to find comments. 
        If they contain sensitve information, they can be removed.
"
sleep 5;
# Check if an argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 [IP address or URL]"
  exit 1
fi

# Get the base URL or IP address
base_url=$(echo "$1" | awk -F/ '{print $1}')

# Function to crawl the site recursively
function crawl_site() {
  local url="$1"
  local parent_path="$2"

  # Fetch the page content
  page_content=$(curl -s "$url")

  # Find comments in the page content
  comments=$(echo "$page_content" | grep -oP "<!--.*?-->")

  # Print the path and comments if found
  if [ -n "$comments" ]; then
    echo "Comment found at: $parent_path"
    echo "Comment: $comments"
    echo
  fi

  # Find links in the page content
  links=$(echo "$page_content" | grep -oP 'href="\K[^"]*')

  # Recursively crawl the links
  for link in $links; do
    if [[ $link == /* ]]; then
      crawl_site "$base_url$link" "$parent_path$link"
    elif [[ $link == http* ]]; then
      crawl_site "$link" "$link"
    fi
  done
}

# Start crawling the site
crawl_site "$1" "$1"
