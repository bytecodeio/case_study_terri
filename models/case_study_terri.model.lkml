connection: "looker_partner_demo"

include: "/explores/order_items.explore"
include: "/explores/customers.explore"

# datagroup: case_study_terri_default_datagroup {
#   # sql_trigger: SELECT MAX(id) FROM etl_log;;
#   max_cache_age: "1 hour"
# }

datagroup: test_schedule_datagroup {
  sql_trigger:
    SELECT
      CASE
        WHEN CURRENT_DATE <= DATE('2025-06-18') THEN CURRENT_DATE
        ELSE NULL
      END ;;
  max_cache_age: "24 hours"
}

# persist_with: test_schedule_datagroup

access_grant: sales_access {
  user_attribute: case_study_department
  allowed_values: ["sales","executive"]
}
