# Enterprise Crossplane GitOps Mesh

Laboratório cloud-native focado em **DevSecOps**, **Infraestrutura como Código (IaC)** e **Arquitetura Zero Trust** utilizando **Kubernetes (KinD)**, **Istio Service Mesh** e **Keycloak IAM**.

> A cloud-native lab focused on **DevSecOps**, **Infrastructure as Code (IaC)**, and **Zero Trust Architecture** using **Kubernetes (KinD)**, **Istio Service Mesh**, and **Keycloak IAM**.

---

## 🇧🇷 Português

### 🏛️ Arquitetura do Projeto
* **Cluster Kubernetes:** KinD (Kubernetes in Docker).
* **Service Mesh:** Istio com mTLS estrito, `RequestAuthentication` e `AuthorizationPolicy`.
* **IAM / Identity Provider:** Keycloak 20.0.5 (OAuth2 / OpenID Connect).
* **Workloads:** Serviços implantados no namespace `production-mesh`.
* **Testes & Automação:** Shell Script (`test-jwt-auth.sh`) para validação automatizada de tokens JWT e controle de acesso.

### 🔒 Destaques Técnicos & Troubleshooting
1. **Compatibilidade de Microarquitetura CPU (`x86-64-v1` vs `v2`):**
   - Ajuste da imagem do Keycloak para a versão `20.0.5` para mitigar incompatibilidades de instruções de CPU e glibc (`Fatal glibc error: CPU does not support x86-64-v2`) em ambientes virtualizados.
2. **Segurança Zero Trust na Mesh:**
   - Aplicação de regras declarativas do Istio Envoy Proxy para interceptar o tráfego de rede e validar a assinatura dos tokens JWT emitidos pelo Keycloak antes que atinjam os pods da aplicação.

### 🚀 Como Executar o Laboratório
```bash
# 1. Aplicar a Infraestrutura do Keycloak
kubectl apply -f manifests/keycloak.yaml
kubectl rollout status deployment/keycloak-idp -n keycloak --timeout=180s

# 2. Aplicar as Políticas de Segurança do Istio
kubectl apply -f manifests/istio-jwt-auth.yaml

# 3. Executar a Validação Automatizada de Tokens JWT
./scripts/test-jwt-auth.sh

🇺🇸 English
🏛️ Project Architecture

    Kubernetes Cluster: KinD (Kubernetes in Docker).

    Service Mesh: Istio with strict mTLS, RequestAuthentication, and AuthorizationPolicy.

    IAM / Identity Provider: Keycloak 20.0.5 (OAuth2 / OpenID Connect).

    Workloads: Services deployed in the production-mesh namespace.

    Testing & Automation: Shell script (test-jwt-auth.sh) for automated JWT token validation and access control enforcement.

🔒 Technical Highlights & Troubleshooting

    CPU Microarchitecture Compatibility (x86-64-v1 vs v2):

        Configured Keycloak image to version 20.0.5 to eliminate glibc instruction set incompatibilities (Fatal glibc error: CPU does not support x86-64-v2) in virtualized environments.

    Zero Trust Mesh Security:

        Implemented declarative Istio Envoy Proxy policies to intercept network traffic and verify JWT token signatures before requests hit workload pods.

🚀 How to Run
Bash

# 1. Deploy Keycloak Infrastructure
kubectl apply -f manifests/keycloak.yaml
kubectl rollout status deployment/keycloak-idp -n keycloak --timeout=180s

# 2. Apply Istio Security Policies
kubectl apply -f manifests/istio-jwt-auth.yaml

# 3. Execute Automated JWT Validation
./scripts/test-jwt-auth.sh

📁 Estrutura do Repositório / Repository Structure
Plaintext

.
├── manifests/
│   ├── keycloak.yaml        # Keycloak IDP Deployment & Service
│   └── istio-jwt-auth.yaml  # RequestAuthentication & AuthorizationPolicy manifests
├── scripts/
│   └── test-jwt-auth.sh     # JWT automation and validation script
└── README.md                # Project documentation

