kubectl config set-cluster kubernetes-the-hard-way ^
  --certificate-authority="C:\Users\MBMR0383\Documents\Kubernetes-Terraform-Way\generated\tls\ca.pem" ^
  --embed-certs=true ^
  --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443

kubectl config set-credentials admin ^
  --client-certificate="C:\Users\MBMR0383\Documents\Kubernetes-Terraform-Way\generated\tls\admin.pem" ^
  --client-key="C:\Users\MBMR0383\Documents\Kubernetes-Terraform-Way\generated\tls\admin-key.pem" 

kubectl config set-context kubernetes-the-hard-way ^
  --cluster=kubernetes-the-hard-way ^
  --user=admin

kubectl config use-context kubernetes-the-hard-way

PAUSE