data "aws_ecr_repository" "my_repo" {
  name = var.repository
}
data "aws_iam_role" "ecs_task_execution" {
  name = "ecstaskexecutionrole" 
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

  execution_role_arn = data.aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "my-container"
      image     = "061039780090.dkr.ecr.${var.aws_region}.amazonaws.com/${data.aws_ecr_repository.my_repo.name}:${var.image_tag}"
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
    subnets         = ["subnet-00c7ee2f49a8c15f0"]
    security_groups = ["sg-093feeb560f85a718"]
  }
}