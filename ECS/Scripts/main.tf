resource "aws_ecr_repository" "ecr_repo" {
  name                 = "ecr-repo-1" 
  image_tag_mutability = "MUTABLE"
  

  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_ecs_cluster" "my_fargate_cluster" {
  name = "my-fargate-cluster"
}

resource "aws_ecs_task_definition" "my_fargate_task" {
  family                   = "my-fargate-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "nginx-container"
      image     = "nginx"
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

resource "aws_ecs_service" "my_fargate_service" {
  name            = "my-fargate-service"
  cluster         = aws_ecs_cluster.my_fargate_cluster.id
  task_definition = aws_ecs_task_definition.my_fargate_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-abc123"]
    security_groups = ["sg-abc123"]
    assign_public_ip = true
  }
}