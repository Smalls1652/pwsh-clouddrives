$internalFunctions = Get-ChildItem -Path ([System.IO.Path]::Combine($PSScriptRoot, "functions\internal\")) -Recurse | Where-Object { $PSItem.Extension -eq ".ps1" }

foreach ($item in $internalFunctions) {
    . "$($item.FullName)"
}

$functionsBefore = Get-ChildItem -Path "Function:\"
$exportableFunctions = Get-ChildItem -Path ([System.IO.Path]::Combine($PSScriptRoot, "functions\exportable\")) -Recurse | Where-Object { $PSItem.Extension -eq ".ps1" }
foreach ($item in $exportableFunctions) {
    . "$($item.FullName)"
}

$functionsAfter = Get-ChildItem -Path "Function:\" | Where-Object { $PSItem -notin $functionsBefore }
foreach ($func in $functionsAfter) {
    Export-ModuleMember -Function $func.Name
}