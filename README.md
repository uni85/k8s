# Production-Grade Kubernetes (K8s) Deployment

This repository demonstrates a professional-grade Kubernetes architecture for the `kubernetes-bootcamp` application. It moves beyond basic "bootcamp" tutorials by implementing **Kustomize**, **Security Hardening**, and **Resource Governance**.

## Architecture: The "Base & Overlay" Pattern
Instead of using a single flat YAML file, this project uses **Kustomize** (built into `kubectl`). This allows for a "DRY" (Don't Repeat Yourself) workflow where a single **Base** configuration is patched for different environments.

### Folder Structure
* **`/base`**: The core application logic (Deployment, Service, Ingress).
* **`/overlays/production`**: Environment-specific patches (e.g., higher replica counts, specific labels).

---

## Key Technical Enhancements

I have upgraded the basic deployment with industry-standard features:

| Feature | Implementation | Why it matters |
| :--- | :--- | :--- |
| **Self-Healing** | Liveness/Readiness Probes | K8s automatically restarts frozen containers and prevents traffic to "unready" pods. |
| **Resource Limits** | CPU/Memory Requests & Limits | Prevents "Noisy Neighbor" syndrome; ensures the cluster scheduler works efficiently. |
| **Security** | `runAsNonRoot: true` | Implements the **Principle of Least Privilege** to protect the underlying Node. |
| **Traffic Mgmt** | Ingress vs NodePort | Moves away from insecure random ports to centralized, domain-based routing. |

---

## Configuration Deep-Dive

### 1. Resource Management
To ensure cluster stability, the deployment defines strict boundaries:
- **Requests:** $100m$ CPU / $64Mi$ Memory
- **Limits:** $500m$ CPU / $128Mi$ Memory

### 2. Health Checks
The app is monitored via HTTP probes on port `8080`:
- **Readiness:** Confirms the app is ready to serve traffic before the Service sends users to it.
- **Liveness:** Performs a "heartbeat" check to restart the pod if the process crashes.

---

## How to Deploy

### Prerequisites
* `kubectl` (v1.14+)
* A running Kubernetes cluster (Minikube, Kind, EKS, or GKE)

### Application via Kustomize
To deploy the **Production** version of the app (which scales to 5 replicas):

```bash
kubectl apply -k overlays/production/
```

### Verification

```bash
# Verify the pods are running and check resource limits
kubectl describe pods -l app=kubernetes-bootcamp

# Check the Ingress routing rules
kubectl get ingress bootcamp-ingress
