output "eks_pega_lb_hostname" {
  value = "${local_file.alb_ingress_hostname.content}"
}
