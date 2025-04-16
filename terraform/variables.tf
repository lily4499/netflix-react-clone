variable "aws_region" {
  description = "The AWS region where the resources will be provisioned."
  default     = "us-east-1"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB and ECS service."
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where resources will be created."
  type        = string
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  default     = "lili-ecs-cluster"
}

variable "task_family" {
  description = "The family name for the ECS task definition."
  default     = "my-task-family-test"
}

variable "image_tag" {
  description = "Version tag to use for the Docker image"
  type        = string
}


variable "node_image" {
  description = "The Docker image for container 1."
  default     = "laly9999/netflix-app:latest"
}

variable "service_name" {
  description = "The name of the ECS service."
  default     = "my-service"
}

variable "ecs_task_execution_role_name" {
  description = "The name of the IAM role for ECS task execution."
  default     = "ecs_task_execution_role"
}

variable "node_container_port" {
  description = "Port exposed by the container."
  type        = number
}
