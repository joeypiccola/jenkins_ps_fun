# take pipeline param buildspec, make it pretty json, and write it to a file
$env:buildspec | ConvertFrom-Json | ConvertTo-Json | Add-Content -Path '.\builddata.json'