include: "/views/base/inventory_items.view"
include: "/views/pop_base/method6_base.view"

view: +inventory_items {
  extends: [method6_base]

  ## DIMENSIONS ##
  dimension_group: pop_date_field {
    sql: ${created_raw} ;;
  }
  dimension: id {
    hidden: yes
  }

## MEASURES ##
  measure: average_cost {
    description: "Average cost of items sold from inventory"
    type: average
    sql: ${cost} ;;
    value_format_name: usd
    label: "Average Cost"
  }
  measure: count {
    type: count
    drill_fields: [id, product_name, products.name, products.id, order_items.count]
    label: "Count"
  }
  measure: total_cost {
    description: "Total cost of items sold from inventory"
    type: sum
    sql: ${cost} ;;
    value_format_name: usd
    label: "Total Cost"
  }
}
