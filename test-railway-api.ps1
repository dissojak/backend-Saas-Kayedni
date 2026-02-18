# Script de test pour l'API Railway Bookify
# Exécutez ce script avec: .\test-railway-api.ps1

$baseUrl = "https://backend-saasbookify-production.up.railway.app/api"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Test de l'API Bookify sur Railway" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Health Check
Write-Host "1. Test Health Check..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/actuator/health" -Method GET -TimeoutSec 30
    Write-Host "   ✓ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "   Response: $($response.Content)" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Erreur: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
}
Write-Host ""

# Test 2: Categories
Write-Host "2. Test Endpoint Categories..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/v1/categories" -Method GET -TimeoutSec 30
    Write-Host "   ✓ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "   Response: $($response.Content)" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Erreur: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "   Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    }
}
Write-Host ""

# Test 3: Businesses
Write-Host "3. Test Endpoint Businesses..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/v1/businesses" -Method GET -TimeoutSec 30
    Write-Host "   ✓ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "   Response (premiers 200 caractères): $($response.Content.Substring(0, [Math]::Min(200, $response.Content.Length)))" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Erreur: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "   Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    }
}
Write-Host ""

# Test 4: Swagger UI
Write-Host "4. Test Swagger UI..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/swagger-ui.html" -Method GET -TimeoutSec 30
    Write-Host "   ✓ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "   Swagger UI est accessible!" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Erreur: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "   Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    }
}
Write-Host ""

# Test 5: Root Path
Write-Host "5. Test Root Path (/)..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://backend-saasbookify-production.up.railway.app/" -Method GET -TimeoutSec 30
    Write-Host "   ✓ Status: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Erreur: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "   Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    }
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Tests terminés!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

