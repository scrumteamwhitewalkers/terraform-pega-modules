module "files" {
  version         = "${var.resource_shell_version}"
  source  = "matti/resource/shell"
  command = "${local_file.alb_ingress_hostname.content}"
}
