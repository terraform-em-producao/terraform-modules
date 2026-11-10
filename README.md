# terraform-modules

Monorepo com os módulos da org. Cada módulo tem **versão própria**, numa tag `<modulo>/vX.Y.Z`.

| Módulo | Versão | Para quê |
|---|---|---|
| [`s3-bucket-seguro`](modules/s3-bucket-seguro) | `v1.0.0` | Bucket S3 com os padrões da org |

## Usando

```hcl
module "dados" {
  source = "git::https://github.com/terraform-em-producao/terraform-modules.git//modules/s3-bucket-seguro?ref=s3-bucket-seguro/v1.0.0"
  nome   = "tep-dev-dados"
}
```

Sempre com `?ref=` numa tag. Sem `ref`, cada `terraform init` pode trazer um código diferente.

## Quando criar um módulo aqui

Quando ele carrega uma **decisão da org** (padrão de nome, criptografia, tags, o que é proibido).
Para coisas genéricas (VPC, EKS, RDS), use o módulo oficial `terraform-aws-modules/*` pinado.

## Regras do repo

- Módulo declara `required_version`/`required_providers` com **mínimo** (`>=`); quem pina exato é a raiz.
- Módulo não tem `provider {}` nem `backend {}`.
- Todo módulo tem `tests/*.tftest.hcl` com `mock_provider` — roda no CI sem credencial.
- Mudança que quebra quem usa = versão major.

## Lançando uma versão

1. PR com a mudança e uma entrada `## <modulo>/vX.Y.Z` no `CHANGELOG.md`.
2. Merge.
3. *Actions → release → Run workflow* com o módulo e a versão.
