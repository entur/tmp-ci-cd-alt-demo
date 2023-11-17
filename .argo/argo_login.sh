#!/bin/bash
ARGOCD_SERVER_PASSWORD="admin"
ARGOCD_ROUTE="127.0.0.1"
PORT=8080
argocd --insecure --grpc-web login ${ARGOCD_ROUTE}:${PORT} --username admin --password ${ARGOCD_SERVER_PASSWORD}
