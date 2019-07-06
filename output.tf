output "kubectl_lb_hostname_query" {
  value = "${local_file.kubectl_lb_hostname_query.content}"
}
