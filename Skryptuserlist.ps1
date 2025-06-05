# Skrypt: Pokazuje założone profile użytkowników i zapisuje je do pliku CSV

# Ścieżka do klucza rejestru zawierającego profile użytkowników
$profileListPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList'

# Pobierz dane o profilach
$profiles = Get-ChildItem -Path $profileListPath | ForEach-Object {
    $sid = $_.PSChildName
    $profilePath = (Get-ItemProperty -Path $_.PSPath).ProfileImagePath

    # Filtruj konta techniczne
    if ($profilePath -and ($profilePath -notlike "*systemprofile*") -and ($profilePath -notlike "*LocalService*") -and ($profilePath -notlike "*NetworkService*")) {
        [PSCustomObject]@{
            SID         = $sid
            ProfilePath = $profilePath
            UserName    = Split-Path -Leaf $profilePath
        }
    }
}

# Ścieżka do zapisu na pulpicie
$outputPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "ProfileList.csv")

# Zapisz dane do pliku CSV
$profiles | Export-Csv -Path $outputPath -NoTypeInformation -Encoding UTF8

# Potwierdzenie
Write-Host "Dane zapisane do pliku: $outputPath" -ForegroundColor Green
