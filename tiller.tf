/*provider "helm" {
  version         = "~> 0.10"
  install_tiller  = false
  tiller_image    = "${var.tiller_image}"
  service_account = "${kubernetes_service_account.tiller.metadata.0.name}"
  namespace       = "${kubernetes_service_account.tiller.metadata.0.namespace}"

  kubernetes {
    load_config_file = true
    config_path      = "./kubeconfig_${var.name}"
  }
}

resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }

  automount_service_account_token = true

  depends_on = [
    "null_resource.wait",
  ]
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "tiller"
    namespace = "kube-system"
  }

  depends_on = [
    "kubernetes_service_account.tiller",
  ]
}

resource "null_resource" "tiller" {
  depends_on = ["null_resource.wait"]

  provisioner "local-exec" {
    command = "helm init --wait --upgrade --force-upgrade --service-account tiller --kubeconfig ./kubeconfig_${var.name} --tiller-connection-timeout 300"
  }

  provisioner "local-exec" {
    command = "helm reset --force --kubeconfig ./kubeconfig_${var.name} --tiller-connection-timeout 300 && sleep 180"
    when    = "destroy"
  }
}*/

