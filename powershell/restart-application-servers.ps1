# Definice proměnných pro první skupinu serverů + kontrola služeb na serverech 52,184 před jejich restartem
$servers1 = @("server51", "server183")
$logFile1 = "E:\Log\TasksTest\RestartServer51_183.txt"  
$serversToCheckBefore1 = @("server52", "server184")  

$restartAllowed1 = $true  
foreach ($server in $serversToCheckBefore1) {
    Write-Output "Checking services on server: $server before restarting $servers1"

    $stoppedServices = Get-WmiObject Win32_Service -ComputerName $server | 
        Where-Object { $_.StartName -like "IC\Appl*" -and $_.State -ne "Running" -and $_.StartMode -ne "Disabled" } |
        Select-Object Name, DisplayName, StartName, State, StartMode

    if ($stoppedServices) {
        Write-Output "Some services on $server are not running. Skipping restart of $servers1!"
        $restartAllowed1 = $false
    }
}

if ($restartAllowed1) {
    try {
        if (Test-Path $logFile1) {
            Remove-Item $logFile1
        }
        Start-Transcript -Path $logFile1 -Append

        foreach ($server in $servers1) {
            try {
                Write-Output "Restarting server: $server"
                Restart-Computer -ComputerName $server -Force -ErrorAction Stop
                Write-Output "Restart command sent successfully to $server."
            } catch {
                Write-Error "Failed to restart $server. Error: $_"
            }
        }

        Stop-Transcript
    } catch {
        Write-Error "An error occurred while handling the script. Error: $_"
        Stop-Transcript
    }
} else {
    Write-Output "Skipping restart for servers $servers1 due to unresolved service issues."
}


Start-Sleep -Seconds 3600

# Definice promměnných + kontrola služeb na serverech 51, 183 před jejich restartem
$serversToCheckBefore2 = @("server51", "server183")  
$servers2 = @("server52", "server184")  
$logFile2 = "E:\Log\TasksTest\RestartServer52_184.txt"
$restartAllowed2 = $true  

foreach ($server in $serversToCheckBefore2) {
    Write-Output "Checking services on server: $server before restarting $servers2"

    $stoppedServices = Get-WmiObject Win32_Service -ComputerName $server | 
        Where-Object { $_.StartName -like "IC\Appl*" -and $_.State -ne "Running" -and $_.StartMode -ne "Disabled" } |
        Select-Object Name, DisplayName, StartName, State, StartMode

    if ($stoppedServices) {
        Write-Output "Some services on $server are not running. Skipping restart of $servers2!"
        $restartAllowed2 = $false
    }
}

if ($restartAllowed2) {
    try {
        if (Test-Path $logFile2) {
            Remove-Item $logFile2
        }
        Start-Transcript -Path $logFile2 -Append

        foreach ($server in $servers2) {
            try {
                Write-Output "Restarting server: $server"
                Restart-Computer -ComputerName $server -Force -ErrorAction Stop
                Write-Output "Restart command sent successfully to $server."
            } catch {
                Write-Error "Failed to restart $server. Error: $_"
            }
        }

        Stop-Transcript
    } catch {
        Write-Error "An error occurred while handling the script. Error: $_"
        Stop-Transcript
    }
} else {
    Write-Output "Skipping restart for servers $servers2 due to unresolved service issues."
}

