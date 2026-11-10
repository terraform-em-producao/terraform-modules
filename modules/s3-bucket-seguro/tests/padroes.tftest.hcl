# Testes rodam com provider mockado: sem credencial, sem custo, em segundos.
mock_provider "aws" {
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{}"
    }
  }
}

variables {
  nome = "tep-dev-teste-modulo"
}

run "bloqueia_acesso_publico" {
  command = plan

  assert {
    condition = alltrue([
      aws_s3_bucket_public_access_block.this.block_public_acls,
      aws_s3_bucket_public_access_block.this.block_public_policy,
      aws_s3_bucket_public_access_block.this.ignore_public_acls,
      aws_s3_bucket_public_access_block.this.restrict_public_buckets,
    ])
    error_message = "Todo bucket precisa bloquear acesso público."
  }
}

run "usa_aes256_sem_kms" {
  command = plan

  assert {
    condition     = one(one(aws_s3_bucket_server_side_encryption_configuration.this.rule).apply_server_side_encryption_by_default).sse_algorithm == "AES256"
    error_message = "Sem KMS informado, o padrão deve ser AES256."
  }
}

run "usa_kms_quando_informado" {
  command = plan

  variables {
    kms_key_arn = "arn:aws:kms:us-east-1:111111111111:key/teste"
  }

  assert {
    condition     = one(one(aws_s3_bucket_server_side_encryption_configuration.this.rule).apply_server_side_encryption_by_default).sse_algorithm == "aws:kms"
    error_message = "Com KMS informado, o algoritmo deve ser aws:kms."
  }
}

run "sem_lifecycle_quando_sem_versionamento" {
  command = plan

  variables {
    versionamento = false
  }

  assert {
    condition     = length(aws_s3_bucket_lifecycle_configuration.this) == 0
    error_message = "Sem versionamento não faz sentido expirar versões antigas."
  }
}

run "rejeita_nome_fora_do_padrao" {
  command = plan

  variables {
    nome = "MeuBucket"
  }

  expect_failures = [var.nome]
}
