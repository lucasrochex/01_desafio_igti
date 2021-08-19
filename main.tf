resource "aws_s3_bucket" "datalake"{
    # Parâmetros de configuração dos recursos
    bucket = "${var.base_bucket_name}-${var.ambiente}-${var.numero_conta}"
    acl = "private"
    server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "AES256"
      }
    }
  }
  tags = {
      IES = "IGTI"
      CURSO = "EDC"
  }
}

resource "aws_s3_bucket_object" "código_spark"{
    bucket = aws_s3_bucket.datalake.id   
    key= "emr-code/pyspark/job_spark_from_tf.py"
    acl = "private"
    source = "job_spark.py"
    etag = filemd5("../job_spark.py")
}

provider "aws"{
    region = "us_east_2"
}


terraform {
  backend "s3"  {
    bucket = "terraform-state-keeper-lucas"
    key = "state/igti/edc/mod1/terraform.tfstate"
    region = "us-east-2"
  }