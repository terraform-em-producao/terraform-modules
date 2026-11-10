# s3-bucket-seguro

Bucket S3 com os padrões da org: sem acesso público, `BucketOwnerEnforced`, criptografia (SSE-S3 ou KMS), só TLS, versionamento e expiração de versões antigas.

```hcl
module "logs" {
  source = "git::https://github.com/terraform-em-producao/terraform-modules.git//modules/s3-bucket-seguro?ref=s3-bucket-seguro/v1.0.0"

  nome = "tep-shared-logs"
}
```

## Entradas

| Nome | Tipo | Padrão | Descrição |
|---|---|---|---|
| `nome` | string | — | `tep-<shared\|dev\|prod>-<nome>` |
| `versionamento` | bool | `true` | Mantém versões antigas |
| `kms_key_arn` | string | `null` | KMS; `null` usa AES256 |
| `expirar_versoes_antigas_em_dias` | number | `90` | `0` desativa |
| `force_destroy` | bool | `false` | Apaga com objetos dentro |
| `tags` | map(string) | `{}` | |

## Saídas

`id`, `arn`, `regional_domain_name`

## Testes

```bash
terraform init && terraform test
```
