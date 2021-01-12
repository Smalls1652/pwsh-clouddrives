function New-PSCloudDrive {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory)]
        [ValidateSet(
            "iCloud"
        )]
        [string]$Provider,
        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        [Parameter(Position = 2)]
        [string]$Path
    )

    $mountPath = $null
    switch ([string]::IsNullOrEmpty($Path)) {
        $false {
            $mountPath = Resolve-Path -Path $Path -ErrorAction "Stop"
            break
        }

        Default {
            switch ($Provider) {
                "iCloud" {
                    $mountPath = Get-iCloudDefaultPath
                    break
                }
            }
            break
        }
    }

    $driveName = $null
    switch ([string]::IsNullOrEmpty($Name)) {
        $false {
            $driveName = $Name
            break
        }

        Default {
            $driveName = $Provider
            break
        }
    }

    $newPsDriveSplat = @{
        "Name"        = $driveName;
        "PSProvider"  = "FileSystem";
        "Root"        = $mountPath;
        "Scope"       = "Global";
        "ErrorAction" = "Stop";
    }

    New-PSDrive @newPsDriveSplat
}