pipeline {
    agent {
        kubernetes {
            inheritFrom 'bliss'
            defaultContainer 'p1'
            yaml """
apiVersion: v1
kind: Pod
spec:
  imagePullSecrets:
    - name: regcred
  containers:
  - name: jnlp
    image: quay.io/flysangel/inbound-agent:4.13-2-jdk11
  - name: p1
    securityContext:
      privileged: true
    image: quay.io/podman/stable:v3.4.7
    command: ["sleep"]
    args: ["infinity"]
  - name: k1
    securityContext:
      privileged: true
    image: bitnami/kubectl
    command: ["sleep"]
    args: ["infinity"]
"""
        }
    }
    environment {
        QUAY_ADMIN = credentials('quay-cred')
        KUBECONFIG = credentials('kubeconfig-cred')
        IMAGE_TAG = "quay.io/robinwu456/bliss_free_web:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"
    }
    stages {
    	stage ('get mysql/redis ip') {
	    steps {
	        container('k1') {
                    sh "kubectl get service -n bliss-prod | grep mysql | awk '{print \$3}' | tee mysql_ip"
                    sh "kubectl get service -n bliss-prod | grep redis | awk '{print \$3}' | tee redis_ip"
                    sh 'ls -al'
                    sh 'cat mysql_ip'
                    sh 'cat redis_ip'
		}
	    }
	}
	stage ('build free-web') {
            steps {
	    	sh 'export MYSQL_IP=$(cat mysql_ip)'
		sh 'echo ${MYSQL_IP}'
		sh "sed 's/NNF_DB_HOST=10.98.0.254/NNF_DB_HOST=\$(cat mysql_ip)/g' free_web.env"
                //sh 'podman login --tls-verify=false -u=${QUAY_ADMIN_USR} -p=${QUAY_ADMIN_PSW} quay.io'
                //sh 'podman build --cache-from --tls-verify=false -t "${IMAGE_TAG}" .'
                //sh 'podman images'
                //sh 'podman push --tls-verify=false "${IMAGE_TAG}"'
            }
        }
        stage ('deploy free-web-prod') {
            when { branch 'master' }
            steps {
                container('k1') {
		    sh 'ls -al'
		    sh 'cat mysql_ip'
                    sh 'mkdir -p ~/.kube && cp ${KUBECONFIG} ~/.kube/config'
                    sh "sed -i.bak 's#quay.io/robinwu456/bliss_free_web#${IMAGE_TAG}#' deploy/free_web.yaml"
                    sh 'kubectl apply -f deploy/service_free_web.yaml -n bliss-prod'
                    sh 'kubectl apply -f deploy/free_web.yaml -n bliss-prod'
                }
            }
        }
    }
}
