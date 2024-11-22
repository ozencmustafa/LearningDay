# Playground Steps
 
## 1. Spin up a k8s cluster using Kind

[https://kind.sigs.k8s.io/docs/user/quick-start#creating-a-cluster](https://kind.sigs.k8s.io/docs/user/quick-start#creating-a-cluster)

On macOS via Homebrew

```
brew install kind
```

 Default cluster context name is `kind`.

```
kind create cluster
```

Docker images pull on your local
```
docker pull nginx:1.14.2
docker pull busybox:1.28
```

Docker images can be loaded into your cluster nodes with:

```
kind load docker-image nginx:1.14.2 busybox:1.28
```
 
## 2. Create a Namespace to run your application

Create a new namespace called development

[https://kubernetes.io/docs/tasks/administer-cluster/namespaces/#creating-a-new-namespace](https://kubernetes.io/docs/tasks/administer-cluster/namespaces/#creating-a-new-namespace)

```
kubectl create namespace development
```


## 3. Create a Deployment
  - Create your config file [nginx-deployment.yaml](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment).

  [https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment)

   - Run with 3 replicas

   ```
   kubectl apply -f nginx-deployment.yaml
   ```

   - Include the securityContext

  Pull the busybox image and load into your cluster. 

   ```
   docker pull busybox:1.28
   kind load docker-image busybox:1.28
   ```

   [https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod)

  ```
        - allowPrivilegeEscalation: false
        - runAsNonRoot: true
        - readOnlyRootFilesystem: true
  ```

  ```kubectl apply -f https://k8s.io/examples/pods/security/security-context.yaml```

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