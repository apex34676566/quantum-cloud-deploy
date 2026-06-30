#!/usr/bin/env pwsh
# QUANTUM CLOUD RUN — Ejecuta el pipeline en GitHub Actions inmediatamente
param([string]$Token = $env:GH_TOKEN)
if (-not $Token) { Write-Host "❌ GH_TOKEN no configurado. Usa: `$env:GH_TOKEN = 'gho_...'" -ForegroundColor Red; return }

$repo = "apex34676566/quantum-cloud-deploy"
$id = "304413589"

Write-Host "🚀 Disparando workflow..." -ForegroundColor Cyan
$url = "https://api.github.com/repos/$repo/actions/workflows/$id/dispatches"

try {
    Invoke-RestMethod -Uri $url -Method POST -Headers @{
        "Authorization" = "token $Token"
        "Accept" = "application/vnd.github.v3+json"
    } -Body '{"ref":"main"}' -ContentType "application/json"
    Write-Host "✅ Workflow disparado!" -ForegroundColor Green
}
catch {
    Write-Host "⚠️ Falló: $($_.Exception.Message)" -ForegroundColor Red
}

# Abrir en Colab
$colabUrl = "https://colab.research.google.com/github/apex34676566/quantum-cloud-deploy/blob/main/quantum-notebook-ready.ipynb"
Write-Host "📓 Colab: $colabUrl" -ForegroundColor Yellow
