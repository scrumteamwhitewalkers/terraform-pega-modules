module "files" {
  source  = "matti/resource/shell"
  command = "${local_file.alb_ingress_hostname.content}"
}
