#!/bin/bash

# =============== 参数配置 ===============
# 结果文件存放位置
date=$(date +%Y_%m_%d_%H_%M_%S)
output_file_calculation="/root/sh/result/linux_sysInfo_calculation_"${date}".txt"
output_file_humanization="/root/sh/result/linux_sysInfo_humanization_"${date}".txt"

# 待巡检服务器列表。有多少放多少
service=(
    100.100.100.1
    100.100.100.2
    100.100.100.3
)

# 上方服务器的登录账号。注意与上方服务器的对应，错了就寄了
user=(
    root
    root
    root
)

# 上方服务器的登陆密码，注意与上方服务器和账号的对应，错了就寄了
pwd=(
    password
    password
    password
)

# 颜色库
RED='\e[1;31m'    # 红
GREEN='\e[1;32m'  # 绿
YELLOW='\e[1;33m' # 黄
BLUE='\e[1;34m'   # 蓝
PINK='\e[1;35m'   # 粉红
RES='\e[0m'       # 清除颜色



# =============== 开始运行脚本 ===============
# 来点打印在屏幕上的个性提示
printf "+-----------------------------------------+\n"
printf "| ${BLUE}                 SRAT                   ${RES}|\n"
printf "|    (Server Resource Acquisition Tool)   |\n"
printf "|              Linux Version              |\n"
printf "|  https://github.com/NightingaleWK/SRAT  |\n"
printf "+-----------------------------------------+\n"
printf "${GREEN}[SRAT] Let's the party began${RES}   ${BLUE}o(≧▽≦*)o${RES}\n"

# 先生成用于统计的短文件
printf "${GREEN}[SRAT] NOTE : Total 2 steps. We will build the short version first, and then the human version${RES}\n"
printf "${GREEN}[1/2] Start short version${RES}\n"

# 循环计数器
count=0

# 设置文件内容的头部信息
printf "ip,date,cpu,mem,biggest_disk_free" >>${output_file_calculation}
printf "\n" >>${output_file_calculation}

for ip in ${service[@]}; do

    # cpu平均使用率
    cpu=$(sshpass -p ${pwd[count]} ssh ${user[count]}@${ip} "cat /proc/loadavg | awk '{print (\$1)/100}'")
    # 内存使用率
    mem=$(sshpass -p ${pwd[count]} ssh ${user[count]}@${ip} "free -m | sed -n '2p' | awk '{print \$3/\$2}'")
    # 硬盘空闲率
    disk=$(sshpass -p ${pwd[count]} ssh ${user[count]}@${ip} "df | sort -nr -k 2 | sed -n '1p' | awk '{print (100-\$5)/100}'")

    # 将结果导入文件
    printf ${ip}","${date}","${cpu}","${mem}","${disk} >>${output_file_calculation}
    printf "\n" >>${output_file_calculation}

    # 打印进度到屏幕
    printf "${GREEN}√${RES} "${ip}"\n"

    # 计数器自增1
    let count++
done

printf "${GREEN}[1/2] Finish short version${RES}\n"

# 再生成可读性高的完整文件
printf "${GREEN}[2/2] Start human version${RES}\n"

# 循环计数器
count=0

for ip in ${service[@]}; do

    printf "=================================================\n" >>${output_file_humanization}
    printf "🟢 "${ip} >>${output_file_humanization}
    printf "\n=================================================\n" >>${output_file_humanization}

    # cpu平均使用率
    printf "⚡ Cpu used (%%) : " >>${output_file_humanization}
    sshpass -p ${pwd[count]} ssh ${user[count]}@${ip} "cat /proc/loadavg | awk '{print \$1}'" >>${output_file_humanization}

    # 内存使用率
    # free -m | sed -n '2p' | awk '{print "Mem used is "$3/$2*100"%"}'
    printf "📝 Mem used (%%) : " >>${output_file_humanization}
    sshpass -p ${pwd[count]} ssh ${user[count]}@${ip} "free -m | sed -n '2p' | awk '{print \$3/\$2*100}'" >>${output_file_humanization}

    # 硬盘空闲率
    printf "📂 Biggest disk free (%%) : " >>${output_file_humanization}
    sshpass -p ${pwd[count]} ssh ${user[count]}@${ip} "df | sort -nr -k 2 | sed -n '1p' | awk '{print 100-\$5}'" >>${output_file_humanization}

    printf "\n" >>${output_file_humanization}
    sshpass -p ${pwd[count]} ssh ${user[count]}@${ip} "date" >>${output_file_humanization}
    printf "\n" >>${output_file_humanization}
    sshpass -p ${pwd[count]} ssh ${user[count]}@${ip} "free -h" >>${output_file_humanization}
    printf "\n" >>${output_file_humanization}
    sshpass -p ${pwd[count]} ssh ${user[count]}@${ip} "df -h" >>${output_file_humanization}
    printf "\n" >>${output_file_humanization}
    sshpass -p ${pwd[count]} ssh ${user[count]}@${ip} "top -b -n 1 -d 3" >>${output_file_humanization}

    printf "${GREEN}√${RES} "${ip}"\n"

    # 计数器自增1
    let count++
done

printf "${GREEN}[2/2] Finish human version. All tasks have been completed${RES}\n"
printf "${GREEN}[SRAT] Bye, see you again${RES}   ${BLUE}o(≧▽≦*)o${RES}\n"
