variable "repository"{
    default = "ecr-repo-1"
    type = string
}

variable "ecs_cluster_name"{
    default = "my-fargate-cluster"
    type = string
}

variable "ecs_task_family"{
    default = "my-fargate-task"
}

variable "ecs_task_cpu"{
    default = "256"
}

variable "ecs_task_memory"{
    default = "512"
}

variable "image_tag"{
    
}