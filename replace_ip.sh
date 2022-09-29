#!/bin/bash

mysql_ip=$(kubectl get service -n bliss-prod | grep mysql | awk '{print $3}')
redis_ip=$(kubectl get service -n bliss-prod | grep redis | awk '{print $3}')

sed -i s/NNF_DB_HOST=10.98.0.254/NNF_DB_HOST=$mysql_ip/g free_web.env
sed -i s/NNF_REDIS_HOST=10.98.0.118/NNF_REDIS_HOST=$redis_ip/g free_web.env

cat free_web.env
