resource "helm_release" "metrics-server" {
  count     = "${var.enable_metrics_server ? 1 : 0}"
  name      = "metrics-server"
  chart     = "stable/metrics-server"
  namespace = "kube-system"
  version   = "2.8.2"

  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }

  depends_on = [
    "null_resource.wait",
  ]
}
