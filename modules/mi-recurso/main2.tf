# variables.tf (dentro del módulo)
# Define las variables de entrada para este módulo.
# Estas variables serán los parámetros que podrás pasar al módulo
# cuando lo uses desde tu main.tf principal.

variable "bucket_name" {
  description = "Nombre único para el bucket S3."
  type        = string
}

variable "acl" {
  description = "ACL (Access Control List) para el bucket S3."
  type        = string
  default     = "private" # Valor por defecto si no se especifica
}

variable "environment" {
  description = "Entorno al que pertenece el bucket (ej. dev, prod)."
  type        = string
  default     = "development"
}

# main.tf (dentro del módulo)
# Define el recurso aws_s3_bucket usando las variables de entrada.
resource "aws_s3_bucket" "this" { # 'this' es una convención común para el recurso principal del módulo
  bucket = var.bucket_name
  acl    = var.acl

  tags = {
    Environment = var.environment
    ManagedBy   = "TerraformModule"
  }
}

# outputs.tf (dentro del módulo)
# Define las salidas del módulo.
# Estas salidas son valores que el módulo puede "devolver"
# al módulo que lo llama (tu main.tf principal).

output "bucket_id" {
  description = "El ID del bucket S3."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "El ARN (Amazon Resource Name) del bucket S3."
  value       = aws_s3_bucket.this.arn
}