#!/bin/bash

# デフォルトのディレクトリ
default_dir="/path/to/default/directory"
make_dir="/path/to/make/directory"
sup_dir="/path/to/sup/directory"
local_dir="/path/to/local/directory"

# オプションを解析する
while getopts dmsl opt
do
  case $opt in
    d)
      dir=$default_dir
      ;;
    m)
      dir=$make_dir
      ;;
    s)
      dir=$sup_dir
      ;;
    l)
      dir=$local_dir
      ;;
    \?)
      echo "Usage: $0 [-d|-m|-s|-l]"
      exit 1
      ;;
  esac
done

# ディレクトリが存在するかチェックする
if [ ! -d "$dir" ]
then
  echo "Directory $dir does not exist."
  exit 1
fi

# OSによってコマンドを変える
case $(uname) in
  Darwin)
    # macOS
    open "$dir"
    ;;
  CYGWIN*|MINGW32*|MSYS*|MINGW*)
    # Windows
    explorer.exe "$(cygpath -w "$dir")"
    ;;
  *)
    # Linux
    xdg-open "$dir"
    ;;
esac