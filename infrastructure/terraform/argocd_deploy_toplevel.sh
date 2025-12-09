helm --kubeconfig=kubeconfig upgrade --install argocd argo/argo-cd --create-namespace -n argocd -f argocd-install-answers.yml --wait
KUBECONFIG=./kubeconfig argocd login --core
KUBECONFIG=./kubeconfig kubectl config set-context --current --namespace=argocd
KUBECONFIG=./kubeconfig argocd app create 0-toplevel --repo https://github.com/dustinmhorvath/k8s_workspace.git --path deployments/argo --dest-server https://kubernetes.default.svc --dest-namespace argocd
