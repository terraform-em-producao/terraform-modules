variable "nome" {
  description = "Nome do bucket. Precisa começar com o prefixo do ambiente (tep-<ambiente>-)."
  type        = string

  validation {
    condition     = can(regex("^tep-(shared|dev|prod)-[a-z0-9-]{3,40}$", var.nome))
    error_message = "Use o padrão tep-<shared|dev|prod>-<nome>, minúsculo, até 40 caracteres no sufixo."
  }
}

variable "versionamento" {
  description = "Mantém versões antigas dos objetos."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "Chave KMS para criptografia. null usa SSE-S3 (AES256)."
  type        = string
  default     = null
}

variable "expirar_versoes_antigas_em_dias" {
  description = "Remove versões não-atuais depois de N dias. 0 desativa."
  type        = number
  default     = 90

  validation {
    condition     = var.expirar_versoes_antigas_em_dias >= 0
    error_message = "Precisa ser >= 0."
  }
}

variable "force_destroy" {
  description = "Permite apagar o bucket com objetos. Evite em produção."
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
