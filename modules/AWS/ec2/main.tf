resource "aws_instance" "this" {
  count                       = var.create_instance ? var.number_of_instance : 0
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  availability_zone           = var.AZ
  disable_api_termination     = var.termination_protection
  iam_instance_profile        = var.iam_roles
  vpc_security_group_ids      = var.sg_id
  get_password_data           = var.get_password_data # windows instance
  private_ip                  = var.private_ip
  secondary_private_ips       = var.secondary_private_ips
  key_name                    = var.keypair
  monitoring                  = var.monitoring
  subnet_id                   = var.subnet_id
  user_data                   = var.user_data
  tags = merge(
    {
      "Name" = var.tag_ec2_name
    },
    var.common_tags,
  )

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      throughput            = lookup(root_block_device.value, "throughput", null)
      tags                  = lookup(root_block_device.value, "tags", null)
    }
  }

#   dynamic "ebs_block_device" {
#     for_each = var.ebs_block_device
#     content {
#       delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
#       device_name           = lookup(ebs_block_device.value, "device_name",null )
#       encrypted             = lookup(ebs_block_device.value, "encrypted", null)
#       iops                  = lookup(ebs_block_device.value, "iops", null)
#       kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
#       snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
#       volume_size           = lookup(ebs_block_device.value, "volume_size", null)
#       volume_type           = lookup(ebs_block_device.value, "volume_type", null)
#       throughput            = lookup(ebs_block_device.value, "throughput", null)
#     }
#   }

}