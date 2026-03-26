#!/bin/bash
# Simple script to verify the service is reachable
export SERVICE_IP=$(kubectl get svc kubernetes-bootcamp-service -o jsonpath='{.spec.clusterIP}')

echo "Testing connection to http://$SERVICE_IP:80..."
curl -s --connect-timeout 2 http://$SERVICE_IP | grep "Hello"

if [ $? -eq 0 ]; then
  echo " Application is reachable!"
else
  echo " Connection failed."
fi
