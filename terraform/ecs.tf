resource "aws_ecs_cluster" "prasad_ecs" {
  name = "prasad-ecs"
}

resource "aws_ecs_task_definition" "simple_task" {
  family = "simple-task"
  container_definitions = jsonencode([
    {
      "name" : "nodejs-app",
      "image" : "ghcr.io/prprasad2020/gh-actions-with-codedeploy:latest",
      "cpu" : 256,
      "memory" : 512,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 3000,
          "hostPort" : 3000
        }
      ]
    }
  ])
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = "256"
  memory                   = "512"
}

resource "aws_ecs_service" "nodejs_app_service" {
  name            = "nodejs-app-service"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.prasad_ecs.id
  task_definition = aws_ecs_task_definition.simple_task.arn
  desired_count   = 1

  network_configuration {
    subnets         = data.aws_subnets.private.ids
    security_groups = [data.aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.prasad_blue_tg.arn
    container_name   = "nodejs-app"
    container_port   = 3000
  }

  deployment_controller {
      type = "CODE_DEPLOY"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_lb" "prasad_lb" {
  name               = "prasad-lb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [data.aws_security_group.ecs_sg.id]
  subnets            = data.aws_subnets.private.ids
}

resource "aws_lb_target_group" "prasad_blue_tg" {
  name     = "prasad-blue-tg"
  port     = 80
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "prasad_green_tg" {
  name     = "prasad-green-tg"
  port     = 80
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "prasad_listener_80" {
  load_balancer_arn = aws_lb.prasad_lb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.prasad_blue_tg.id
    type             = "forward"
  }
}
