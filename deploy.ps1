#!/usr/bin/env pwsh
<#:
.Deploy
Despliegue autónomo de infraestructura cloud + computación cuántica
#>
param([string]$Action = "all")

$Repo = "https://github.com/apex34676566/quantum-cloud-deploy"
$User = "apex34676566"

function Deploy-GitHub {
    Write-Host "📤 Deploy a GitHub..." -ForegroundColor Green
    git init -q; git checkout -b main -q
    git add -A; git commit -m "deploy $(Get-Date -f yyyy-MM-dd)" -q
    git remote add origin "https://github.com/$User/quantum-cloud-deploy.git" 2>$null
    git push -u origin main -q
    Write-Host "   ✅ $Repo" -ForegroundColor Green
}

function Deploy-Colab {
    Write-Host "📓 Abrir en Colab:" -ForegroundColor Yellow
    $url = "https://colab.research.google.com/github/$User/quantum-cloud-deploy/blob/main/quantum-notebook-ready.ipynb"
    Write-Host "   $url" -ForegroundColor Cyan
    Start-Process $url 2>$null
}

function Deploy-Oracle {
    Write-Host "☁️ Oracle Cloud VM Bootstrap..." -ForegroundColor Green
    $Script = @'
#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git build-essential pkg-config libssl-dev
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
git clone https://github.com/apex34676566/quantum-cloud-deploy.git
pip install qiskit qiskit-aer pennylane
echo "✅ Oracle VM listo para quantum cloud"
'@
    $Script | Set-Content oracle-bootstrap.sh
    Write-Host "   ✅ oracle-bootstrap.sh generado"
    Write-Host "   📌 ssh ubuntu@<ip> 'bash < oracle-bootstrap.sh'"
}

switch ($Action) {
    "github"  { Deploy-GitHub }
    "colab"   { Deploy-Colab }
    "oracle"  { Deploy-Oracle }
    "all"     { Deploy-GitHub; Deploy-Colab; Deploy-Oracle }
    default   { Write-Host "Actions: github, colab, oracle, all" }
}
