variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "account_id" {
  type = string
}

variable "region" {
  type    = string
  default = "ap-northeast-2"
}

# code-commit variable info
variable "repository_name" {
  description = "terraform test repository"
  default     = {
    name      = "terraform-test"
    description = "terraform test description"
  }
}
variable "repository_description" {
  description = "terraform repository description"
  default     = "terraform test description"
}

# code-build variable info
variable "artifacts_type" {
  description = "Type of artifacts (supports: NO_ARTIFACTS or CODEPIPELINE)"
  default     = "NO_ARTIFACTS"
}
variable "project_name" {
  description = "Codebuild Project Name (Leave empty to autogenerate}"
  default     = "terraform-test-cd"
}
variable "http_git_clone_url" {
  description = "Enter: Git Clone URL"
  type        = string
  default     = "https://github.com/aws-ia/terraform-modules-examples"
}
variable "git_clone_depth" {
  description = "Repo clone depth"
  default     = "1"
}
variable "build_image" {
  description = "Build container image"
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
}
variable "compute_type" {
  description = "Compute type"
  default     = "BUILD_GENERAL1_MEDIUM"
}
variable "build_spec_file" {
  description = "Build spec file name "
  default     = "buildspecs/codebuild_env.yml"
}
variable "tags" {
  description = "Codebuild Tags"
  default     = { "price-group" = "SS00100_infra_base" }
}
variable "create_role_and_policy" {
  description = "Create a new IAM role and policy if true"
  type        = bool
  default     = true
}
variable "codebuild_role_arn" {
  description = "ARN of the existing codebuild role"
  type        = string
  default     = ""
}