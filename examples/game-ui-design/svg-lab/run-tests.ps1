param(
    [string]$Godot = 'Godot',
    [ValidateSet('all','hud','inventory','pause','shop')][string]$Screen = 'all'
)
$ErrorActionPreference = 'Stop'
$godotPath = (Get-Command $Godot -ErrorAction Stop).Source
$evidencePath = Join-Path $PSScriptRoot 'evidence'
New-Item -ItemType Directory -Path $evidencePath -Force | Out-Null
$selectedScreen = if ($Screen -eq 'all') { 'hud' } else { $Screen }
$arguments = @('--path', ('"{0}"' -f $PSScriptRoot), '--rendering-method', 'gl_compatibility', '--audio-driver', 'Dummy', '--log-file', ('"{0}"' -f (Join-Path $evidencePath 'godot.log')), '--', '--test', ('--screen=' + $selectedScreen), ('--capture-dir="{0}"' -f $evidencePath))
if ($Screen -ne 'all') { $arguments += '--only=' + $Screen }
$process = Start-Process -FilePath $godotPath -ArgumentList $arguments -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $evidencePath 'stdout.log') -RedirectStandardError (Join-Path $evidencePath 'stderr.log')
if (-not $process.WaitForExit(60000)) {
    $process.Kill()
    throw 'Godot test exceeded 60 seconds. Its process was stopped.'
}
Get-Content -LiteralPath (Join-Path $evidencePath 'stdout.log')
Get-Content -LiteralPath (Join-Path $evidencePath 'stderr.log')
if ($process.ExitCode -ne 0) { throw ('Godot tests failed with exit code ' + $process.ExitCode) }
$report = Get-Content -LiteralPath (Join-Path $evidencePath 'test-results.json') -Raw | ConvertFrom-Json
if ($report.failures -ne 0) { throw 'The test report contains failures.' }
Write-Output ('Passed ' + $report.checks + ' checks with ' + $report.engine)
