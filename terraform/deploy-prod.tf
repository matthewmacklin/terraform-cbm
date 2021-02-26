

resource "aws_s3_bucket" "cbm-prod-codebuild" {
  bucket = "cbm-prod-codebuild"
  acl    = "private"
}

resource "aws_iam_role" "cbm-prod" {
  name = "cbm-prod"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cbm-prod" {
  role = aws_iam_role.cbm-prod.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "*"
      ],
      "Resource": [
        "*"
      ]}
  ]
}
POLICY
}

resource "aws_codebuild_project" "cbm-deploy-prod" {
  name          = "cbm-deploy-prod"
  description   = "practice_codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.cbm-prod.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.cbm-prod-codebuild.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    # environment_variable {
    #   name  = "SOME_KEY1"
    #   value = "SOME_VALUE1"
    # }

    # environment_variable {
    #   name  = "SOME_KEY2"
    #   value = "SOME_VALUE2"
    #   type  = "PARAMETER_STORE"
    # }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.cbm-prod-codebuild.id}/build-log"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/matthewmacklin/terraform-cbm"
    git_clone_depth = 1
    buildspec       = "./codebuild/prod-buildspec.yml"


    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "master"



  tags = {
    Environment = "Prod"
  }
}




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