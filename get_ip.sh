sudo podman inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' free_web
