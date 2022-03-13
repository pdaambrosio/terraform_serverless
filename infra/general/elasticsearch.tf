resource "aws_elasticsearch_domain" "elasticsearch-images" {
  domain_name           = "elk-images"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_count = 1
    instance_type  = "t2.small.elasticsearch"
  }

  vpc_options {
    subnet_ids         = [aws_subnet.elasticsearch-vpc-private[0].id]
    security_group_ids = [aws_security_group.elasticsearch-security-group.id]
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
    volume_type = "gp2"
  }

  tags = var.tags
}

resource "aws_iam_service_linked_role" "elasticsearch-images-linked-role" {
  aws_service_name = "es.amazonaws.com"
  description      = "Allows Amazon ES to manage AWS resources for a domain."
}
