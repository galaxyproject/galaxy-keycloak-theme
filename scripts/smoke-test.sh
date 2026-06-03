#!/usr/bin/env bash
set -euo pipefail

AUTH_URL="http://localhost:8080/realms/galaxy-dev/protocol/openid-connect/auth?client_id=security-admin-console&response_type=code&redirect_uri=http://localhost:8080"

cleanup() { docker compose down -v >/dev/null 2>&1 || true; }
trap cleanup EXIT

docker compose up -d
echo "Waiting for Keycloak..."
for i in $(seq 1 90); do
  if curl -sf -o /dev/null "http://localhost:8080/realms/galaxy-dev/.well-known/openid-configuration"; then break; fi
  sleep 2
done

HTML="$(curl -s "$AUTH_URL")"

echo "$HTML" | grep -q 'login/galaxy/'  || { echo "FAIL: galaxy login theme not active"; exit 1; }
echo "$HTML" | grep -q 'css/galaxy.css' || { echo "FAIL: galaxy.css not linked"; exit 1; }
echo "$HTML" | grep -qi 'kc-header'     || { echo "FAIL: header element missing"; exit 1; }

# Resource path segment as used in the page (e.g. /resources/<build>/login/galaxy)
RES_BASE="$(echo "$HTML" | grep -oE '/resources/[^"]*/login/galaxy' | head -1)"
[ -n "$RES_BASE" ] || { echo "FAIL: could not derive resource base"; exit 1; }

curl -sf -o /dev/null "http://localhost:8080${RES_BASE}/css/galaxy.css"      || { echo "FAIL: galaxy.css 404"; exit 1; }
curl -sf -o /dev/null "http://localhost:8080${RES_BASE}/img/galaxy_logo.svg" || { echo "FAIL: logo 404"; exit 1; }
curl -s "http://localhost:8080${RES_BASE}/css/galaxy.css" | grep -q 'var(--color-galaxy-gold)' || { echo "FAIL: brand vars missing"; exit 1; }

echo "PASS: galaxy theme renders with brand CSS and logo"
