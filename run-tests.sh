#!/usr/bin/env bash

# Arrêter le script immédiatement si une commande échoue
set -e

echo "=== Démarrage du script de tests ==="

# Nettoyage et création du dossier de résultats
RESULTS_DIR="test-results"
rm -rf "$RESULTS_DIR"
mkdir -p "$RESULTS_DIR"

# Vérification des dépendances
if [ ! -d "node_modules" ]; then
  echo "Dépendances non trouvées. Installation avec npm ci..."
  npm ci
fi

# Exécution des tests avec génération du rapport JUnit XML
echo "Exécution des tests unitaires Jest..."
export JEST_JUNIT_OUTPUT_DIR="$RESULTS_DIR"
export JEST_JUNIT_OUTPUT_NAME="junit.xml"

npx -p jest-junit jest --ci --reporters=default --reporters=jest-junit

echo "Tests terminés avec succès ! Rapport généré dans $RESULTS_DIR/junit.xml"
