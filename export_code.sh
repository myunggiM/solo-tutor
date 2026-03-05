Get-ChildItem -Path lib -Filter *.dart -Recurse | ForEach-Object { 
    $filename = $_.FullName
    Add-Content -Path all_code.txt -Value "`n// FILE: $filename"
    Get-Content -Path $filename | Add-Content -Path all_code.txt
}