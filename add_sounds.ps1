$files = Get-ChildItem ".\assets\images\session 3"

foreach ($file in $files) {
    Write-Host "{"
    Write-Host "  'title': '',"
    Write-Host "  'soundPath': '$($file.BaseName).mp3',"
    Write-Host "  'imagePath': '$($file)',"
    Write-Host "  'searchString': '',"
    Write-Host "},"
}