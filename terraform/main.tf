provider "aws" {
  region = "eu-west-2"
}

# terraform {
#   backend "s3" {
#     bucket = "cbm-tfstate"
#     key    = "app-state"
#     region = var,region
#     encrypt = true
#   }
# }

# resource "aws_iam_role" "cbm_codebuild" {
#   name = "cbm_codebuild"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": ["codebuild.amazonaws.com",
#                     "events.amazonaws.com"
#         ]
        
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_role_policy" "cbm_codebuild_policy" {
#   role = aws_iam_role.cbm_codebuild.name

#   policy = <<POLICY
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Resource": [
#               "*"
#             ],
#             "Action": [
#                 "sns:*",
#                 "ssm:*",
#                 "kms:*",
#                 "rds:*",
#                 "s3:*",
#                 "firehose:*",
#                 "logs:*",
#                 "cloudformation:*",
#                 "elasticloadbalancing:*",
#                 "autoscaling-plans:*",
#                 "es:*",
#                 "ecr:*",
#                 "apigateway:*",
#                 "dynamodb:*",
#                 "lambda:*",
#                 "events:*",
#                 "sqs:*",
#                 "autoscaling:*",
#                 "iam:*",
#                 "elasticbeanstalk:*",
#                 "secretsmanager:*",
#                 "route53:*",
#                 "ec2:*",
#                 "ram:*",
#                 "kinesis:*",
#                 "codebuild:*",
#                 "cloudwatch:*",
#                 "elasticfilesystem:*"
#             ]
#         }
#     ]
#   }
#   POLICY
# }

# data "aws_secretsmanager_secret_version" "creds" {
#   secret_id = "Codebuild_github_token"
# }

# locals {
#   gh_credentials = jsondecode(
#     data.aws_secretsmanager_secret_version.creds.secret_string
#   )
# }

# resource "aws_codebuild_source_credential" "github_token" {
#   auth_type   = "PERSONAL_ACCESS_TOKEN"
#   server_type = "GITHUB"
#   token       = local.gh_credentials.CODEBUILD_GITHUB_TOKEN
# }