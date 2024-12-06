resource "fivetran_connector" "connector" {
    group_id = ""
    service        = "sql_server"
    run_setup_tests = true
    destination_schema {
        prefix=""
        
    }

 
    config {
       
       host = ""
       port = ""
       user = ""
       password = ""
       database = ""
       connection_type = "PrivateLink"
       update_method = "TELEPORT" 
         
    }

  trust_certificates = true

    timeouts {
        create = "60m"
        update = "60m"
    }
}

resource "fivetran_connector_schema_config" "schema" {
  connector_id = fivetran_connector.connector.id
  schema_change_handling = "ALLOW_COLUMNS"
  schemas = {
    # Schema: 
    "schemaname" = {tables = {
        "tablename" = {enabled = true}
    }
    }
}
}
resource "fivetran_connector_schedule" "schedule" {
    connector_id = fivetran_connector.connector.id
    sync_frequency     = "1440"
    daily_sync_time    = "03:00"
    paused             = true
    pause_after_trial  = true
    schedule_type      = "auto"
}


