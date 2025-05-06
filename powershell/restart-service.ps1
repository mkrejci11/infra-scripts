$server1 = "server51"
$server2 = "server52"
$serviceName = "EULinka"
$processName = "EULG2IC_wcf_x64"
$logFile = "E:\Log\TasksTest\RestartEUL.txt"

if (Test-Path $logFile) {
    Remove-Item $logFile -Force
}

Start-Transcript -Path $logFile -Append

# checking if the service is running
function Check-ServiceRunning {
    param (
        [string]$server,
        [string]$service
    )
    $status = Get-Service -ComputerName $server -Name $service -ErrorAction SilentlyContinue
    if ($status -and $status.Status -eq "Running") {
        Write-Output "Service $service on server $server is running."
        return $true
    } else {
        Write-Output "Service $service on server $server is not running!"
        return $false
    }
}

# restart service + kill orphan
function Restart-ServiceForce {
    param (
        [string]$server,
        [string]$service,
        [string]$processName
    )

    Write-Output "Restart service $service on server $server..."

    try {
        Invoke-Command -ComputerName $server -ScriptBlock {
            param ($service, $processName)

            
            Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 10  

            # kill orphan
            $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
            if ($processes) {
                foreach ($process in $processes) {
                    Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
                    Write-Output "Process $($process.Name) with PID $($process.Id) has been terminated."
                }
            }

            $maxRetries = 12  
            $retry = 0
            do {
                $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
                if ($svc.Status -eq 'Stopped') {
                    break
                }
                Start-Sleep -Seconds 10
                $retry++
            } while ($retry -lt $maxRetries)

            if ($svc.Status -ne 'Stopped') {
                throw "The service $service on the server did not stop even after waiting."
            }

            Start-Service -Name $service
            Write-Output "The service $service was succesfully restarted."

        } -ArgumentList $service, $processName

    } catch {
        Write-Error "Error while restarting the service $service on server ${server}: $_"
        throw $_  
    }
}

Write-Output "=== Start script ==="

# checking if service on server2 is running before restart server1
if (Check-ServiceRunning -server $server2 -service $serviceName) {
    Write-Output "Everything OK, continuing with restart service on $server1..."
    Restart-ServiceForce -server $server1 -service $serviceName -processName $processName
} else {
    Write-Output "The service $serviceName on server $server2 is not running! Script is terminating."
    Stop-Transcript
    exit 1
}

Write-Output "Waiting 1 hour before restart second service"
Start-Sleep -Seconds 3600

# checking if service on server1 is running before restart server2
if (Check-ServiceRunning -server $server1 -service $serviceName) {
    Write-Output "Everything OK, continuing with restart service on $server2..."
    Restart-ServiceForce -server $server2 -service $serviceName -processName $processName
} else {
    Write-Output "The service $serviceName on server $server1 is not running! Script is terminating."
    Stop-Transcript
    exit 1
}

Write-Output "=== Script completed successfully ==="


Stop-Transcript
