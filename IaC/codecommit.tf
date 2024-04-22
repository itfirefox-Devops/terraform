# AWS CodeCommit
# variable.tf 로 변수 관리

resource "aws_codecommit_repository" "commit_reps" {
  repository_name = var.repository_name["name"]
  description     = var.repository_name["description"]
}
