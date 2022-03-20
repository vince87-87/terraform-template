resource "aws_ecr_repository" "this" {
  count = var.create_ecr ? 1 : 0
  name                 = join("-",["${var.applications}","ecr",count.index+1])
  image_tag_mutability = var.image_tag_mutability

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key = var.kms_key
  }

  image_scanning_configuration {
    scan_on_push = var.enable_scan ? true : false
  }
  tags = merge(
    {
        "Name" = var.tag_name_ecr
    },
    var.common_tags,
  )
}