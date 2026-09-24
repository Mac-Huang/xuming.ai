param(
    [string]$Test = "all",
    [switch]$List,
    [switch]$KeepGoing
)

$ErrorActionPreference = "Stop"

function Resolve-Tool([string]$value, [string]$defaultName) {
    if ([string]::IsNullOrWhiteSpace($value)) { $value = $defaultName }
    $cmd = Get-Command $value -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $cmd) { return $cmd.Source }
    return $value
}

$iverilog = Resolve-Tool $env:IVERILOG "iverilog.exe"
$vvp = Resolve-Tool $env:VVP "vvp.exe"
$iverilogFlags = $env:IVERILOG_FLAGS
if ([string]::IsNullOrWhiteSpace($iverilogFlags)) { $iverilogFlags = "-g2001" }

$buildDir = "build"
if (!(Test-Path $buildDir)) { New-Item -ItemType Directory -Path $buildDir | Out-Null }

$rtl = @(
    "rtl/cache.v",
    "rtl/hart.v",
    "rtl/decode.v",
    "rtl/execute.v",
    "rtl/memory.v",
    "rtl/writeback.v"
)
$lib = @(
    "lib/alu.v",
    "lib/alu_control_unit.v",
    "lib/imm.v",
    "lib/rf.v"
)

$tests = @{}
$tests["unit_alu"] = @{ Top = "unit_alu_tb"; Sources = @("tests/unit_alu_tb.v", "lib/alu.v") }
$tests["unit_alu_control_unit"] = @{ Top = "unit_alu_control_unit_tb"; Sources = @("tests/unit_alu_control_unit_tb.v", "lib/alu_control_unit.v") }
$tests["unit_imm"] = @{ Top = "unit_imm_tb"; Sources = @("tests/unit_imm_tb.v", "lib/imm.v") }
$tests["unit_rf"] = @{ Top = "unit_rf_tb"; Sources = @("tests/unit_rf_tb.v", "lib/rf.v") }
$tests["unit_writeback"] = @{ Top = "unit_writeback_tb"; Sources = @("tests/unit_writeback_tb.v", "rtl/writeback.v") }
$tests["unit_memory"] = @{ Top = "unit_memory_tb"; Sources = @("tests/unit_memory_tb.v", "rtl/memory.v") }
$tests["unit_execute"] = @{ Top = "unit_execute_tb"; Sources = @("tests/unit_execute_tb.v", "rtl/execute.v", "lib/alu_control_unit.v", "lib/alu.v") }
$tests["unit_decode"] = @{ Top = "unit_decode_tb"; Sources = @("tests/unit_decode_tb.v", "rtl/decode.v", "lib/rf.v", "lib/imm.v") }
$tests["unit_hart"] = @{ Top = "unit_hart_tb"; Sources = @("tests/unit_hart_tb.v", "rtl/tb_memory.v") + $rtl + $lib }

if ($List) {
    $tests.Keys | Sort-Object | ForEach-Object { Write-Output $_ }
    exit 0
}

function Run-Test([string]$name) {
    if (!$tests.ContainsKey($name)) {
        throw "Unknown test '$name'. Use -List to see available tests."
    }
    $top = $tests[$name].Top
    $srcs = $tests[$name].Sources
    $out = Join-Path $buildDir "$name.out"

    Write-Host "==> Compile $name"
    if (Test-Path $out) { Remove-Item -Force $out }
    & $iverilog $iverilogFlags -s $top -o $out @srcs
    if ($LASTEXITCODE -ne 0) { throw "iverilog failed for $name" }

    Write-Host "==> Run $name"
    & $vvp $out
    if ($LASTEXITCODE -ne 0) { throw "vvp failed for $name" }
}

if ($Test -eq "all") {
    $failed = 0
    foreach ($name in ($tests.Keys | Sort-Object)) {
        try {
            Run-Test $name
        } catch {
            Write-Host $_.Exception.Message
            $failed = 1
            if (-not $KeepGoing) { break }
        }
    }
    exit $failed
} else {
    Run-Test $Test
}
