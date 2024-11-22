# Playground Steps
 
## 1. Spin up a k8s cluster using Kind

```https://kind.sigs.k8s.io/docs/user/quick-start#creating-a-cluster```
 
## 2. Create a Namespace to run your application

```https://kubernetes.io/docs/tasks/administer-cluster/namespaces/#creating-a-new-namespace```
 
## 3. Create a Deployment

```https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment```
   - Run with 3 replicas
   - Include the securityContext
   ```https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod```
        - allowPrivilegeEscalation: false
        - runAsNonRoot: true
        - readOnlyRootFilesystem: true
   - Add liveness and Readiness probes
   ```https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-a-tcp-liveness-probe```
   - Define resources:
        - CPU
        - Memory
   - Specify pod anti-affinity rules
   ```https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#more-practical-use-cases```
 
## 4. Create a Secret to pass to your application

```https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-container-environment-variables-using-secret-data```
   - add the secret as an environment variable
 
## 5. Create a ConfigMap to pass values to your application and Retrieve the values from environment variables

```https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#define-container-environment-variables-using-configmap-data```
 
## 6. Create a Service for your application

```https://kubernetes.io/docs/concepts/services-networking/service/#defining-a-service```
 
## 7. Ensure your application has a Horizontal Pod Autoscaler (HPA)

```https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/#create-horizontal-pod-autoscaler```
 
## 8. Ensure your application has a PodDisruptionBudget

```https://kubernetes.io/docs/tasks/run-application/configure-pdb/#specifying-a-poddisruptionbudget```