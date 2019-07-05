resource "helm_release" "dashboard" {
  count     = "${var.enable_kubernetes_dashboard ? 1 : 0}"
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

  depends_on = [
    "null_resource.wait",
  ]
}
