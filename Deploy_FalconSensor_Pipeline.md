# GitHub Actions: Falcon Sensor Deployment - Complete Package

## 📦 Package Contents

This package provides a complete, production-ready GitHub Actions CI/CD pipeline for deploying and upgrading CrowdStrike Falcon Sensor to Kubernetes clusters across Azure AKS, AWS EKS, and Google Cloud GKE.

---

## 📁 Files Included

### Workflow Files (`.github/workflows/`)
- **deploy-falcon-sensor.yml** - Main deployment workflow (install/upgrade)
- **scheduled-falcon-upgrade.yml** - Automated scheduled upgrade workflow

### Documentation
- **GITHUB_ACTIONS_FALCON_DEPLOYMENT.md** - Complete setup and usage guide (478 lines)
- **FALCON_DEPLOYMENT_QUICKREF.md** - Quick reference guide (286 lines)
- **GITHUB_ACTIONS_PROJECT_SUMMARY.md** - Project overview and features (509 lines)
- **GITHUB_ACTIONS_ARCHITECTURE_DIAGRAM.md** - Visual architecture diagrams (528 lines)

### Automation Scripts
- **setup-github-secrets.sh** - Interactive GitHub Secrets configuration script (189 lines)

---

## 🚀 Getting Started

### 1. Choose Your Starting Point

**New to this?** → Start here:
```
FALCON_DEPLOYMENT_QUICKREF.md
```

**Need complete setup instructions?** → Read this:
```
GITHUB_ACTIONS_FALCON_DEPLOYMENT.md
```

**Want to understand the architecture?** → Review this:
```
GITHUB_ACTIONS_ARCHITECTURE_DIAGRAM.md
```

**Need project overview?** → See this:
```
GITHUB_ACTIONS_PROJECT_SUMMARY.md
```

### 2. Set Up the Workflow

```bash
# Copy workflow files to your repository
mkdir -p .github/workflows
cp deploy-falcon-sensor.yml .github/workflows/
cp scheduled-falcon-upgrade.yml .github/workflows/

# Commit and push
git add .github/workflows/
git commit -m "Add Falcon Sensor deployment workflows"
git push
```

### 3. Configure Secrets

**Interactive method (recommended):**
```bash
./setup-github-secrets.sh
```

