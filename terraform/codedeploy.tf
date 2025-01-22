resource "aws_s3_bucket" "nodejs_app_bucket" {
  bucket = "simple-nodejs-app-bucket"
}

resource "aws_s3_bucket_ownership_controls" "nodejs_app_bucket_ownership" {
  bucket = aws_s3_bucket.nodejs_app_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "nodejs_app_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.nodejs_app_bucket_ownership]

  bucket = aws_s3_bucket.nodejs_app_bucket.id
  acl    = "private"
}

resource "aws_codedeploy_app" "prasad_codedeploy_app" {
  name             = "prasad-codedeploy-app"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "prasad_dg" {
  app_name              = aws_codedeploy_app.prasad_codedeploy_app.name
  deployment_group_name = "prasad-deployment-group"
  service_role_arn      = aws_iam_role.prasad_codedeploy_role.arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  ecs_service {
    cluster_name = aws_ecs_cluster.prasad_ecs.name
    service_name = aws_ecs_service.nodejs_app_service.name
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.prasad_listener_80.arn]
      }

      target_group {
        name = aws_lb_target_group.prasad_blue_tg.name
      }

      target_group {
        name = aws_lb_target_group.prasad_green_tg.name
      }
    }
  }
}

resource "aws_iam_role" "prasad_codedeploy_role" {
  name = "CodeDeployServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  role       = aws_iam_role.prasad_codedeploy_role.name
  policy_arn = data.aws_iam_policy.codedeploy_service_policy.arn
}
