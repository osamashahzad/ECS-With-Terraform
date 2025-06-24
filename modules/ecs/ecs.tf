resource "aws_ecs_cluster" "ecs_cluster" {
  name = "Cluster-${var.env}-${var.project_name}"
  tags = merge(var.default_tags, {
    Name        = "cluster-${var.env}-${var.project_name}"
    description = "Cluster for ${var.env}-${var.project_name}"
  })
}