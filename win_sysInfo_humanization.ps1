# 获取主机系统版本
function get_type() {
    Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty Caption
}

# 获取主机ip
function get_ip() {
    (ipconfig | select-string "IPv4" | out-string).Trim().Split(":")[-1]
}

# 获取时间

function get_date(){
    Get-Date
}


# 获取 C 磁盘使用率
function c_get_disk_used_percent() {
    $c_disk = Get-WmiObject -Class win32_logicaldisk -Filter 'DeviceId = "C:"' 
    $c_allSpace = $c_disk.Size 
    $c_allSpace = (($c_allSpace | Measure-Object -Sum).sum / 1gb)
    $c_FreeSpace = $c_disk.FreeSpace 
    $c_FreeSpace = (($c_FreeSpace | Measure-Object -Sum).sum / 1gb)
    $c_disk_used_percent = (($c_FreeSpace / $c_allSpace) * 100)
    return @($c_disk_used_percent)
}

# 获取 D 磁盘使用率
function d_get_disk_used_percent() {
    $d_disk = Get-WmiObject -Class win32_logicaldisk -Filter 'DeviceId = "D:"' 
    $d_allSpace = $d_disk.Size 
    $d_allSpace = (($d_allSpace | Measure-Object -Sum).sum / 1gb)
    $d_FreeSpace = $d_disk.FreeSpace 
    $d_FreeSpace = (($d_FreeSpace | Measure-Object -Sum).sum / 1gb)
    $d_disk_used_percent = (($d_FreeSpace / $d_allSpace) * 100)
    return @($d_disk_used_percent)
}

# 获取 E 磁盘使用率
function e_get_disk_used_percent() {
    $e_disk = Get-WmiObject -Class win32_logicaldisk -Filter 'DeviceId = "E:"' 
    $e_allSpace = $e_disk.Size 
    $e_allSpace = (($e_allSpace | Measure-Object -Sum).sum / 1gb)
    $e_FreeSpace = $e_disk.FreeSpace 
    $e_FreeSpace = (($e_FreeSpace | Measure-Object -Sum).sum / 1gb)
    $e_disk_usee_percent = (($e_FreeSpace / $e_allSpace) * 100)
    return @($e_disk_usee_percent)
}
 
# 获取 CPU 使用率
function cpu_percent() {
    $counter = New-Object Diagnostics.PerformanceCounter 
    $counter.CategoryName = "Processor"
    $counter.CounterName = "% Processor Time"
    $counter.InstanceName = "_Total"

    $count = 2;
    $cpu = 0, 0

    for ($i = 0; $i -lt $count; $i++) {
        $value = $counter.NextValue()
        $cpu[$i] = $value
        Start-Sleep 1
    }

    $Havecpu = $cpu[1]

    return $Havecpu
}
 
# 获取内存使用率
function phy_percent() {
    $men = Get-WmiObject -Class win32_OperatingSystem
    $Permem = ((($men.TotalVisibleMemorySize - $men.FreePhysicalMemory) / $men.TotalVisibleMemorySize) * 100)
    return @($Permem)
}

Write-Output "============================================================="
Write-Output "sys_version:  $(get_type)"
Write-Output "sys_ip:  $(get_ip)"
Write-Output "now_time:  $(get_date)"
Write-Output "============================================================="
Write-Output "ram_used (%):  $(phy_percent)"
Write-Output "cpu_used (%):  $(cpu_percent)"
Write-Output "C_disk_free (%):  $(c_get_disk_used_percent)"
Write-Output "D_disk_free (%):  $(d_get_disk_used_percent)"
Write-Output "E_disk_free (%):  $(e_get_disk_used_percent)`n"