resource "helm_release" "pega" {
  depends_on = [
    "null_resource.tiller",
    "kubernetes_service_account.tiller",
    "kubernetes_cluster_role_binding.tiller",
  ]

  namespace  = "${var.namespace}"
  chart      = "${var.chart_name}"
  version    = "${var.chart_version}"
  name       = "${var.release_name}"
  timeout    = "${var.deployment_timeout}"
  repository = "${data.helm_repository.pega.metadata.0.name}"
  wait       = true
  values     = ["${file(format("%s/%s",path.module,"templates/${var.kubernetes_provider}_values.tpl"))}"]

  set {
    name  = "jdbc.url"
    value = "${var.jdbc_url}"
  }

  set {
    name  = "docker.registry.username"
    value = "${var.docker_username}"
  }

  set {
    name  = "docker.registry.password"
    value = "${var.docker_password}"
  }

  set {
    name  = "web.domain"
    value = "${var.name}-web.${var.route53_zone}"
  }

  set {
    name  = "stream.domain"
    value = "${var.name}-stream.${var.route53_zone}"
  }

  set {
    name  = "aws-alb-ingress-controller.extraEnv.AWS_ACCESS_KEY_ID"
    value = "${var.aws_access_key_id}"
  }

  set {
    name  = "aws-alb-ingress-controller.extraEnv.AWS_SECRET_ACCESS_KEY"
    value = "${var.aws_secret_access_key}"
  }

  set {
    name  = "aws-alb-ingress-controller.clusterName"
    value = "${var.name}"
  }
}

resource "null_resource" "delete_ingress" {
  depends_on = [
    "helm_release.pega",
  ]

  provisioner "local-exec" {
    when = "destroy"

    command = <<COMMAND
      kubectl delete ingress pega-web -n ${var.namespace} --kubeconfig=./kubeconfig_${var.name} \
      && kubectl delete ingress pega-stream -n ${var.namespace} --kubeconfig=./kubeconfig_${var.name} \
      && sleep 30
    COMMAND
  }
}

resource "local_file" "alb_ingress_hostname" {
  depends_on = [
    "helm_release.pega",
  ]

  content  = "kubectl get ingress pega-web -n ${var.namespace} --kubeconfig=./kubeconfig_${var.name} -o json | jq -r '.status.loadBalancer.ingress | .[] | .hostname'"
  filename = "${path.module}/ingress_hostname.txt"
}
