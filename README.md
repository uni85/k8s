- Architecture Overview
Instead of static manifests, this project uses a Base/Overlay strategy via Kustomize:

/base: Contains the "Golden Image" configuration—resources that are consistent across all environments.

/overlays: Contains environment-specific patches (e.g., scaling up replicas for production, changing service types for development).

- Key Engineering Improvements
I have implemented the following "Day 2" operations features to ensure the application is production-grade:

1. High Availability & Scaling
Replicas: Configured with 3-5 replicas to ensure zero-downtime during updates.

Strategy: Uses RollingUpdate (default) to ensure availability while deploying new versions.

2. Self-Healing (Liveness & Readiness Probes)
Readiness Probe: Ensures the Load Balancer doesn't send traffic to a pod that is still starting up.

Liveness Probe: Automatically restarts the container if the application hangs or enters a deadlock state.

3. Resource Governance
Requests/Limits: Defined CPU and Memory boundaries to prevent "noisy neighbor" syndrome and ensure the K8s scheduler can place pods efficiently.

Memory Limit: 128Mi

CPU Limit: 500m

4. Security Hardening
Non-Root Execution: The container is configured to runAsNonRoot: true. Even if a container is compromised, the attacker does not have administrative privileges on the host node.

Service Security: Moved from NodePort (which opens random ports on nodes) to ClusterIP combined with an Ingress Controller for centralized traffic management.

- How to Deploy
Prerequisites
kubectl (v1.14+)

A running Kubernetes cluster (Minikube, Kind, or EKS/GKE)

Deploying to Production
To apply the production overlay which scales the app and applies specific patches:

kubectl apply -k overlays/production/

Verification

# Check pod status and resource limits
kubectl describe pods -l app=kubernetes-bootcamp

# Check the Ingress routing
kubectl get ingress

- Future Roadmap
  
[ ] Implement Horizontal Pod Autoscaler (HPA) based on CPU metrics.

[ ] Add NetworkPolicies to restrict traffic to "Namespace-only."

[ ] Integrate GitHub Actions for automated CI/CD linting and deployment.
