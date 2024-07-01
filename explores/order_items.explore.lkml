# Order Items explore with detailed order information

include: "/views/base/users.view"
include: "/views/base/products.view"
include: "/views/base/distribution_centers.view"
include: "/views/cross_view/order_inventory_items_cv.view"
include: "/views/cross_view/order_items_users_cv.view"
include: "/views/view_refinements/order_items.view_refinement.lkml"
include: "/views/view_refinements/inventory_items.view_refinement.lkml"
include: "/views/derived/order_sequence_ndt.view.lkml"


explore: order_items {
  label: "Order Items"
  description: "Provides detailed order information."

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
  # join: distribution_centers {
  #   type: left_outer
  #   sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
  #   relationship: many_to_one
  # }
  join: order_sequence {
    from: order_sequence_ndt
    type:left_outer
    sql_on: ${order_items.id} = ${order_sequence.id} ;;
    relationship: many_to_one
  }
  join: order_inventory_items_cv {
    relationship: one_to_one
    sql:  ;;
  }
  join: order_items_users_cv {
    relationship: one_to_one
    sql:  ;;
  }
}
