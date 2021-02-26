# provider "aws" {
#   region = "eu-west-2"
# }

# # terraform {
# #   backend "s3" {
# #     bucket = "cbm_2"
# #     key    = "app-state"
# #     region = "eu-west-2"
# #     encrypt = true
# #   }
# # }
# resource "aws_s3_bucket" "cbm-2" {
#   bucket = "cbm-2"
#   acl    = "private"
# }

# resource "aws_iam_role" "cbm_codebuild" {
#   name = "cbm-2"

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
#   secret_id = "CBM_GH_TOKEN"
# }

# locals {
#   gh_credentials = jsondecode(
#     data.aws_secretsmanager_secret_version.creds.secret_string
#   )
# }

# resource "aws_codebuild_source_credential" "github_token" {
#   auth_type   = "PERSONAL_ACCESS_TOKEN"
#   server_type = "GITHUB"
#   token       = local.gh_credentials.cbm_gh_token
# }


# resource "aws_codebuild_project" "cbm-2" {
#   name          = "deploy-prod"
#   description   = "Just practicing codebuild integreation with terraform"
#   build_timeout = "120"
#   service_role  = aws_iam_role.cbm_codebuild.arn

#   artifacts {
#     type = "NO_ARTIFACTS"
#   }

#   environment {
#     compute_type                = "BUILD_GENERAL1_LARGE"
#     image                       = "aws/codebuild/standard:5.0"
#     type                        = "LINUX_CONTAINER"
#     privileged_mode             = true
#   }

#   source {
#     type            = "GITHUB"
#     location        = "https://github.com/matthewmacklin/terraform-cbm"
#     git_clone_depth = 1
#     buildspec       = "./codebuild/buildspec.yml"
#   }
#   source_version = "master"
# }
