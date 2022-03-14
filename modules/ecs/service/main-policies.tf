data "aws_iam_policy_document" "ecs_task_execution" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.cluster_name}-${var.service_name}-ecs_task_execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  count = length(var.policies_arn)

  role       = aws_iam_role.ecs_task_execution.id
  policy_arn = element(var.policies_arn, count.index)
}
