data "aws_ecr_repository" "my_repo" {
  name = var.repository
}
resource "aws_ecs_cluster" "my_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "my_task" {
  family                   = var.ecs_task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory

  container_definitions = jsonencode([
    {
      name      = "my-container"
      image     = "061039780090.dkr.ecr.${var.aws_region}.amazonaws.com/${data.aws_ecr_repository.my_repo.name}:latest:${var.image_tag}"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-12345678"]
    security_groups = ["sg-12345678"]
  }
}