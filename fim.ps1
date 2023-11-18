
Write-Host "`nwhat would you like to do?"
Write-Host "`ta) collect new baseline" 
Write-Host "`tb) use existing baseline" 

$response = Read-Host -Prompt "enter 'a' or 'b'"

# returns filehash from file
Function Get-File-Hash($filepath) {
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}

Function Remove-Baseline() {
    $exists = Test-Path -Path .\baseline.txt
    if ($exists) {
        Remove-Item -Path .\baseline.txt
    }
}

# calculate hash and store in baseline.txt
if ($response -eq "A".ToUpper()) {
    # remove baseline if it exists already
    Remove-Baseline

    # collect all files in target folder
    $files = Get-ChildItem -Path .\files

    # for each file, calculate hash and write to baseline.txt
    foreach ($f in $files) {
        $hash = Get-File-Hash $f.FullName
        "$($hash.Path)|$($hash.hash)" | Out-File -FilePath .\baseline.txt -Append 
    }
}

# use existing baseline
elseif ($response -eq "B".ToUpper()) {

    # load file|hash from baseline, store in dict
    $baselineDict = @{}

    $baselineContent = Get-Content -Path .\baseline.txt
    foreach ($line in $baselineContent) {
        $baselineDict.add($line.Split("|")[0], $line.Split("|")[1])
    }

    # continuously check for differences
    while ($true) {
        Start-Sleep -Seconds 1

        $files = Get-ChildItem -Path .\files

        foreach ($f in $files) {
            $hash = Get-File-Hash $f.FullName
            
            # check if a new file has been created
            if ($null -eq $baselineDict[$hash.Path]) {
                Write-Host "$($hash.Path) has been created!" -ForegroundColor Green 
            }

            # check if a file has been changed
            elseif ($baselineDict[$hash.Path] -ne $hash.Hash) {
                Write-Host "$($hash.Path) has been changed!" -ForegroundColor Yellow
            }
        }

        foreach ($key in $baselineDict.Keys) {
            $exists = Test-Path -Path $key

            # check if a file has been deleted
            if (-Not $exists) {
                Write-Host "$($key) has been deleted!" -ForegroundColor Red
            }
        }
    }
}
