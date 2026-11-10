terraform {
  # Módulo declara o mínimo que precisa; quem pina a versão exata é a raiz.
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}
