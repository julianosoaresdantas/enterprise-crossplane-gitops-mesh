#!/usr/bin/env bash
set -e

KEYCLOAK_URL="http://keycloak-idp.keycloak.svc.cluster.local/realms/master/protocol/openid-connect/token"
SERVICE_URL="http://httpbin-service.production-mesh.svc.cluster.local:8000/headers"
NAMESPACE="production-mesh"

echo "======================================================"
echo "🔐 Autenticando no Keycloak e Testando Istio Service Mesh"
echo "======================================================"

# 1. Limpar pods antigos de teste se existirem
kubectl delete pod jwt-test-pod -n "${NAMESPACE}" --force --grace-period=0 2>/dev/null || true

# 2. Subir pod temporário sem sidecar do Istio
kubectl run jwt-test-pod --image=curlimages/curl -n "${NAMESPACE}" \
--restart=Never \
--overrides='{"metadata":{"annotations":{"sidecar.istio.io/inject":"false"}}}' \
-- sleep 60 >/dev/null 2>&1

echo "⏳ Aguardando pod de testes ficar Ready..."
kubectl wait --for=condition=Ready pod/jwt-test-pod -n "${NAMESPACE}" --timeout=30s

echo "🔑 Solicitando Access Token JWT do Keycloak..."
TOKEN=$(kubectl exec -n "${NAMESPACE}" jwt-test-pod -- curl -s -X POST "${KEYCLOAK_URL}" \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "username=admin" \
-d "password=admin" \
-d "grant_type=password" \
-d "client_id=admin-cli" | sed -n 's/.*"access_token":"\([^"]*\)".*/\1/p')

if [ -z "$TOKEN" ]; then
echo "❌ Falha ao obter o token JWT do Keycloak."
kubectl delete pod jwt-test-pod -n "${NAMESPACE}" --force --grace-period=0 >/dev/null 2>&1
exit 1
fi

echo "✅ Token JWT obtido com sucesso!"
echo "------------------------------------------------------"

echo "🚀 Enviando requisição autenticada (HTTP Bearer) para o Istio..."
kubectl exec -n "${NAMESPACE}" jwt-test-pod -- curl -i -s -H "Authorization: Bearer ${TOKEN}" "${SERVICE_URL}"

echo ""
echo "🧹 Limpando pod de testes efêmero..."
kubectl delete pod jwt-test-pod -n "${NAMESPACE}" --force --grace-period=0 >/dev/null 2>&1
echo "Done!"
