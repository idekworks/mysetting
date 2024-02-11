#!/bin/bash

# 入力ファイルパスをコマンドライン引数から取得
input_file="$1"

# ファイル名からタイトルを抽出
title=$(basename "$input_file" .md)

# Markdownファイルの内容を変数に格納
content=$(cat "$input_file")

# JSON形式に変換
echo "  \"Print to console\": {" > "${title}.txt"
echo "    \"${title}\": {" >> "${title}.txt"
echo "      \"prefix\": \"${title}\"," >> "${title}.txt"
echo "      \"body\": [" >> "${title}.txt"
echo "        \"---\"," >> "${title}.txt"
echo "        \"title: \$TM_FILENAME_BASE\"," >> "${title}.txt"
echo "        \"date: \$CURRENT_YEAR/\$CURRENT_MONTH/\$CURRENT_DATE/\$CURRENT_HOUR:\$CURRENT_MINUTE\"," >> "${title}.txt"
echo "        \"tags:\"," >> "${title}.txt"
echo "        \"  - ${title}\"," >> "${title}.txt"
echo "        \"---\"," >> "${title}.txt"
echo "        \"date: \$CURRENT_YEAR/\$CURRENT_MONTH/\$CURRENT_DATE/\$CURRENT_HOUR:\$CURRENT_MINUTE\"," >> "${title}.txt"
echo "        \"# ${title}\"," >> "${title}.txt"

# Markdownファイルの内容を行ごとに処理
while IFS= read -r line
do
  # 各行をエスケープしてJSONに追加
  echo "        \"$(echo "$line" | sed 's/"/\\"/g')\"," >> "${title}.txt"
done <<< "$content"

echo "      ]," >> "${title}.txt"
echo "      \"description\": \"${title}\"" >> "${title}.txt"
echo "    }" >> "${title}.txt"
echo "  }" >> "${title}.txt"