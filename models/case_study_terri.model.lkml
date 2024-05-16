connection: "looker_partner_demo"

# include all the views
# include: "/views/**/*.view.lkml"

include: "/explores/order_items.explore"
include: "/explores/customers.explore"

datagroup: case_study_terri_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: case_study_terri_default_datagroup
