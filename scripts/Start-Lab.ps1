# Starts this local WSL laboratory after a Windows restart. No Windows autostart changes.
$ErrorActionPreference = 'Stop'
$labWsl = Join-Path $env:ProgramFiles 'WSL\wsl.exe'
if (-not (Test-Path -LiteralPath $labWsl)) { throw 'Microsoft WSL is not installed.' }
$labExisting = Get-CimInstance Win32_Process | Where-Object {
    $_.Name -eq 'wsl.exe' -and $_.CommandLine -match 'Ubuntu-24\.04' -and
    $_.CommandLine -match 'sleep\s+infinity'
} | Select-Object -First 1
if (-not $labExisting) {
    Start-Process -FilePath $labWsl -WindowStyle Hidden -ArgumentList @(
        '--distribution','Ubuntu-24.04','--user','eldar','--exec','sleep','infinity') | Out-Null
}
& $labWsl -d Ubuntu-24.04 -u root --exec systemctl start docker jenkins
if ($LASTEXITCODE -ne 0) { throw 'Docker or Jenkins service did not start.' }
& $labWsl -d Ubuntu-24.04 -u eldar --exec bash -lc '
set -e
if docker container inspect sarsembayev-eldar-container >/dev/null 2>&1; then
  owner=$(docker inspect --format "{{index .Config.Labels \"lab.owner\"}}" sarsembayev-eldar-container)
  if [[ "$owner" != sarsembayev-eldar-devops ]]; then
    echo "Container name belongs to another project; manual review required." >&2
    exit 1
  fi
  docker start sarsembayev-eldar-container >/dev/null
fi
'
if ($LASTEXITCODE -ne 0) { throw 'The lab container could not be started safely.' }
Write-Output 'Jenkins: http://127.0.0.1:8080/'
Write-Output 'Application from Jenkins: http://127.0.0.1:8082/'
Write-Output 'Linux terminal: wsl -d Ubuntu-24.04 -u eldar'
