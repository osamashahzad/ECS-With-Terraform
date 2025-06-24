resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = lower("${var.env}-${var.project_name}-ecr-repo")
  image_tag_mutability = "MUTABLE" # or "IMMUTABLE"
  force_delete = true
  image_scanning_configuration {
    scan_on_push = false
  }

  tags = merge(var.default_tags, {
    Name        = "ecr-${var.env}-${var.project_name}"
    description = "ecr for ${var.env}-${var.project_name}"
  })
}