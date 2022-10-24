
/******************************************
12b. BigQuery dataset creation
******************************************/

resource "google_bigquery_dataset" "bq_dataset_creation" {
  dataset_id                  = local.bq_datamart_ds
  location                    = local.location_multi
}

resource "null_resource" "import_csv_to_bq" {
  provisioner "local-exec" {
    command = <<-EOT
    bq load --source_format=CSV --allow_quoted_newlines=true --field_delimiter='|' ${local.bq_datamart_ds}.${local.bq_datamart_sample_table} ../01-datasets/${local.bq_datamart_sample_table}.csv Geography:string
  EOT
  }

  depends_on = [google_bigquery_dataset.bq_dataset_creation]
}
