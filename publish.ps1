param(
    [Parameter(Mandatory)]
    [string]$Version,

    [string]$Changelog = ""
)

$ErrorActionPreference = "Stop"

$headers = @{
    Authorization = "Bearer $env:MODRINTH_TOKEN"
    "User-Agent" = "khazoda/massweightcompat"
}

function Publish-Version {
    param(
        [string]$File,
        [string[]]$Loaders,
        [string]$Environment
    )

    $data = @{
        project_id = "bJLW7HUi"
        version_number = $Version
        version_title = $Version
        version_body = $Changelog
        release_channel = "release"
        featured = $false
        status = "listed"
        loaders = $Loaders
        game_versions = @("1.21.1")
        dependencies = $dependencies
        file_parts = @("file")
        primary_file = "file"
    }

    if ($Environment) {
        $data.environment = $Environment
    }

    $data = $data | ConvertTo-Json -Depth 5 -Compress

    Invoke-RestMethod `
        -Method Post `
        -Uri "https://api.modrinth.com/v3/version" `
        -Headers $headers `
        -Form ([ordered]@{
            data = $data
            file = Get-Item $File
        }) | Out-Null
}

$dependencies = @(
    @{ project_id = "T9PomCSv"; dependency_type = "required" },
    @{ project_id = "oWaK0Q19"; dependency_type = "optional" }
)

Publish-Version `
    -File "export/massweightcompat-$Version.zip" `
    -Loaders @("datapack")

Publish-Version `
    -File "export/massweightcompat-$Version.jar" `
    -Loaders @("fabric", "neoforge") `
    -Environment "server_only"
