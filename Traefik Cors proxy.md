# Traefik Cors Proxy

> ### This article provides cors proxy solution using traefik in kubernets

## Ingressroute

> The routes for access subpath

```yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: api-v4
  namespace: default
spec:
  entryPoints:
  - web
  routes:
  - kind: Rule
    match: Host(`172.168.252.11`) &&  PathPrefix(`/api/v4`)
    middlewares:
    - name: cors-header-apiv4
    services:
    - name: api-v4-svc
      port: 80
```

## Middleware

> This middleware solves the cors access problem，like headers and the request url inconsistent

```yaml
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: cors-header-apiv4
  namespace: default
spec:
  headers:
    customRequestHeaders:
      Host: rs.cdyoue.com
    customResponseHeaders:
      Access-Control-Allow-Credentials: "true"
      Access-Control-Allow-Headers: '*'
      Access-Control-Allow-Methods: '*'
      Access-Control-Allow-Origin: '*'
```

## Service

### ExternalName type svc

> This service cname to other domain 

```yaml
apiVersion: v1
kind: Service
metadata:
  name: api-v4-svc
  namespace: default
spec:
  externalName: rs.cdyoue.com
  type: ExternalName
```

## ClusterIP type svc+Endpoints

> This way to add an external service to the cluster 

### Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: api-personal
  namespace: default
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  type: ClusterIP
```

### Endpoints

```yaml
apiVersion: v1
kind: Endpoints
metadata:
  name: api-personal
  namespace: default
subsets:
- addresses:
  - ip: 172.168.253.10
  ports:
  - port: 80
    protocol: TCP
```

