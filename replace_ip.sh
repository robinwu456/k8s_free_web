#!/bin/bash

mysql_ip=$(kubectl get service -n bliss-prod | grep mysql | awk '{print $3}')
echo $mysql_ip

sed -i s/NNF_DB_HOST=10.98.0.254/NNF_DB_HOST=$mysql_ip/g free_web.env
