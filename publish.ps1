$nuget = Join-Path $env:USERPROFILE "Downloads\nuget.exe" -Resolve

$manifest = Test-ModuleManifest -Path "PSUbi.HelloWorld.psd1"

$nuspec = @"
<?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd">
    <metadata>
        <id>$($manifest.Name)</id>
        <version>$($manifest.Version)</version>
        <authors>$($manifest.Author)</authors>
        <owners>$($manifest.Author)</owners>
        <requireLicenseAcceptance>false</requireLicenseAcceptance>
        <description>$($manifest.Description)</description>
        <releaseNotes />
        <copyright />
        <tags>PSModule</tags>
    </metadata>
</package>
"@

$tmp = Join-Path $PSScriptRoot "build-$(Get-Random)"
$null = New-Item $tmp -ItemType Directory

$nuspecFile = Join-Path $tmp "$($manifest.Name).nuspec"

Set-Content -Path $nuspecFile -Value $nuspec -Force
Copy-Item -Path "PSUbi.HelloWorld.psd1","Write-PSUbiHelloWorld.ps1","README.md","LICENSE" -Destination $tmp

& $nuget pack $nuspecFile -BasePath $tmp -OutputDirectory $PSScriptRoot

#& $nuget push "PSUbi.HelloWorld.1.0.0.nupkg" -Source "psteniusubi" -Verbosity detailed

$null = Remove-Item -Path $tmp -Recurse -Force
