#Customers explore with user behavior and attributes

include: "/views/base/events.view"
include: "/views/cross_view/order_items_users_cv.view"
include: "/views/view_refinements/order_items.view_refinement.lkml"
include: "/views/base/products.view"
include: "/views/view_refinements/users.view_refinement.lkml"
include: "/views/derived/customer_lifetime_value_ndt_users.view"
include: "/views/view_refinements/customer_lifetime_value.view_refinement.lkml"

explore: users {
  # required_access_grants: [sales_access]
  access_filter: {
    field: country
    user_attribute: case_study_country
  }
  label: "Customers"
  description: "Provides user behavior and attribute details"

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
  join: products {
    type: left_outer
    sql_on: ${order_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
  join: customer_lifetime_value_ndt_users {
    type: left_outer
    sql_on: ${users.id} = ${customer_lifetime_value_ndt_users.id} ;;
    relationship: one_to_one
  }
  join: order_items_users_cv {
    relationship: one_to_one
    sql:  ;;
}
}
