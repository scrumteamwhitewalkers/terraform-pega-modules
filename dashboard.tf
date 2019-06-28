resource "helm_release" "dashboard" {
  depends_on = [
    "null_resource.tiller",
    "kubernetes_service_account.tiller",
    "kubernetes_cluster_role_binding.tiller",
  ]

  count     = "${var.enable_dashboard ? 1 : 0}"
  name      = "dashboard"
  chart     = "stable/kubernetes-dashboard"
  namespace = "kube-system"

  set {
    name  = "rbac.create"
    value = true
  }

  set {
    name  = "rbac.clusterAdminRole"
    value = true
  }

  set {
    name  = "enableSkipLogin"
    value = true
  }

  set {
    name  = "enableInsecureLogin"
    value = true
  }

  set {
    name  = "fullnameOverride"
    value = "kubernetes-dashboard"
  }
}
