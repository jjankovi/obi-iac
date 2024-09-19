variable "enviroment" {
  description = "Environment"
  type        = string
}

variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "k8s_namespace" {
  description = "Kubernetes application namespace"
  type        = string
}

variable "k8s_replica_count" {
  description = "Replica count"
  type        = number
  default = 2
}

variable "k8s_app_port" {
  description = "Kubernetes application port"
  type        = string
}

variable "k8s_cpu" {
  description = "CPU setting for container"
  type        = string
}

variable "k8s_cpu_limit" {
  description = "CPU limit setting for container"
  type        = string
}

variable "k8s_memory" {
  description = "Memory setting for container"
  type        = string
}

variable "k8s_memory_limit" {
  description = "Memory limit setting for container"
  type        = string
}