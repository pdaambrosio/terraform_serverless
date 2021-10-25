resource "aws_iam_role" "lambda-thumbnail-role" {
    name = "${var.prefix}-role"
    assume_role_policy = "${file("${path.module}/lambdaRole.json")}"
    tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda-thumbnail-attach" {
    role = aws_iam_role.lambda-thumbnail-role.name
    count = length(var.iam_policy_arn)
    policy_arn = var.iam_policy_arn[count.index]
}

resource "aws_iam_role_policy" "lambda-thumbnail-kms" {
  name = "${var.prefix}-kms-policy"
  role = aws_iam_role.lambda-thumbnail-role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:Encrypt",
                "kms:GenerateDataKey"
            ],
            "Resource": "arn:aws:kms:us-east-1:489716104000:key/*"
        }
    ]
  })
}