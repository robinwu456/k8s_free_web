#!/bin/bash

sudo podman build --tls-verify=false -t quay.io/robinwu456/bliss_free_web .
[ $? != "0" ] && exit 1

#sudo podman stop free_web
#sudo podman run --rm --name free_web -h free_web -d -p 8090:8090 quay.io/robinwu456/bliss_free_web
#sudo podman run --rm --name free_web -h free_web -d -p 20001:20001 quay.io/robinwu456/bliss_free_web
#sudo podman exec -it free_web /bin/bash

sudo podman push --tls-verify=false quay.io/robinwu456/bliss_free_web
