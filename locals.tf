locals {
  config = yamldecode(file("${path.module}/configuration/${var.environment}.yaml")) # Read the YAML config file

  prefix_name = local.config.general.prefix_name # shorten for ease of use
}