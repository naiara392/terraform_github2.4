# Configuración del proveedor de AWS
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test" # Credenciales ficticias para LocalStack
  secret_key                  = "test" # Credenciales ficticias para LocalStack
  s3_use_path_style           = true # Necesario para LocalStack con S3
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id = true
  endpoints {
    s3 = "http://localhost:4566" # Endpoint de S3 de LocalStack
    ec2  = "http://localhost:4566"
  }
}

# Definición de un recurso: Bucket S3
resource "aws_s3_bucket" "my_localstack_bucket" {
  bucket = "bucket-s3" # Nombre único para tu bucket
  acl    = "private" # Acceso privado por defecto
}

# Salida para confirmar el nombre del bucket
output "bucket_name" {
  value       = aws_s3_bucket.my_localstack_bucket.bucket
  description = "Nombre del bucket S3 creado en LocalStack"
}

# Definición de un recurso: Instancia EC2
resource "aws_instance" "my_localstack_instance" {
  # 'ami': Amazon Machine Image. Para LocalStack, el valor exacto de la AMI
  #        no es tan importante ya que no se ejecuta un sistema operativo real.
  #        Puedes usar una AMI de ejemplo.
  ami           = "ami-0abcdef1234567890" # Un ID de AMI de ejemplo (realmente no se descarga OS)
  # 'instance_type': El tipo de instancia EC2 (ej. t2.micro es un tipo pequeño y de bajo coste).
  instance_type = "t2.small"

  # 'tags': Etiquetas clave-valor para organizar tus recursos.
  tags = {
    Name        = "MiInstanciaLocalStack"
    Environment = "Development"
  }
}

# Salida para confirmar el ID de la instancia EC2
output "instance_id" {
  value       = aws_instance.my_localstack_instance.id
  description = "ID de la instancia EC2 creada en LocalStack"
}

# Llamada al módulo para crear un bucket S3 ( Nuevo para tarea 4)
module "mi_primer_bucket" {
  source = "./modules/mi-recurso" # Ruta al directorio de tu módulo

  bucket_name = "otro-bucket-desde-modulo-june-30" # Nombre único para tu bucket
  acl         = "private"
  environment = "development"
}
# Salida para confirmar el ID del bucket (ahora desde el módulo)
output "modulo_bucket_id" {
  description = "ID del bucket S3 creado a través del módulo."
  value       = module.mi_primer_bucket.bucket_id
}

# Salida para confirmar el ARN del bucket (ahora desde el módulo)
output "modulo_bucket_arn" {
  description = "ARN del bucket S3 creado a través del módulo."
  value       = module.mi_primer_bucket.bucket_arn
}