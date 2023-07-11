# Script sauvegarde des personnages de toutes les maps ( 6h )
# Autoriser les scripts via PowerShell ISE : Set-ExecutionPolicy RemoteSigned
# Dossier requis pour le bon fonctionnement : "C:\asmdata\Servers\_backup_profile"

# Chemins des dossiers contenant les fichiers .arkprofile pour chaque serveur
$server1SourceFolder = "C:\asmdata\Servers\Server1\ShooterGame\Saved\SavedArks"
$server2SourceFolder = "C:\asmdata\Servers\Server3\ShooterGame\Saved\SavedArks"
$server3SourceFolder = "C:\asmdata\Servers\Server4\ShooterGame\Saved\SavedArks"

# Dossier parent pour les sauvegardes
$backupParentFolder = "C:\asmdata\Servers\_backup_profile"

# Fonction pour effectuer la sauvegarde pour un dossier source donné
function PerformBackup($serverName, $sourceFolder) {
    # Obtient le nom du dossier source
    $serverNumber = $serverName.Substring($serverName.Length - 1)
    
    # Chemin du dossier de sauvegarde pour le serveur actuel
    $backupFolder = Join-Path -Path $backupParentFolder -ChildPath $serverName
    
    # Crée le dossier de sauvegarde s'il n'existe pas
    if (!(Test-Path -Path $backupFolder)) {
        New-Item -ItemType Directory -Path $backupFolder | Out-Null
    }

    # Obtenir la date courante
    $currentDate = Get-Date -Format "yyyyMMdd"
    
    # Crée le sous-dossier avec la date courante s'il n'existe pas
    $backupSubFolder = Join-Path -Path $backupFolder -ChildPath $currentDate
    if (!(Test-Path -Path $backupSubFolder)) {
        New-Item -ItemType Directory -Path $backupSubFolder | Out-Null
    }

    # Copie les fichiers .arkprofile dans le dossier de sauvegarde avec un timestamp et le nom du serveur
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    Get-ChildItem -Path $sourceFolder -Filter "*.arkprofile" | ForEach-Object {
        $backupPath = Join-Path -Path $backupSubFolder -ChildPath ($timestamp + "_Server$serverNumber_" + $_.Name)
        Copy-Item -Path $_.FullName -Destination $backupPath -Force
    }
	
    Clear
    Write-Host "Sauvegarde effectuée avec succès pour le serveur $serverName dans $backupSubFolder"
}

# Fonction pour effectuer le décompte toutes les heures
function Countdown {
    $countdownHours = 6
    $countdownInterval = 1

    while ($countdownHours -gt 0) {
        Write-Host "Temps restant avant la prochaine sauvegarde : $countdownHours heures"
        Start-Sleep -Seconds ($countdownInterval * 3600)
        $countdownHours -= $countdownInterval
    }
}

# Appelle la fonction de sauvegarde pour chaque dossier source
PerformBackup "Server1" $server1SourceFolder
PerformBackup "Server2" $server2SourceFolder
PerformBackup "Server3" $server3SourceFolder

# Démarre le décompte initial
Countdown

# Fonction pour exécuter la sauvegarde toutes les 6 heures
function ScheduleBackup {
    while ($true) {
        # Appelle la fonction de sauvegarde pour chaque dossier source
        PerformBackup "Server1" $server1SourceFolder
        PerformBackup "Server2" $server2SourceFolder
        PerformBackup "Server3" $server3SourceFolder

        # Effectue le décompte avant la prochaine sauvegarde
        Countdown
    }
}

# Démarrer la planification de sauvegarde initiale
ScheduleBackup

