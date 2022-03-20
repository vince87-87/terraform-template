resource "aws_security_group" "this-sg" {
  for_each    = var.security_group
  name        = each.value.name
  description = each.value.description
  vpc_id      = var.vpcid

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { "Name" = each.value.name },
    var.common_tags,
  )
}

resource "aws_security_group_rule" "using-cidr_blocks" {
  for_each          = var.create_SG_Cidr_Block ? var.ingress_rule : {}
  type              = "ingress"
  description       = each.value.description
  from_port         = each.value.fromport
  to_port           = each.value.toport
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = each.value.security_group_id
}

resource "aws_security_group_rule" "using-sourcesg-id" {
  for_each                 = var.create_SG_SourceSG_ID ? var.ingress_rule_sourceid : {}
  type                     = "ingress"
  description              = each.value.description
  from_port                = each.value.fromport
  to_port                  = each.value.toport
  protocol                 = each.value.protocol
  source_security_group_id = each.value.sourcesgid
  security_group_id        = each.value.security_group_id
}