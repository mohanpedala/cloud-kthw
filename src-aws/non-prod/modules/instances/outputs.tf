output "vm_hostnames" {
#   value = "${local.*.master_hostnames}"
    value = "${split(",", replace(join(",", aws_instance.vms.*.private_dns), ".${var.aws_region}.compute.internal", ""))}"
}

# output "vm_worker_hostnames" {
# #   value = "${local.*.worker_hostnames}"
#     value = "${split(",", replace(join(",", aws_instance.worker.*.private_dns), ".${var.aws_region}.compute.internal", ""))}"
# }

output "private_ip" {
  value = "${aws_instance.vms.*.private_ip}"
}

output "public_ip" {
  value = "${aws_instance.vms.*.public_ip}"
}