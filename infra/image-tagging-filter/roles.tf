resource "aws_iam_role" "lambda-image-tagging-role" {
  name               = "${var.prefix}-role"
  assume_role_policy = file("${path.module}/lambdaRole.json")
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda-image-tagging-attach" {
  role       = aws_iam_role.lambda-image-tagging-role.name
  count      = length(var.iam_policy_arn)
  policy_arn = var.iam_policy_arn[count.index]
}

resource "aws_iam_role_policy" "lambda-image-tagging-kms" {
  name = "${var.prefix}-kms-policy"
  role = aws_iam_role.lambda-image-tagging-role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey"
        ],
        "Resource" : "arn:aws:kms:us-east-1:489716104000:key/*"
      }
    ]
  })
}

resource "aws_ssm_parameter" "ssm-lambda-image-tagging-role" {
  name        = "/${var.prefix}/lambda-image-tagging-role"
  description = "Lambda role for image tagging"
  type        = "String"
  value       = aws_iam_role.lambda-image-tagging-role.arn
}
