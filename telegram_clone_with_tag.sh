#!/bin/bash

# 检查是否提供了参数，参数一：开始数字；参数二:结束数字
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <start> <end>"
  exit 1
fi

# 获取传入的数字参数
START=$1
END=$2

# 定义 /Applications 下的分身目录
APP_TELEGRAM_CLONE_DIR="/Applications/TelegramClone"

# 检查 TelegramClone 分身目录是否存在
if [ ! -d "$APP_TELEGRAM_CLONE_DIR" ]; then
  mkdir "$APP_TELEGRAM_CLONE_DIR"
  echo "Created directory $APP_TELEGRAM_CLONE_DIR."
else
  echo "Directory $APP_TELEGRAM_CLONE_DIR already exists. Skipping creation."
fi

# 定义 telegram_clone 数据目录
TELEGRAM_CLONE_DIR="$HOME/telegram_clone"

# 检查 telegram_clone 目录是否存在
if [ ! -d "$TELEGRAM_CLONE_DIR" ]; then
  mkdir "$TELEGRAM_CLONE_DIR"
  echo "Created directory $TELEGRAM_CLONE_DIR."
else
  echo "Directory $TELEGRAM_CLONE_DIR already exists. Skipping creation."
fi

# 循环创建 Telegram 分身和 Telegram 数据子文件夹
for (( i=START; i<=END; i++ ))
do
  APP_CLONE="$APP_TELEGRAM_CLONE_DIR/Telegram_$i.app"
  if [ -d "$APP_CLONE" ]; then
      echo "Directory $APP_CLONE already exists. Skipping."
    else
      cp -R /Applications/Telegram.app $APP_CLONE
      echo "Created directory $APP_CLONE."
  fi

  SUBDIR="$TELEGRAM_CLONE_DIR/$i"
  if [ -d "$SUBDIR" ]; then
    echo "Directory $SUBDIR already exists. Skipping."
  else
    mkdir "$SUBDIR"
    echo "Created directory $SUBDIR."
  fi

  # 运行 Telegram 命令
  nohup "$APP_TELEGRAM_CLONE_DIR/Telegram_$i.app/Contents/MacOS/Telegram" -workdir "$SUBDIR" > /dev/null 2>&1 &
  echo "Started Telegram instance in $SUBDIR."
done