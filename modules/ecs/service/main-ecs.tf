locals {
  service_version = var.service_version != "" ? var.service_version : "latest"
  service_image   = "${var.service_image}:${local.service_version}"
}

module "container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "v0.46.2"

  container_name               = var.service_name
  container_image              = local.service_image
  container_cpu                = var.container_cpu
  container_memory             = var.container_memory
  container_memory_reservation = var.container_memory_reservation

  port_mappings = [
    {
      containerPort = var.service_port
      hostPort      = var.service_port
      protocol      = "tcp"
    },
  ]

  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-region        = module.cw.region
      awslogs-group         = module.cw.name
      awslogs-stream-prefix = "ecs"
    }
    secretOptions = []
  }

  environment = concat(
    var.container_environment_variables,
  )

  secrets = concat(
    var.container_environment_secrets,
  )
}

resource "aws_ecs_task_definition" "this" {
  family = "${var.cluster_name}-${var.service_name}"

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory

  execution_role_arn    = aws_iam_role.ecs_task_execution.arn
  task_role_arn         = aws_iam_role.ecs_task_execution.arn
  container_definitions = "[${module.container_definition.json_map_encoded}]"

  tags = var.tags
}

data "aws_ecs_task_definition" "this" {
  task_definition = "${var.cluster_name}-${var.service_name}"

  depends_on = [aws_ecs_task_definition.this]
}

resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = var.cluster_name
  task_definition = "${data.aws_ecs_task_definition.this.family}:${max(aws_ecs_task_definition.this.revision, data.aws_ecs_task_definition.this.revision)}"

  desired_count       = var.service_desired_count
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [module.service_sg.security_group_id]
    assign_public_ip = false
  }

  dynamic "load_balancer" {
    for_each = var.expose_service == true ? [0] : []

    content {
      container_name   = var.service_name
      container_port   = var.service_port
      target_group_arn = element(module.lb[0].target_group_arns, 0)
    }
  }

  lifecycle {
    ignore_changes = [
      desired_count,
    ]
  }

  tags = var.tags
}
