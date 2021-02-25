provider "aws" {
  region = "eu-west-2"
}

resource "aws_s3_bucket" "example-cbm" {
  bucket = "example-cbm"
  acl    = "private"
}

resource "aws_iam_role" "example-cbm" {
  name = "example-cbm"

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

resource "aws_iam_role_policy" "example-cbm" {
  role = aws_iam_role.example-cbm.name

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

resource "aws_codebuild_project" "example-cbm" {
  name          = "test-project"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.example-cbm.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.example-cbm.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "SOME_KEY1"
      value = "SOME_VALUE1"
    }

    environment_variable {
      name  = "SOME_KEY2"
      value = "SOME_VALUE2"
      type  = "PARAMETER_STORE"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.example-cbm.id}/build-log"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/matthewmacklin/terraform-cbm"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "master"

#   vpc_config {
#     vpc_id = aws_vpc.example-cbm.id

#     subnets = [
#     #   aws_subnet.example1.id,
#     #   aws_subnet.example2.id,
#     ]

#     security_group_ids = [
#     #   aws_security_group.example1.id,
#     #   aws_security_group.example2.id,
#     ]
#   }

  tags = {
    Environment = "Test"
  }
}

resource "aws_codebuild_project" "project-with-cache" {
  name           = "test-project-cache"
  description    = "test_codebuild_project_cache"
  build_timeout  = "5"
  queued_timeout = "5"

  service_role = aws_iam_role.example-cbm.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "SOME_KEY1"
      value = "SOME_VALUE1"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/mitchellh/packer.git"
    git_clone_depth = 1
  }

  tags = {
    Environment = "Test"
  }
}