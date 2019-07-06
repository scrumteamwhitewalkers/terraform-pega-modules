resource "helm_release" "pega" {
  depends_on = [
    "null_resource.wait",
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
    name  = "jdbc.username"
    value = "${var.jdbc_username}"
  }

  set {
    name  = "jdbc.password"
    value = "${var.jdbc_password}"
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
    name  = "docker.registry.url"
    value = "${var.docker_url}"
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

resource "local_file" "kubectl_lb_hostname_query" {
  depends_on = [
    "helm_release.pega",
  ]

  content  = "kubectl get ingress pega-web -n ${var.namespace} --kubeconfig=./kubeconfig_${var.name} -o json | jq -r '.status.loadBalancer.ingress | .[] | .hostname'"
  filename = "${path.module}/ingress_hostname.txt"
}
