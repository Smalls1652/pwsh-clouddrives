function Get-iCloudDefaultPath {
    [CmdletBinding()]
    param()

    $allOsPlats = @(
        [System.Runtime.InteropServices.OSPlatform]::FreeBSD,
        [System.Runtime.InteropServices.OSPlatform]::Linux,
        [System.Runtime.InteropServices.OSPlatform]::OSX,
        [System.Runtime.InteropServices.OSPlatform]::Windows
    )

    $validOsPlats = @(
        [System.Runtime.InteropServices.OSPlatform]::OSX,
        [System.Runtime.InteropServices.OSPlatform]::Windows
    )

    $osPlatform = $null

    foreach ($os in $allOsPlats) {
        switch ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform($os)) {
            $true {
                $osPlatform = $os
                break
            }
        }
    }

    $iCloudPath = $null
    switch ($osPlatform -notin $validOsPlats) {
        $true {
            $PSCmdlet.ThrowTerminatingError(
                [System.Management.Automation.ErrorRecord]::new(
                    [System.Exception]::new("Your operating system isn't supported with iCloud."),
                    "InvalidOS",
                    [System.Management.Automation.ErrorCategory]::InvalidOperation,
                    $osPlatform
                )
            )
        }

        Default {
            switch ($osPlatform) {
                [System.Runtime.InteropServices.OSPlatform]::Windows {
                    $iCloudPath = $null
                    break
                }

                Default {
                    $userName = [System.Environment]::GetEnvironmentVariable("USER")
                    $iCloudPath = [System.IO.Path]::Join("/Users/", $userName, "/Library/Mobile Documents/com~apple~CloudDocs/")
                    break
                }
            }
            break
        }
    }

    return $iCloudPath
}