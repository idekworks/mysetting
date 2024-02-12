#!/bin/bash

input_folder=$1
output_folder=$2

for input_file in $input_folder/*.md
do
  output_file=$output_folder/$(basename $input_file .md).html

  echo '<!DOCTYPE html>
  <html lang="ja">
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <link rel="stylesheet" type="text/css" href="../styles.css" />
      <title>アジャイルタスクラップタイマー</title>
    </head>
    <body>
      <p id="timer">00:00:00.000</p>
      <div class="button-container">
        <button id="start">スタート</button>
        <button id="stop">ストップ</button>
        <button id="reset">リセット</button>
        <button id="lap">ラップ</button>
      </div>
      <ul id="lap-list"></ul>

      <script src="../script.js"></script>' > $output_file

  while IFS= read -r line
  do
    if [[ $line == "# "* ]]; then
      echo "<h1>${line:2}</h1>" >> $output_file
    elif [[ $line == "## "* ]]; then
      echo '<div class="task-container">' >> $output_file
      echo "<h2>${line:3}</h2>" >> $output_file
      echo "<ul>" >> $output_file
    elif [[ $line == "### "* ]]; then
      echo '<div class="task-container">' >> $output_file
      echo "<h3>${line:4}</h3>" >> $output_file
      echo "<ul>" >> $output_file
    elif [[ $line == "- "* ]]; then
      echo "<li><input type=\"checkbox\">${line:6}</li>" >> $output_file
    elif [[ $line == "" ]]; then
      echo "</ul>" >> $output_file
      echo "</div>" >> $output_file
    fi
  done < "$input_file"

  echo '</body>
  </html>' >> $output_file
done