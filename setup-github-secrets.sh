#!/bin/bash

# GitHub Secrets Setup Helper for Falcon Sensor Deployment
# This script helps you configure GitHub Secrets for the Falcon deployment workflow

set -e

echo "=========================================="
echo "GitHub Secrets Setup for Falcon Deployment"
echo "=========================================="
echo ""
echo "This script will help you set up GitHub Secrets for deploying"
echo "Falcon Sensor to AKS, EKS, or GKE clusters using GitHub Actions."
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed"
    echo ""
    echo "Install it from: https://cli.github.com/"
    echo "Or run:"
    echo "  macOS: brew install gh"
    echo "  Linux: (see https://github.com/cli/cli/blob/trunk/docs/install_linux.md)"
    exit 1
fi

echo "✓ GitHub CLI found"
echo ""

# Check authentication
if ! gh auth status &> /dev/null; then
    echo "Authenticating with GitHub..."
    gh auth login
fi

echo "✓ Authenticated with GitHub"
echo ""

# Get repository
read -p "Enter GitHub repository (owner/repo): " GITHUB_REPO

if [ -z "$GITHUB_REPO" ]; then
    echo "❌ Repository name is required"
    exit 1
fi

echo ""
echo "Setting secrets for repository: $GITHUB_REPO"
echo ""

# Function to set a secret
set_secret() {
    local secret_name=$1
    local secret_description=$2
    local is_required=$3
    local is_multiline=$4

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "$secret_description"
    echo "Secret name: $secret_name"

    if [ "$is_required" == "required" ]; then
        echo "Status: REQUIRED"
    else
        echo "Status: Optional (press Enter to skip)"
    fi
    echo ""

    if [ "$is_multiline" == "multiline" ]; then
        echo "This is a multi-line secret (e.g., JSON file content)"
        echo "Enter the value (press Ctrl+D when done):"
        secret_value=$(cat)
    else
        if [[ "$secret_name" == *"SECRET"* ]] || [[ "$secret_name" == *"KEY"* ]] || [[ "$secret_name" == *"PASSWORD"* ]]; then
            read -sp "Enter value: " secret_value
            echo ""
        else
            read -p "Enter value: " secret_value
        fi
    fi

    if [ -n "$secret_value" ]; then
        echo "$secret_value" | gh secret set "$secret_name" --repo "$GITHUB_REPO"
        echo "✓ Secret $secret_name set successfully"
    else
        if [ "$is_required" == "required" ]; then
            echo "⚠️  Warning: Required secret not set"
        else
            echo "⊘ Skipped"
        fi
    fi
    echo ""
}

# Common Secrets
echo ""
echo "=========================================="
echo "COMMON SECRETS (Required for All Clouds)"
echo "=========================================="
echo ""

set_secret "FALCON_CLIENT_ID" "CrowdStrike Falcon API Client ID" "required" "singleline"
set_secret "FALCON_CLIENT_SECRET" "CrowdStrike Falcon API Client Secret" "required" "singleline"
set_secret "FALCON_CID" "Falcon Customer ID with checksum (e.g., 1234567890ABCDEF-12)" "required" "singleline"

# Cloud Provider Selection
echo ""
echo "=========================================="
echo "CLOUD PROVIDER CONFIGURATION"
echo "=========================================="
echo ""
echo "Select cloud providers you want to configure:"
echo "  1) Azure AKS"
echo "  2) AWS EKS"
echo "  3) Google Cloud GKE"
echo "  4) All of the above"
echo ""
read -p "Enter choice (1-4): " cloud_choice

# Azure AKS
if [ "$cloud_choice" == "1" ] || [ "$cloud_choice" == "4" ]; then
    echo ""
    echo "=========================================="
    echo "AZURE AKS SECRETS"
    echo "=========================================="
    echo ""
    echo "To create Azure Service Principal, run:"
    echo "  az ad sp create-for-rbac --name github-falcon-deployer"
    echo ""

    set_secret "AZURE_CLIENT_ID" "Azure Service Principal Client ID (appId)" "required" "singleline"
    set_secret "AZURE_CLIENT_SECRET" "Azure Service Principal Secret (password)" "required" "singleline"
    set_secret "AZURE_TENANT_ID" "Azure Tenant ID" "required" "singleline"
    set_secret "AZURE_SUBSCRIPTION_ID" "Azure Subscription ID" "required" "singleline"
    set_secret "AKS_RESOURCE_GROUP" "AKS Resource Group name" "required" "singleline"
fi

# AWS EKS
if [ "$cloud_choice" == "2" ] || [ "$cloud_choice" == "4" ]; then
    echo ""
    echo "=========================================="
    echo "AWS EKS SECRETS"
    echo "=========================================="
    echo ""
    echo "To create AWS IAM user, run:"
    echo "  aws iam create-user --user-name github-falcon-deployer"
    echo "  aws iam create-access-key --user-name github-falcon-deployer"
    echo ""

    set_secret "AWS_ACCESS_KEY_ID" "AWS Access Key ID" "required" "singleline"
    set_secret "AWS_SECRET_ACCESS_KEY" "AWS Secret Access Key" "required" "singleline"
    set_secret "AWS_REGION" "AWS Region (e.g., us-east-1)" "required" "singleline"
fi

# GCP GKE
if [ "$cloud_choice" == "3" ] || [ "$cloud_choice" == "4" ]; then
    echo ""
    echo "=========================================="
    echo "GOOGLE CLOUD GKE SECRETS"
    echo "=========================================="
    echo ""
    echo "To create GCP Service Account, run:"
    echo "  gcloud iam service-accounts create github-falcon-deployer"
    echo "  gcloud iam service-accounts keys create key.json --iam-account=github-falcon-deployer@PROJECT.iam.gserviceaccount.com"
    echo ""

    set_secret "GCP_SERVICE_ACCOUNT_KEY" "GCP Service Account JSON Key (entire file content)" "required" "multiline"
    set_secret "GCP_PROJECT_ID" "GCP Project ID" "required" "singleline"
    set_secret "GCP_REGION" "GCP Region (e.g., us-central1)" "required" "singleline"
fi

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "✓ GitHub Secrets configured for repository: $GITHUB_REPO"
echo ""
echo "To verify secrets, run:"
echo "  gh secret list --repo $GITHUB_REPO"
echo ""
echo "Next steps:"
echo "  1. Go to: https://github.com/$GITHUB_REPO/actions"
echo "  2. Select: Deploy/Upgrade Falcon Sensor workflow"
echo "  3. Click: Run workflow"
echo "  4. Configure and run your deployment"
echo ""
echo "Documentation: GITHUB_ACTIONS_FALCON_DEPLOYMENT.md"
echo ""
