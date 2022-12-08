# 确定输出文件文件名（带时间戳）
$time = Get-Date -format 'yyyy_MM_dd_HH_mm_ss'
$file_name_calculation = 'C:\inspectionByCestc\result\win_sysInfo_calculation_' + $time + '.txt'
$file_name_humanization = 'C:\inspectionByCestc\result\win_sysInfo_humanization_' + $time + '.txt'

# 远端执行的代码
$code_calculation = 'powershell C:\inspectionByCestc\win_sysInfo_calculation.ps1'
$code_humanization = 'powershell C:\inspectionByCestc\win_sysInfo_humanization.ps1'

# 待巡检的 Windows 主机地址
$server = (
    'http://100.100.100.2:5985',
    'http://100.100.100.3:5985',
    'http://100.100.100.4:5985'
)

# 上方主机对应的账号
$user = (
    'Administrator',
    'Administrator',
    'Administrator'
)

# 上方主机对应的账号密码
$user_password = (
    'password',
    'password',
    'password'
)

# 开始巡检
Write-Output "+-----------------------------------------+"
Write-Output "|                  SRAT                   |"
Write-Output "|    (Server Resource Acquisition Tool)   |"
Write-Output "|             Windows Version             |"
Write-Output "|  https://github.com/NightingaleWK/SRAT  |"
Write-Output "+-----------------------------------------+"

Write-Host "[SRAT] Let's the party began >_<`n" -ForegroundColor:Green
Write-Host "[SRAT] NOTE : Total 2 steps. We will build the short version first, and then the human version`n" -ForegroundColor:Green

# 先生成用于统计的短文件
Write-Host "[1/2] Start short version" -ForegroundColor:Green
"sys_version,sys_ip,now_time,cpu_used,ram_used,C_disk_free,D_disk_free,E_disk_free" >> $file_name_calculation

for ($i = 0; $i -lt $server.Length; $i++) {

    # 核心语句
    winrs -r:$server[$i] -u:$user[$i] -p:$user_password[$i] $code_calculation >> $file_name_calculation

    $message = 'Checking ' + $server[$i]
    Write-Host $message.PadRight(50), "[ " -NoNewline #输出前半截，不换行
    Write-Host "OK" -ForegroundColor:Green -NoNewline #输出状态，并设置格式
    Write-Host " ]" #输出最后的括号并换行
}

Write-Host "`n[1/2] Finish short version`n" -ForegroundColor:Green

# 再生成可读性高的完整文件
Write-Host "[2/2] Start human version" -ForegroundColor:Green

for ($i = 0; $i -lt $server.Length; $i++) {   
    winrs -r:$server[$i] -u:$user[$i] -p:$user_password[$i] $code_humanization >> $file_name_humanization

    $message = 'Checking ' + $server[$i]
    Write-Host $message.PadRight(50), "[ " -NoNewline #输出前半截，不换行
    Write-Host "OK" -ForegroundColor:Green -NoNewline #输出状态，并设置格式
    Write-Host " ]" #输出最后的括号并换行
}

Write-Host "`n[2/2] Finish human version" -ForegroundColor:Green

Write-Host "`n[SRAT] Bye, see you again OwO`n" -ForegroundColor:Green #输出状态，并设置格式
