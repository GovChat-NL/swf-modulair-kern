#!/bin/sh
# Zet de kern op het cluster waar kubectl nu naar wijst, voor een lokale proef:
# een stubmodel in plaats van Azure, een lokaal account in plaats van Entra.
# Alleen voor een eigen wegwerpcluster. De Secrets worden hier gemaakt en gaan
# rechtstreeks naar het cluster: niet in Git, niet in een bestand, niet op het scherm.
#
#   local/start.sh [namespace]
set -eu
cd "$(dirname "$0")/.."
ns=${1:-govchat}
chart=$(sed -n 's/^chart: *//p' kern.yaml)
version=$(sed -n 's/^chartVersion: *\([0-9.]*\).*/\1/p' kern.yaml)

kubectl get namespace "$ns" >/dev/null 2>&1 || kubectl create namespace "$ns"
if ! kubectl -n "$ns" get secret librechat-credentials-env >/dev/null 2>&1; then
  kubectl -n "$ns" create secret generic librechat-credentials-env \
    --from-literal=CREDS_KEY="$(openssl rand -hex 32)" \
    --from-literal=CREDS_IV="$(openssl rand -hex 16)" \
    --from-literal=JWT_SECRET="$(openssl rand -hex 32)" \
    --from-literal=JWT_REFRESH_SECRET="$(openssl rand -hex 32)" \
    --from-literal=OPENID_SESSION_SECRET="$(openssl rand -hex 32)" \
    --from-literal=OPENID_CLIENT_SECRET=not-set \
    --from-literal=AZURE_MODEL_KEY=not-set >/dev/null
fi
kubectl -n "$ns" apply -f local/services.yaml
helm upgrade --install librechat "$chart" --version "$version" --namespace "$ns" \
  -f values.yaml -f local/values.yaml
kubectl -n "$ns" rollout status deployment/librechat-librechat --timeout=20m
echo
echo "De kern draait. Open de chat met:"
echo "  kubectl -n $ns port-forward service/librechat-librechat 3080:3080"
echo "en ga naar http://localhost:3080. Maak een account en stel een vraag."
