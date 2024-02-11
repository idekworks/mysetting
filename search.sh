#!/bin/bash

# 引数をURLエンコードする
query="$1"

# Google Chromeで検索を実行する
google_url="https://www.google.com/search?q=$query"

# Google Chromeを開く
if which google-chrome > /dev/null
then
  # Linux
  google-chrome "$google_url"
elif which google-chrome-stable > /dev/null
then
  # Linux (Chrome Stable)
  google-chrome-stable "$google_url"
elif which open > /dev/null
then
  # OS X
  open -a "Google Chrome" "$google_url"
elif cmd.exe /C start > /dev/null
then
  # Windows
  cmd.exe /C start "Google Chrome" "$google_url"
else
  echo "Could not detect the web browser to use."
fi