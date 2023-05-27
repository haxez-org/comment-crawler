Comment Crawler is a simple bash script created by ChatGPT. It could be better but for now it does what it needs to. The reason for the creation of this script is because sensitive information can be  left in comments. The script crawls the supplied URL and reports back all the comments it finds. It doesn’t look for sensitive information but you can pipe the output to tee and save it to a file. You can then perform your own greps on the output. 
Usage - ./commentcrawler.sh https://<target>.<tld>

  
