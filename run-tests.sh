#!/usr/bin/env bash

# Arrêter le script immédiatement si une commande échoue (Gestion des exit codes)
set -e

echo "=== Script Unifié d'Exécution des Tests ==="

# 1. Détection automatique du type de projet
PROJECT_TYPE="Inconnu"
if [ -f "package.json" ]; then
  if grep -q "@nestjs" package.json; then
    PROJECT_TYPE="Backend NestJS"
  elif grep -q "react" package.json; then
    PROJECT_TYPE="Frontend React"
  fi
fi

echo "Projet détecté : $PROJECT_TYPE"

# 2. Nettoyage et création du dossier de résultats
RESULTS_DIR="test-results"
rm -rf "$RESULTS_DIR"
mkdir -p "$RESULTS_DIR"

# 3. Vérification des dépendances
if [ ! -d "node_modules" ]; then
  echo "Dépendances non trouvées. Installation avec npm ci..."
  npm ci
fi

# 4. Exécution des tests adaptés avec rapport JUnit XML
echo "Lancement des tests unitaires pour $PROJECT_TYPE..."

export JEST_JUNIT_OUTPUT_DIR="$RESULTS_DIR"
export JEST_JUNIT_OUTPUT_NAME="junit.xml"

# Utilisation de npx jest avec le reporter jest-junit installé
npx jest --ci --reporters=default --reporters=jest-junit

echo "✅ Tests $PROJECT_TYPE terminés avec succès ! Rapport généré dans $RESULTS_DIR/junit.xml"
