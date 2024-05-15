connection: "looker_partner_demo"

# include all the views
include: "/views/**/*.view.lkml"

datagroup: case_study_terri_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: case_study_terri_default_datagroup

explore: users {
  label: "Customers"

  join: events {
    type: left_outer
    sql_on: ${users.id} = ${events.id} ;;
    relationship: one_to_many
  }
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }
  join: order_items_users_cv {
    relationship: one_to_one
    sql:  ;;
}
}

explore: order_items {
  label: "Order Items"

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }
  join: products {
    type: left_outer
    sql_on: ${order_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
  join: order_inventory_items_cv {
    relationship: many_to_one
    sql:  ;;
  }
  join: order_items_users_cv {
    relationship: one_to_one
    sql:  ;;
  }
}
