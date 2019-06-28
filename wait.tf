# The below resource will just wait for the wait_id to build dependency to pega module from outside.
resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "echo ${var.wait_id}"
  }
}
