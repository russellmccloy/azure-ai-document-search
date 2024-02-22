locals {
  config = yamldecode(file("${path.module}/configuration/${var.environment}.yaml"))
}