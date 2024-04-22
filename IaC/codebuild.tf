resource "random_string" "rand6" {
  length  = 6
  special = false
  upper   = false
}

locals {
  codebuild_project_name = var.project_name

}

 resource "aws_codebuild_project" "codebuild_project" {
  name          = local.codebuild_project_name
  description   = local.codebuild_project_name
  build_timeout = "120"
  service_role  = var.create_role_and_policy ? aws_iam_role.codebuild_role[0].arn : var.codebuild_role_arn


  artifacts {
    type = var.artifacts_type
  }

  source {
    type            = "CODECOMMIT"
    location        = "https://git-codecommit.ap-northeast-2.amazonaws.com/v1/repos/terraform-test"
    git_clone_depth = var.git_clone_depth
    buildspec       = templatefile("${path.cwd}/${var.build_spec_file}", {})
    git_submodules_config {
      fetch_submodules = false
    }
  }

  source_version = "main" #refs/heads/main

  environment {
    image                       = var.build_image
    type                        = "LINUX_CONTAINER"
    compute_type                = var.compute_type
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    dynamic "environment_variable" {
      for_each = var.codebuild_env_vars["LOAD_VARS"] != false ? var.codebuild_env_vars : {}
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }

  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status = "DISABLED"
    }
  }

  # price-group 체크
  tags = merge(var.tags, { "aws-ia_module" = "true" })
}

# IAM
resource "aws_iam_role" "codebuild_role" {
  count = var.create_role_and_policy ? 1 : 0
  name  = "${"${local.codebuild_project_name}"}_codebuild_deploy_role"

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

resource "aws_iam_role_policy_attachment" "codebuild_deploy" {
  role       = aws_iam_role.codebuild_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}