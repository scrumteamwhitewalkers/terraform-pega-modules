resource "helm_release" "cluster-autoscaler" {
  count     = "${var.enable_cluster_autoscaler ? 1 : 0}"
  name      = "cluster-autoscaler"
  chart     = "stable/cluster-autoscaler"
  namespace = "kube-system"
  version   = "0.14.2"

  set {
    name  = "rbac.create"
    value = true
  }

  set {
    name  = "sslCertPath"
    value = "/etc/ssl/certs/ca-bundle.crt"
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = "${var.name}"
  }

  set {
    name  = "awsRegion"
    value = "${var.region}"
  }

  set {
    name  = "awsAccessKeyID"
    value = "${var.aws_access_key_id}"
  }

  set {
    name  = "awsSecretAccessKey"
    value = "${var.aws_secret_access_key}"
  }

  set {
    name  = "cloudProvider"
    value = "${var.cloud_provider}"
  }

  set {
    name  = "fullnameOverride"
    value = "cluster-autoscaler"
  }

  depends_on = [
    "null_resource.wait",
  ]
}
