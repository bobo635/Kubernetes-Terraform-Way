# Borrowed from the Tectonic installer: (https://github.com/coreos/tectonic-installer/blob/master/modules/tls/kube/self-signed/ca.tf)

resource "tls_private_key" "kube_ca" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_self_signed_cert" "kube_ca" {
  key_algorithm   = tls_private_key.kube_ca.algorithm
  private_key_pem = tls_private_key.kube_ca.private_key_pem

  subject {
    common_name         = "Kubernetes"
    organization        = "Kubernetes"
    country             = "FR"
    locality            = "Paris"
    organizational_unit = "CA"
    province            = "IdF"
  }

  is_ca_certificate     = true
  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
    "client_auth",
    "server_auth",
  ]
}

resource "local_file" "kube_ca_key" {
  content  = tls_private_key.kube_ca.private_key_pem
  filename = "./generated/tls/ca-key.pem"
}

resource "local_file" "kube_ca_crt" {
  content  = tls_self_signed_cert.kube_ca.cert_pem
  filename = "./generated/tls/ca.pem"
}

resource "null_resource" "ca_certs" {
  count = var.MasterCount

  depends_on = [
    local_file.kube_ca_key,
    local_file.kube_ca_crt,
  ]

  connection {
    type         = "ssh"
    user         = var.node_user
    host         = element(var.apiserver_node_names, count.index)
    password     = var.node_password
    bastion_host = var.bastionIP
  }

  provisioner "file" {
    source      = "./generated/tls/ca.pem"
    destination = "~/ca.pem"
  }

  provisioner "file" {
    source      = "./generated/tls/ca-key.pem"
    destination = "~/ca-key.pem"
  }
}

