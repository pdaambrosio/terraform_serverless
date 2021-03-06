resource "aws_elasticsearch_domain" "elasticsearch-images" {
  depends_on            = [aws_iam_service_linked_role.elasticsearch-images-linked-role]
  domain_name           = "elk-images"
  elasticsearch_version = "7.10"

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  cluster_config {
    dedicated_master_enabled = false
    instance_count           = 1
    instance_type            = "t3.small.elasticsearch"
  }

  advanced_security_options {
    enabled = false
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

resource "aws_elasticsearch_domain_policy" "policy-elk-images" {
  domain_name     = aws_elasticsearch_domain.elasticsearch-images.domain_name
  access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "${aws_elasticsearch_domain.elasticsearch-images.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_ssm_parameter" "ssm-elasticsearch-endpoint" {
  name = "/${var.prefix}/elasticsearch-endpoint"
  depends_on = [
    aws_elasticsearch_domain.elasticsearch-images
  ]
  description = "Endpoint for Elasticsearch"
  type        = "String"
  value       = aws_elasticsearch_domain.elasticsearch-images.endpoint
}
