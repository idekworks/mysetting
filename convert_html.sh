#!/bin/bash

# 入力ファイルパスをコマンドライン引数から取得
input_file="./手順書/input/$1"

# ファイル名からタイトルを抽出
title=$(basename "$input_file" .md)

# 出力ファイルを作成
output_file="./手順書/output/${title}.html"

# HTMLのヘッダを出力
echo "<!DOCTYPE html>" > "$output_file"
echo "<html>" >> "$output_file"
echo "  <head>" >> "$output_file"
echo "    <title>$title</title>" >> "$output_file"
echo "  </head>" >> "$output_file"
echo "  <body>" >> "$output_file"

# 初期状態を設定
inside_ul=false
inside_ol=false

# Markdownファイルの内容を行ごとに処理
while IFS= read -r line
do
  # 各行をHTMLに変換
  if [[ "$line" == "# "* ]]; then
    echo "    <h1>${line:2}</h1>" >> "$output_file"
  elif [[ "$line" == "## "* ]]; then
    echo "    <h2>${line:3}</h2>" >> "$output_file"
  elif [[ "$line" == "### "* ]]; then
    echo "    <h3>${line:4}</h3>" >> "$output_file"
  elif [[ "$line" == "- [ ] "* ]]; then
    if [ "$inside_ul" = false ] ; then
      echo "    <ul>" >> "$output_file"
      inside_ul=true
    fi
    echo "      <li>" >> "$output_file"
    echo "        <input type=\"checkbox\"> ${line:6}" >> "$output_file"
    echo "      </li>" >> "$output_file"
  elif [[ "$line" == "- "* ]]; then
    if [ "$inside_ul" = false ] ; then
      echo "    <ul>" >> "$output_file"
      inside_ul=true
    fi
    echo "      <li>" >> "$output_file"
    echo "        ${line:2}" >> "$output_file"
    echo "      </li>" >> "$output_file"
  elif [[ "$line" =~ ^[0-9]+\. ]]; then
    if [ "$inside_ol" = false ] ; then
      echo "    <ol>" >> "$output_file"
      inside_ol=true
    fi
    echo "      <li>" >> "$output_file"
    echo "        ${line:2}" >> "$output_file"
    echo "      </li>" >> "$output_file"
  elif [[ "$line" == "" ]]; then
    if [ "$inside_ul" = true ] ; then
      echo "    </ul>" >> "$output_file"
      inside_ul=false
    fi
    if [ "$inside_ol" = true ] ; then
      echo "    </ol>" >> "$output_file"
      inside_ol=false
    fi
  fi
done < "$input_file"

# HTMLのフッタを出力
echo "  </body>" >> "$output_file"
echo "</html>" >> "$output_file"

# Google ChromeでHTMLファイルを開く
if which google-chrome > /dev/null
then
  # Linux
  google-chrome "$output_file"
elif which google-chrome-stable > /dev/null
then
  # Linux (Chrome Stable)
  google-chrome-stable "$output_file"
elif which open > /dev/null
then
  # OS X
  open -a "Google Chrome" "$output_file"
elif cmd.exe /C start > /dev/null
then
  # Windows
  cmd.exe /C start "Google Chrome" "$output_file"
else
  echo "Could not detect the web browser to use."
fi