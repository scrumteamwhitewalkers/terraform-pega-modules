resource "null_resource" "alb_delete_ingress" {
  count = "${var.kubernetes_provider == "eks" ? 1 : 0}"

  provisioner "local-exec" {
    when = "destroy"

    command = <<COMMAND
      kubectl delete ingress pega-web -n ${var.namespace} --kubeconfig=./kubeconfig_${var.name} \
      && kubectl delete ingress pega-stream -n ${var.namespace} --kubeconfig=./kubeconfig_${var.name} \
      && sleep 30
    COMMAND
  }

  depends_on = [
    "helm_release.pega",
    "helm_release.aws-alb-ingress-controller",
  ]
}
