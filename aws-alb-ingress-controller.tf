resource "helm_release" "aws-alb-ingress-controller" {
  count      = "${var.alb_ingress_enabled ? 1 : 0}"
  name       = "aws-alb-ingress-controller"
  repository = "${data.helm_repository.incubator.metadata.0.name}"
  chart      = "aws-alb-ingress-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = "${var.name}"
  }

  set {
    name  = "autoDiscoverAwsRegion"
    value = "true"
  }

  set {
    name  = "autoDiscoverAwsVpcID"
    value = "true"
  }

  set {
    name  = "extraEnv.AWS_ACCESS_KEY_ID"
    value = "${var.aws_access_key_id}"
  }

  set {
    name  = "extraEnv.AWS_SECRET_ACCESS_KEY"
    value = "${var.aws_secret_access_key}"
  }

  depends_on = [
    "null_resource.wait",
  ]
}
