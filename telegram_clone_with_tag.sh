#!/bin/bash

# 创建 TG 分身函数
create_tg() {
    local num1="$1"

    APP_CLONE="$APP_TELEGRAM_CLONE_DIR/Telegram_$1.app"
    if [ -d "$APP_CLONE" ]; then
        echo "Directory $APP_CLONE already exists. Skipping."
    else
        cp -R /Applications/Telegram.app $APP_CLONE
        echo "Created directory $APP_CLONE."
    fi

    SUBDIR="$TELEGRAM_CLONE_DIR/$1"
    if [ -d "$SUBDIR" ]; then
        echo "Directory $SUBDIR already exists. Skipping."
    else
        mkdir "$SUBDIR"
        echo "Created directory $SUBDIR."
    fi

    # 运行 Telegram 命令
    nohup "$APP_TELEGRAM_CLONE_DIR/Telegram_$1.app/Contents/MacOS/Telegram" -workdir "$SUBDIR" > /dev/null 2>&1 &
    echo "Started Telegram instance in $SUBDIR."
}


# 解析参数，start 代表开始 TG Tag，end 代表结束 TG Tag，tag_num 代表分别开启哪些 TG Tag
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --start) shift; start="$1";;
        --end) shift; end="$1";;
        --tag_num) shift; while [[ "$#" -gt 0 && ! "$1" =~ ^-- ]]; do tag_num+=("$1"); shift; done;;
        *) echo "Unknown parameter passed: $1"; exit 1;;
    esac
    shift
done

# start 参数和 end 参数必须成对出现
if [[ -n "$start" && -z "$end" ]]; then
    echo "Error: The --start parameter and the --end parameter must both be present."
    exit 1
fi

# tag_num 参数不能和 start/end 参数一起出现
if [[ -n "$start" && -n "$end" && ${#tag_num[@]} -gt 0 ]]; then
    echo "Error: --tag_num parameter cannot be used when both --start and --end are specified."
    exit 1
fi

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

# 处理 tag_num 参数中的每个数字
if [[ ${#tag_num[@]} -gt 0 ]]; then
    for num in "${tag_num[@]}"; do
        create_tg $num;
    done
fi

# 循环创建 Telegram 分身和 Telegram 数据子文件夹
if [[ -n "$start" ]]; then
    for (( i=$start; i<=$end; i++ )); do
      create_tg $i;
    done
fi