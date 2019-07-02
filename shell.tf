module "files" {
  version         = "v0.12.0"
  source  = "github.com/matti/terraform-shell-resource.git?ref=${var.shell_module_branch}"
  command = "${local_file.alb_ingress_hostname.content}"
}
