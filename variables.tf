variable "enable" {
  description = "Enable the schedule"
  type        = bool
  default     = true
}

variable "git" {
  description = "Name of the Git repo"
  type        = string
}

variable "host" {
  description = "Host to connect to"
  type        = string
}

variable "interval_minutes" {
  description = "How often to run"
  type        = number
  default     = 5
}

variable "private_subnet_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster#subnet_ids"
  type        = list(string)
  default     = []
}

variable "memory_size" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#memory_size"
  type        = number
  default     = 128
}

variable "name" {
  description = "Used to label all resources"
  type        = string
  default     = null
}

variable "port" {
  description = "Port to connect to"
  type        = number
}

variable "retention_in_days" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group#retention_in_days"
  type        = number
  default     = 365
}

variable "tags" {
  description = "Map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "timeout" {
  description = "Connection timeout"
  type        = number
  default     = 3
}

variable "vpc_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#vpc_id"
  type        = string
  default     = null
}
