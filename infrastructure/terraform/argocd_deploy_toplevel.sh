export KUBECONFIG=./kubeconfig
kubectl apply -f /root/secrets/
helm --kubeconfig=kubeconfig upgrade --install argocd argo/argo-cd --create-namespace -n argocd -f argocd-install-answers.yml --wait
argocd login --core
kubectl config set-context --current --namespace=argocd
argocd app create app-toplevel --repo https://github.com/dustinmhorvath/k8s_workspace.git --path deployments/argo --dest-server https://kubernetes.default.svc --dest-namespace argocd
