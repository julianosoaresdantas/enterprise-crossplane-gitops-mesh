# 📖 Diário de Arquitetura & Implementação (Architecture Journal)

Este diário documenta, passo a passo, a evolução do laboratório enterprise de **GitOps, Zero Trust Identity Mesh e Control Plane Declarativo**.

---

## 📅 Fase 1: GitOps Bootstrapping & App of Apps Pattern
**Objetivo:** Estabelecer a fonte única da verdade (*Single Source of Truth*) no Git e orquestrar a infraestrutura de plataforma através do ArgoCD.

### 🎯 O que foi implementado:
1. **Modelagem de Repositório GitOps:**
   - Separação clara entre orquestração de plataforma (`apps/`), manifestos de infraestrutura (`infrastructure/`) e cargas de trabalho (`workloads/`).
2. **Cluster Kubernetes Local (KinD):**
   - Provisionamento do cluster `enterprise-mesh` com mapeamento de portas NodePort (30080/30443) para exposição de serviços de borda sem dependência de LoadBalancers externos.
3. **Padrão *App of Apps* (ArgoCD):**
   - Implantação da aplicação raiz (`root-application.yaml`), responsável por escanear o repositório Git de forma recursiva na pasta `infrastructure/` e aplicar de forma declarativa e automatizada os gráficos Helm do **Istio Base** e do **Keycloak (IdP)**.

### 🔍 Comandos de Validação Utilizados:
```bash
# Verificar a sincronização declarativa das aplicações no ArgoCD
kubectl get applications -n argocd

# Validar o estado dos componentes de infraestrutura criados pelo GitOps
kubectl get pods -n istio-system
kubectl get pods -n keycloak
```
---

## 📅 Fase 3: Validação de Saúde dos Controladores & Infraestrutura
**Phase 3: Controller & Infrastructure Health Validation**

**Objetivo / Objective:** 
Garantir que todos os componentes de plataforma (Istio, Keycloak e Crossplane) foram provisionados com sucesso via GitOps e estão prontos para a camada de segurança Zero Trust.
*Ensure all platform components (Istio, Keycloak, and Crossplane) were successfully provisioned via GitOps and are ready for the Zero Trust security layer.*

### 🎯 Resultados da Inspecção / Inspection Results:
- **Istio Base:** Operational in `istio-system` namespace.
- **Keycloak IdP:** Running in `keycloak` namespace.
- **Crossplane Control Plane:** Active in `crossplane-system` namespace.
- **ArgoCD App of Apps:** All applications reporting `Synced` and `Healthy` states.
---

## 🔒 Fase 10: Implementação de Políticas Istio JWT Zero Trust
**Phase 10: Istio JWT Zero Trust Policy Enforcement**

**Objetivo / Objective:** 
Estabelecer validação criptográfica de tokens JWT emitidos pelo Keycloak (`RequestAuthentication`) e negar requisições não autenticadas ao `httpbin-service` (`AuthorizationPolicy`).
*Establish cryptographic validation for Keycloak-issued JWTs (`RequestAuthentication`) and reject unauthenticated traffic to `httpbin-service` (`AuthorizationPolicy`).*

### 🛠️ Manifestos Aplicados / Applied Manifests:
- **RequestAuthentication:** `jwt-keycloak-auth` configurado com JWKS no endpoint local do Keycloak (`/realms/master/protocol/openid-connect/certs`).
- **AuthorizationPolicy:** `require-jwt-token` em modo `ALLOW` vinculando `requestPrincipals` para o realm `master`.
---

## 🧪 Validação Zero Trust: Rejeição Sem JWT (HTTP 401 Unauthorized)
**Zero Trust Validation: Missing JWT Rejection (HTTP 401 Unauthorized)**

**Resultado do Teste / Test Result:** 
A requisição efetuada via `curl` sem o token de autorização JWT para o `httpbin-service` foi interceptada e rejeitada com o payload de 19 bytes (`Jwt is missing`) pelo Envoy Sidecar do Istio.
*The request issued via `curl` without the JWT authorization token to `httpbin-service` was intercepted and rejected with a 19-byte payload (`Jwt is missing`) by Istio's Envoy Sidecar.*
---

## 🚀 Fase 11: Script de Automação de Testes JWT (HTTP 200 OK Validation)
**Phase 11: JWT Automation Testing Script (HTTP 200 OK Validation)**

**Objetivo / Objective:** 
Automação do fluxo de obtenção do token JWT no Keycloak e validação da requisição autorizada (`Authorization: Bearer`) no Istio Service Mesh.
*Automation of Keycloak JWT access token retrieval and authorized request validation (`Authorization: Bearer`) in Istio Service Mesh.*

### 📂 Arquivos Criados / Files Created:
- `scripts/test-jwt-auth.sh`: Script Bash automatizado para validação do fluxo Zero Trust (`HTTP/1.1 200 OK`).
---

## 🛠️ Ajuste de Repositório: Git Remote Sync & Push Confirmation
**Repository Adjustment: Git Remote Sync & Push Confirmation**

**Status / Outcome:** 
Reconfigurada a URL remota `origin` apontando para o repositório pré-existente no GitHub (`julianosoaresdantas/enterprise-crossplane-gitops-mesh`) e sincronizados todos os commits e scripts de automação.
*Reconfigured `origin` remote URL pointing to the existing GitHub repository (`julianosoaresdantas/enterprise-crossplane-gitops-mesh`) and synced all pending commits and automation scripts.*
