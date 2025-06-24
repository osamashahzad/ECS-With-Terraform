resource "aws_ecs_service" "my_service" {
  name            = "${var.env}-${var.project_name}-be"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.example.arn
  desired_count   = 1
  health_check_grace_period_seconds = 120
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = lower("${var.env}-${var.project_name}-container")
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = var.private_subnets_ids
    security_groups  = var.ecs_sg_id
    assign_public_ip = var.create_nat_gateway ? false : true
  }
}
