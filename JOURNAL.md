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
