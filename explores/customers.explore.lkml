include: "/views/base/users.view"
include: "/views/base/events.view"
include: "/views/base/order_items.view"
include: "/views/base/inventory_items.view"
include: "/views/cross_view/order_items_users_cv.view"
include: "/views/view_refinements/order_items.view_refinement.lkml"

explore: users {
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
  join: order_items_users_cv {
    relationship: one_to_one
    sql:  ;;
}
}
