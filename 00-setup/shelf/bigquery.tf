resource "google_bigquery_dataset" "bq_dataset_creation" {
  dataset_id                  = local.bq_datamart_ds
  location                    = local.location
}

resource "null_resource" "create_and_load_bq_managed_table" {
  provisioner "local-exec" {
    command = <<-EOT
    bq load --source_format=CSV --allow_quoted_newlines=true --skip_leading_rows=1 --field_delimiter=','  ${local.bq_datamart_ds}.us_states_managed_table ../01-datasets/us_states.csv state_name:STRING,state_code:STRING
 EOT
}

  depends_on = [google_bigquery_dataset.bq_dataset_creation,
  google_storage_bucket_object.upload_data_to_gcs
  ]
}

 resource "google_bigquery_connection" "create_bq_external_connection" {
    connection_id = local.bq_connection
    project = var.project_id
    location = local.location
    cloud_resource {}
    depends_on = [google_bigquery_dataset.bq_dataset_creation]
} 

resource "google_project_iam_member" "bq_connection_gmsa_iam_role_grant" {
    project = var.project_id
    role = "roles/storage.objectViewer"
    member = format("serviceAccount:%s", google_bigquery_connection.create_bq_external_connection.cloud_resource[0].service_account_id)

    depends_on = [google_bigquery_connection.create_bq_external_connection]

}

resource "google_bigquery_table" "create_biglake_bq_table" {

    dataset_id  = google_bigquery_dataset.bq_dataset_creation.dataset_id
    table_id    = "icecream_sales_biglake_table"
    project     = var.project_id
    schema      = <<EOF
    [
            {
                "name": "country",
                "type": "STRING"
            },
            {
                "name": "month",
                "type": "DATE"
                },
            {
                "name": "Gross_Revenue",
                "type": "FLOAT"
            },
            {
                "name": "Discount",
                "type": "FLOAT"
            },
            {
                "name": "Net_Revenue",
                "type": "FLOAT"
            }
    ]
    EOF
    external_data_configuration {
        autodetect = false
        source_format = "CSV"
        connection_id = google_bigquery_connection.create_bq_external_connection.name

        csv_options {
            quote                 = "\""
            field_delimiter       = ","
            allow_quoted_newlines = "false"
            allow_jagged_rows     = "false"
            skip_leading_rows     = 1
        }

        source_uris = [
            "gs://${local.data_bucket}/ice_cream_sales.csv"
        ]
    }
    deletion_protection = false
    depends_on = [
       google_bigquery_dataset.bq_dataset_creation,
       google_storage_bucket_object.upload_data_to_gcs,
       google_bigquery_connection.create_bq_external_connection,
       google_project_iam_member.bq_connection_gmsa_iam_role_grant
    ]
}


resource "time_sleep" "sleep_after_bq_objects_creation" {
  create_duration = "60s"
  depends_on = [
    null_resource.create_and_load_bq_managed_table,
    google_bigquery_table.create_biglake_bq_table,
    google_project_iam_member.bq_connection_gmsa_iam_role_grant

  ]
}
