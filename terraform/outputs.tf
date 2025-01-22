output "ecs_cluster_name" {
  value = aws_ecs_cluster.prasad_ecs.name
}

output "codedeploy_app_name" {
  value = aws_codedeploy_app.prasad_codedeploy_app.name
}
