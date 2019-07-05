resource "helm_release" "metrics-server" {
  depends_on = [
    "null_resource.wait",
  ]

  count      = "${var.metrics_server_enabled ? 1 : 0}"
  name       = "metrics-server"
  repository = "${data.helm_repository.stable.metadata.0.name}"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = "2.8.2"

  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }
}
