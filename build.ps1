param(
    [Parameter(Mandatory)]
    [string]$Version
)

$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
$export = Join-Path $root "export"
$build = Join-Path $root ".build"
$datapackStage = Join-Path $build "datapack"
$modStage = Join-Path $build "mod"
$baseName = "massweightcompat-$Version"

function Reset-Directory {
    param([string]$Path)

    Remove-Item -LiteralPath $Path -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path $Path | Out-Null
}

function Copy-Datapack {
    param([string]$Destination)

    Copy-Item -LiteralPath (Join-Path $root "README.md") -Destination $Destination
    Copy-Item -LiteralPath (Join-Path $root "pack.mcmeta") -Destination $Destination
    Copy-Item -LiteralPath (Join-Path $root "pack.png") -Destination $Destination
    Copy-Item -LiteralPath (Join-Path $root "data") -Destination $Destination -Recurse
}

function New-Zip {
    param(
        [string]$Source,
        [string]$Destination
    )

    Remove-Item -LiteralPath $Destination -Force -ErrorAction SilentlyContinue
    [System.IO.Compression.ZipFile]::CreateFromDirectory($Source, $Destination)
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

Reset-Directory -Path $build
New-Item -ItemType Directory -Path $export -Force | Out-Null
New-Item -ItemType Directory -Path $datapackStage | Out-Null
New-Item -ItemType Directory -Path $modStage | Out-Null

Copy-Datapack -Destination $datapackStage
Copy-Datapack -Destination $modStage
Copy-Item -Path (Join-Path $root "mod-metadata/*") -Destination $modStage -Recurse

$metadataFiles = @(
    (Join-Path $modStage "fabric.mod.json"),
    (Join-Path $modStage "META-INF/neoforge.mods.toml")
)

foreach ($file in $metadataFiles) {
    $content = Get-Content -LiteralPath $file -Raw
    $content = $content.Replace("@VERSION@", $Version)
    Set-Content -LiteralPath $file -Value $content -NoNewline
}

$datapackZip = Join-Path $export "$baseName.zip"
$modJar = Join-Path $export "$baseName.jar"

New-Zip -Source $datapackStage -Destination $datapackZip
New-Zip -Source $modStage -Destination $modJar

Remove-Item -LiteralPath $build -Recurse -Force

Write-Host "Built:"
Write-Host "  $datapackZip"
Write-Host "  $modJar"
