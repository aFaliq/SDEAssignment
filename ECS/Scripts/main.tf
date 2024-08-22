resource "aws_ecr_repository" "ecr_repo" {
  name                 = "ecr-repo-1" 
  image_tag_mutability = "MUTABLE"
  

  image_scanning_configuration {
    scan_on_push = true
  }
}