**Manual method:**
1. Go to: GitHub Repository → Settings → Secrets and variables → Actions
2. Add required secrets (see [Required Secrets](#required-secrets) below)

### 4. Run Your First Deployment

1. Navigate to: **GitHub Repository → Actions**
2. Select: **Deploy/Upgrade Falcon Sensor**
3. Click: **Run workflow**
4. Configure parameters and deploy!

---

## 🔑 Required Secrets

### Common (All Cloud Providers)
```
FALCON_CLIENT_ID          # CrowdStrike API Client ID
FALCON_CLIENT_SECRET      # CrowdStrike API Client Secret
FALCON_CID                # Falcon Customer ID with checksum
```

### Azure AKS
```
AZURE_CLIENT_ID
AZURE_CLIENT_SECRET
AZURE_TENANT_ID
AZURE_SUBSCRIPTION_ID
AKS_RESOURCE_GROUP
```

### AWS EKS
```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
```

### Google Cloud GKE
```
GCP_SERVICE_ACCOUNT_KEY   # JSON file content
GCP_PROJECT_ID
GCP_REGION
```

**Detailed setup instructions**: `GITHUB_ACTIONS_FALCON_DEPLOYMENT.md` (Section: "Creating Cloud Service Principals")

---

## ✨ Key Features

| Feature | Description |
|---------|-------------|
| **Multi-Cloud** | Deploy to AKS, EKS, or GKE from a single workflow |
| **Install & Upgrade** | Support for fresh installations and version upgrades |
| **GKE Autopilot** | Automatic detection and BPF backend configuration |
| **Version Control** | Pin to specific version or use latest |
| **Scheduled Updates** | Automated weekly/monthly upgrades |
| **Security** | GitHub Secrets, least privilege, audit trails |
| **Verification** | Automated health checks and status reporting |

---

## 📖 Documentation Map

```
START HERE
    │
    ├─→ FALCON_DEPLOYMENT_QUICKREF.md
    │       │
    │       └─→ Quick commands and common use cases
    │
    ├─→ GITHUB_ACTIONS_FALCON_DEPLOYMENT.md
    │       │
    │       ├─→ Prerequisites
    │       ├─→ GitHub Secrets setup
    │       ├─→ Service principal creation
    │       ├─→ Usage examples
    │       ├─→ Troubleshooting
    │       └─→ Advanced configuration
    │
    ├─→ GITHUB_ACTIONS_PROJECT_SUMMARY.md
    │       │
    │       ├─→ Features overview
    │       ├─→ Workflow architecture
    │       ├─→ Security considerations
    │       └─→ Compliance information
    │
    └─→ GITHUB_ACTIONS_ARCHITECTURE_DIAGRAM.md
            │
            └─→ Visual workflow diagrams
```

---

## 💡 Common Use Cases

### Use Case 1: Deploy Latest Version to Production GKE
```yaml
cloud_provider: GKE
cluster_name: production-gke-cluster
action: install
sensor_version: (leave empty for latest)
namespace: falcon-system
```

### Use Case 2: Upgrade AKS Cluster to Specific Version
```yaml
cloud_provider: AKS
cluster_name: staging-aks-cluster
action: upgrade
sensor_version: 7.31.0-18410-1
namespace: falcon-system
```

### Use Case 3: Deploy to GKE Autopilot (Automatic BPF Configuration)
```yaml
cloud_provider: GKE
cluster_name: autopilot-cluster
action: install
sensor_version: (leave empty)
namespace: falcon-system
```
> **Note**: Autopilot is detected automatically and BPF backend is configured

### Use Case 4: Scheduled Weekly Upgrades
Enable the scheduled workflow (`scheduled-falcon-upgrade.yml`) which runs every Sunday at 2 AM UTC to automatically upgrade all configured clusters.

---

## 🔧 Quick Commands

### View GitHub Secrets
```bash
gh secret list --repo owner/repo
```

### Trigger Workflow Manually
```bash
gh workflow run deploy-falcon-sensor.yml
```

### View Workflow Runs
```bash
gh run list --workflow=deploy-falcon-sensor.yml
```

### View Specific Run Logs
```bash
gh run view {RUN_ID} --log
```

### Verify Deployment on Cluster
```bash
helm list -n falcon-system
kubectl get daemonset falcon-node-sensor -n falcon-system
kubectl get pods -n falcon-system
kubectl logs -n falcon-system -l app.kubernetes.io/name=falcon-sensor
```

---

## 🏗️ Architecture Overview

```
GitHub Actions Trigger
        │
        ▼
Cloud Authentication (AKS/EKS/GKE)
        │
        ▼
Cluster Access Configuration
        │
        ▼
GKE Autopilot Detection (if GKE)
        │
        ▼
Download Falcon Pull Script
        │
        ▼
Get Pull Token + Sensor Version
        │
        ▼
Create/Configure Namespace
        │
        ▼
Deploy/Upgrade with Helm
        │
        ▼
Verify Deployment
        │
        ▼
Report Summary
```

**Full diagrams**: `GITHUB_ACTIONS_ARCHITECTURE_DIAGRAM.md`

---

## 🔐 Security Features

- ✅ All credentials stored in encrypted GitHub Secrets
- ✅ Secrets are masked in workflow logs
- ✅ Temporary credential files cleaned up automatically
- ✅ Service principals use least-privilege access
- ✅ Support for GitHub Environment protection rules
- ✅ Full audit trail via GitHub Actions logs

**Details**: `GITHUB_ACTIONS_FALCON_DEPLOYMENT.md` (Section: "Security Best Practices")

---

## 🐛 Troubleshooting

### Quick Diagnostics

**Check workflow execution:**
```bash
gh run list --workflow=deploy-falcon-sensor.yml --limit 5
gh run view {RUN_ID}
```

**Check cluster deployment:**
```bash
kubectl get all -n falcon-system
kubectl describe daemonset falcon-node-sensor -n falcon-system
```

**Common issues:**
- **Authentication failures**: Verify cloud provider secrets
- **Pull token errors**: Check Falcon API credentials and scopes
- **Image pull errors**: Verify connectivity to `registry.crowdstrike.com`
- **GKE Autopilot errors**: Check BPF backend configuration (should be automatic)

**Complete troubleshooting guide**: `GITHUB_ACTIONS_FALCON_DEPLOYMENT.md` (Section: "Troubleshooting")

---

## 📊 Workflow Inputs

| Parameter | Type | Options | Default | Description |
|-----------|------|---------|---------|-------------|
| `cloud_provider` | choice | AKS, EKS, GKE | Required | Target cloud platform |
| `cluster_name` | string | - | Required | Kubernetes cluster name |
| `action` | choice | install, upgrade | Required | Deployment action |
| `sensor_version` | string | - | latest | Falcon Sensor version |
| `namespace` | string | - | falcon-system | Kubernetes namespace |

---

## 🎯 What Makes This Solution Unique

1. **Truly Multi-Cloud**: Single workflow works seamlessly across AKS, EKS, and GKE
2. **Intelligent**: Automatic GKE Autopilot detection and configuration
3. **Complete**: Includes workflows, documentation, setup scripts, and diagrams
4. **Production-Ready**: Security best practices, verification, error handling
5. **Maintainable**: Scheduled upgrades for automated maintenance
6. **Well-Documented**: 1,800+ lines of comprehensive documentation

---

## 📋 Compliance

This implementation fully complies with CrowdStrike's Falcon Sensor HELM Deployment documentation:

✅ Uses `falcon-container-sensor-pull.sh` for registry authentication
✅ Supports all cloud provider cluster naming conventions
✅ Creates namespace with appropriate Pod Security Standards labels
✅ Uses official Helm charts for deployment
✅ Configures CID, image repository, and image tags correctly
✅ Handles GKE Autopilot BPF backend requirements
✅ Verifies deployment with rollout status checks

---

## 📞 Support & Resources

### Documentation
- **Quick Start**: `FALCON_DEPLOYMENT_QUICKREF.md`
- **Complete Guide**: `GITHUB_ACTIONS_FALCON_DEPLOYMENT.md`
- **Architecture**: `GITHUB_ACTIONS_ARCHITECTURE_DIAGRAM.md`
- **Project Info**: `GITHUB_ACTIONS_PROJECT_SUMMARY.md`

### External Resources
- **Falcon Helm Charts**: https://github.com/CrowdStrike/falcon-helm
- **GitHub Actions Docs**: https://docs.github.com/actions
- **CrowdStrike Support**: https://falcon.crowdstrike.com/documentation

### Need Help?
- **Workflow Issues**: Check GitHub Actions logs
- **Falcon Sensor**: Contact CrowdStrike Support
- **Cloud Provider**: Consult cloud provider documentation

---

## 📦 Package Summary

| Component | Files | Lines of Code | Status |
|-----------|-------|---------------|--------|
| Workflows | 2 | ~750 | ✅ Ready |
| Documentation | 4 | ~1,800 | ✅ Complete |
| Scripts | 1 | ~190 | ✅ Executable |
| **Total** | **7** | **~2,740** | **✅ Production Ready** |

---

## 🎉 You're All Set!

Your GitHub Actions pipeline for Falcon Sensor deployment is ready to use. Follow the [Getting Started](#-getting-started) section above to begin deploying to your Kubernetes clusters.

For questions or issues, refer to the comprehensive documentation or open an issue in your repository.

**Happy Deploying!** 🚀

---

**Created**: 2026-03-14
**Version**: 1.0
**Status**: Production Ready ✅
**License**: Use in accordance with your CrowdStrike agreement
