# ============================================
# Script para ejecutar el análisis de SonarQube
# sobre OWASP NodeGoat - Demo SAST IsraelStarTeam
# Rama: demo/sonarqube
# ============================================

# Nota: en PowerShell de Windows ejecuta primero: chcp 65001
# para evitar problemas con caracteres especiales (á, é, í, ó, ú, ñ)

# Cargar variables de entorno desde .env si existe
$envFile = Join-Path -Path $PSScriptRoot -ChildPath ".env"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match "^([^=]+)=(.*)$") {
            $envVarName = $Matches[1]
            $envVarValue = $Matches[2]
            Set-Item -Path "Env:\$envVarName" -Value $envVarValue
        }
    }
}

# Validar que exista el token
if (-not $env:SONAR_TOKEN -or $env:SONAR_TOKEN -eq "tu_token_de_sonar_aqui") {
    Write-Host "ERROR: Falta configurar SONAR_TOKEN en demo/sonarqube/.env" -ForegroundColor Red
    Write-Host "Genera un token en SonarQube: My Account → Security → Generate tokens" -ForegroundColor Yellow
    exit 1
}

# Validar que exista la carpeta de NodeGoat
$nodegoatPath = Join-Path -Path $PSScriptRoot -ChildPath "nodegoat"
if (-not (Test-Path $nodegoatPath)) {
    Write-Host "ERROR: No se encontró la carpeta nodegoat en $nodegoatPath" -ForegroundColor Red
    Write-Host "Clona OWASP NodeGoat antes de ejecutar:" -ForegroundColor Yellow
    Write-Host "  git clone https://github.com/OWASP/NodeGoat.git nodegoat" -ForegroundColor Cyan
    exit 1
}

# Ruta al ejecutable de SonarScanner (ajustar según tu instalación)
$sonarScanner = "C:\Users\Lenovo\Downloads\sonar-scanner-cli-8.1.0.6389-windows-x64\sonar-scanner-8.1.0.6389-windows-x64\bin\sonar-scanner.bat"

if (-not (Test-Path $sonarScanner)) {
    Write-Host "ERROR: No se encontró sonar-scanner.bat en la ruta configurada" -ForegroundColor Red
    Write-Host "Ajusta la variable \$sonarScanner en este script o agrega SonarScanner al PATH del sistema." -ForegroundColor Yellow
    exit 1
}

# Construir argumentos como array para evitar problemas de parsing en PowerShell
$argumentos = @(
    "-Dsonar.projectKey=$env:SONAR_PROJECT_KEY",
    "-Dsonar.sources=./nodegoat",
    "-Dsonar.host.url=$env:SONAR_HOST_URL",
    "-Dsonar.login=$env:SONAR_TOKEN"
)

Write-Host "=== Iniciando análisis de SonarQube sobre OWASP NodeGoat ===" -ForegroundColor Cyan
Write-Host "Proyecto: $env:SONAR_PROJECT_KEY" -ForegroundColor Cyan
Write-Host "Host: $env:SONAR_HOST_URL" -ForegroundColor Cyan
Write-Host ""

# Ejecutar SonarScanner con splatting
& $sonarScanner @argumentos

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=== Análisis completado con éxito ===" -ForegroundColor Green
    Write-Host "Revisa los resultados en: http://localhost:9000" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "=== El análisis finalizó con errores ===" -ForegroundColor Red
    exit $LASTEXITCODE
}
