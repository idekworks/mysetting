#!/bin/bash

# フォルダ名
folder="xxx/Downloads"

# 最も新しい更新日時のファイルを取得
newest_file=$(find "$folder" -type f -exec stat -f "%m %N" {} \; | sort -rn | head -1 | cut -f2- -d' ')
echo "The newest file is: $newest_file"

# ファイルパスを出力
file =  "$newest_file"
# ファイル名

# 予測時間の合計
total=0

# ファイルを行ごとに読み込む
while IFS= read -r line
do
  # 予測時間の行を抽出
  if [[ $line == *"予測時間"* ]]; then
    # 数値と倍数を抽出
    time=$(echo $line | grep -o -E '[0-9\.]+h' | grep -o -E '[0-9\.]+')
    multiplier=$(echo $line | grep -o -E 'x[ ]*[0-9]+' | grep -o -E '[0-9]+')

    # 倍数が存在する場合は計算
    if [[ $multiplier != "" ]]; then
      time=$(echo "$time * $multiplier" | bc)
    fi

    # 予測時間を合計に追加
    total=$(echo "$total + $time" | bc)
  fi
done < "$newest_file"

# 予測時間の合計を出力
echo "Total predicted time: $total hours"