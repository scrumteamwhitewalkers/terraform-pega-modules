module "files" {
  version = "v0.12.0"
  source  = "matti/resource/shell"
  command = "${local_file.alb_ingress_hostname.content}"
}
