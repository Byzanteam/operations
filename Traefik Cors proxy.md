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
      # 允许重新定义或者添加发往后端服务器的请求头
      Host: rs.cdyoue.com
    customResponseHeaders:
      # 用于在请求要求包含 credentials时，告知浏览器是否可以将对请求的响应暴露给前端 JavaScript 代码。
      Access-Control-Allow-Credentials: "true"
      # 用于 preflight request（预检请求）
      Access-Control-Allow-Headers: '*'
      # 对 preflight request（预检请求）的应答中明确了客户端所要访问的资源允许使用的方法或方法列表。
      Access-Control-Allow-Methods: '*'
      # 服务器默认是不被允许跨域的。配置`Access-Control-Allow-Origin *`后，表示服务器可以接受所有的请求源（Origin）,即接受所有跨域的请求。
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
  # 将服务映射到 DNS 名称
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

