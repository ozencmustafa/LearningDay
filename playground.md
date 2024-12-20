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
docker pull registry.k8s.io/goproxy:0.1
docker pull registry.k8s.io/busybox
```

Docker images can be loaded into your cluster nodes with:

```
kind load docker-image nginx:1.14.2 busybox:1.28 registry.k8s.io/goproxy:0.1 registry.k8s.io/busybox
```
 
## 2. Create a Namespace to run your application

Create a new namespace called development

[https://kubernetes.io/docs/tasks/administer-cluster/namespaces/#creating-a-new-namespace](https://kubernetes.io/docs/tasks/administer-cluster/namespaces/#creating-a-new-namespace)

```
kubectl create namespace development
```


## 3. Create a Deployment
  ### Create/check your config file nginx-deployment.yaml.

  [https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment)

   - Run with 3 replicas

   ```
   kubectl apply -f https://k8s.io/examples/controllers/nginx-deployment.yaml
   ```

   ### Include the securityContext

  Pull the busybox image and load into your cluster. If you pull and loaded in previous steps then skip these pull and load commands.

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
   
   ```
   kubectl apply -f https://k8s.io/examples/pods/security/security-context.yaml
   ```

   ### Add liveness and Readiness probes

   [https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-a-liveness-command](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-a-liveness-command)

   Download the deployment yaml file and update image.

   ```
   wget https://k8s.io/examples/pods/probe/exec-liveness.yaml
   ```

   Update the image to busybox:1.28 in exec-liveness.yaml file.

   ```
   vi exec-liveness.yaml
   ```

   Create the Pod:
   ```
   kubectl apply -f https://k8s.io/examples/pods/probe/exec-liveness.yaml
   ```
   
   In this scenario liveness probe checks if /tmp/healty file exists with periodSeconds parameter which is 5 seconds. 
   initialDelaySeconds field tells the kubelet that it should wait 5 secoinds before performing the first probe.
 
   Define a TCP liveness probe:

   [https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-a-tcp-liveness-probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-a-tcp-liveness-probe)

   ```
   kubectl apply -f https://k8s.io/examples/pods/probe/tcp-liveness-readiness.yaml
   ```

   ### Define resources:
    - CPU
    - Memory

   Specify a memory request and a memory limit

   [https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource/#specify-a-memory-request-and-a-memory-limit](https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource/#specify-a-memory-request-and-a-memory-limit)


   ```
   docker pull polinux/stress
   kind load docker-image polinux/stress
   ```
   
   ```
   kubectl apply -f https://k8s.io/examples/pods/resource/memory-request-limit.yaml

   ```
   Verify that the Pod Container is running:

   ```
   kubectl get pod memory-demo --namespace=mem-example

   ```

   Run kubectl top to fetch the metrics for the pod:

   ```
   kubectl top pod memory-demo --namespace=mem-example

   ```

   ### Specify pod anti-affinity rules

   [https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#more-practical-use-cases](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#more-practical-use-cases)

   In the following example Deployment for the Redis cache, the replicas get the label app=store. The podAntiAffinity rule tells the scheduler to avoid placing multiple replicas with the app=store label on a single node. This creates each cache in a separate node.

   ```
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: redis-cache
    spec:
      selector:
        matchLabels:
          app: store
      replicas: 3
      template:
        metadata:
          labels:
            app: store
        spec:
          affinity:
            podAntiAffinity:
              requiredDuringSchedulingIgnoredDuringExecution:
              - labelSelector:
                  matchExpressions:
                  - key: app
                    operator: In
                    values:
                    - store
                topologyKey: "kubernetes.io/hostname"
          containers:
          - name: redis-server
            image: redis:3.2-alpine
   ```
 
## 4. Create a Secret to pass to your application

[https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-container-environment-variables-using-secret-data](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-container-environment-variables-using-secret-data)

Define an environment variable as a key-value pair in a Secret:

```
 kubectl create secret generic backend-user --from-literal=backend-username='backend-admin'
```

Assign the backend-username value defined in the Secret to the SECRET_USERNAME environment variable in the Pod specification.
```
apiVersion: v1
kind: Pod
metadata:
  name: env-single-secret
spec:
  containers:
  - name: envars-test-container
    image: nginx
    env:
    - name: SECRET_USERNAME
      valueFrom:
        secretKeyRef:
          name: backend-user
          key: backend-username
```

```
kubectl create -f https://k8s.io/examples/pods/inject/pod-single-secret-env-variable.yaml
```

In your shell, display the content of SECRET_USERNAME container environment variable.

```
kubectl exec -i -t env-single-secret -- /bin/sh -c 'echo $SECRET_USERNAME'
```

 
## 5. Create a ConfigMap to pass values to your application and Retrieve the values from environment variables

[https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#define-container-environment-variables-using-configmap-data](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#define-container-environment-variables-using-configmap-data)
 
## 6. Create a Service for your application

[https://kubernetes.io/docs/concepts/services-networking/service/#defining-a-service](https://kubernetes.io/docs/concepts/services-networking/service/#defining-a-service)
 
## 7. Ensure your application has a Horizontal Pod Autoscaler (HPA)

[https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/#create-horizontal-pod-autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/#create-horizontal-pod-autoscaler)
 
## 8. Ensure your application has a PodDisruptionBudget

[https://kubernetes.io/docs/tasks/run-application/configure-pdb/#specifying-a-poddisruptionbudget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/#specifying-a-poddisruptionbudget)