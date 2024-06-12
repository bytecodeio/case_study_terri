# Refinement view file for any additions to the order_items view
# which will be treated as the raw view file


include: "/views/base/order_items.view"
include: "/views/pop_base/method7_base.view.lkml"

view: +order_items {
  extends: [method7_base]

  ## DIMENSIONS ##
  dimension_group: pop_date_field {
    sql: ${created_raw} ;;
  }
  dimension: product_id {
    hidden: yes
  }

  ## MEASURES ##
  measure: average_sale_price {
    description: "Average sale price of items sold"
      type: average
      sql: ${sale_price} ;;
      value_format_name: usd_0
      label: "Average Sale Price"
  }
  measure: cumulative_total_sales {
    description: "Running total of total sales from items sold"
    type: running_total
    sql: ${total_sale_price} ;;
    value_format_name: usd_0
    label: "Cumulative Total Sales"
  }
  measure: count_items_returned {
    description: "Number of items returned"
    type: count_distinct
    sql: ${inventory_item_id} ;;
    filters: [status: "Returned"]
    label: "Number of Items Returned"
  }
  measure: count_customers_returning_items {
    description: "Number of customers who have returned an item"
    type: count_distinct
    sql: ${user_id} ;;
    filters: [status: "Returned"]
    label: "Number of Customers Returning Items"
  }
  measure: first_order_date {
    type: date
    hidden: yes
    sql: min(${created_date}) ;;
    convert_tz: no
    label: "First Order Date"
  }
  measure: last_order_date {
    type: date
    hidden: yes
    sql: max(${created_date}) ;;
    convert_tz: no
    label: "Last Order Date"
  }
  measure: total_sale_price {
    description: "Total sales from items sold"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd_0
    label: "Total Sale Price"
  }
  measure: total_gross_revenue {
    description: "Total revenue from completed sales (cancelled and returned orders excluded)"
    type: sum
    sql: ${sale_price} ;;
    filters: [status: "-Cancelled, -Returned"]
    value_format_name: usd_0
  }


}
