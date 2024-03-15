locals {
  config = yamldecode(file("${path.module}/configuration/${var.environment}.yaml"))

  prefix_name = local.config.general.prefix_name
}