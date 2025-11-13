#!/usr/bin/env bash
set -euo pipefail

# Simple helper to mimic pipeline behaviour locally.
# This script assumes:
# - Azure CLI is installed and logged in
# - Bicep CLI is available (or built-in via az)

ENVIRONMENT_NAME="${1:-dev-sec}"
LOCATION="${2:-uksouth}"
TEMPLATE_FILE="${3:-./bicep/main.bicep}"
PARAM_FILE="${4:-./scripts/sample-parameters.json}"

echo "== Azure Secure Environment – Local Run =="
echo "Environment : ${ENVIRONMENT_NAME}"
echo "Location    : ${LOCATION}"
echo "Template    : ${TEMPLATE_FILE}"
echo "Parameters  : ${PARAM_FILE}"
echo ""

RESOURCE_GROUP="rg-sec-${ENVIRONMENT_NAME}"

echo "Ensuring resource group ${RESOURCE_GROUP} exists..."
az group create --name "${RESOURCE_GROUP}" --location "${LOCATION}" >/dev/null

echo "Running what-if deployment..."
az deployment group what-if \
  --name "sec-validate-${ENVIRONMENT_NAME}" \
  --resource-group "${RESOURCE_GROUP}" \
  --template-file "${TEMPLATE_FILE}" \
  --parameters @"${PARAM_FILE}"

echo ""
read -p "Proceed with deployment? (y/N) " REPLY
if [[ ! "${REPLY}" =~ ^[Yy]$ ]]; then
  echo "Aborting."
  exit 0
fi

echo "Deploying..."
az deployment group create \
  --name "sec-${ENVIRONMENT_NAME}" \
  --resource-group "${RESOURCE_GROUP}" \
  --template-file "${TEMPLATE_FILE}" \
  --parameters @"${PARAM_FILE}"

echo "Deployment complete."
