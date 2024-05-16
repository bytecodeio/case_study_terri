view: order_items {
  sql_table_name: `thelook.order_items` ;;
  drill_fields: [id]

  ## DIMENSIONS ##
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    label: "ID"
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
    label: "Created"
  }
  dimension_group: delivered {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.delivered_at ;;
    label: "Delivered"
  }
  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
    label: "Inventory Item ID"
  }
  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
    label: "Order ID"
  }
  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
    label: "Product ID"
  }
  dimension_group: returned {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.returned_at ;;
    label: "Returned"
  }
  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    label: "Sale Price"
  }
  dimension_group: shipped {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.shipped_at ;;
    label: "Shipped"
  }
  dimension: status {
    description: "Order status"
    type: string
    sql: ${TABLE}.status ;;
    label: "Order Status"
  }
  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
    label: "User ID"
  }

  # MEASURES ##
  measure: average_sale_price {
    description: "Average sale price of items sold"
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
    label: "Average Sales Price"
  }
  measure: cumulative_total_sales {
    description: "Running total of total sales from items sold"
    type: running_total
    sql: ${total_sale_price} ;;
    value_format_name: usd
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
    description: "Number of users who have returned an item"
    type: count_distinct
    sql: ${user_id} ;;
    filters: [status: "Returned"]
    label: "Number of Customers Returning Items"
  }
  measure: total_sale_price {
    description: "Total sales from items sold"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    label: "Total Sale Price"
  }
  measure: total_gross_revenue {
    description: "Total revenue from completed sales (cancelled and returned orders excluded)"
    type: sum
    sql: ${sale_price} ;;
    filters: [status: "-Cancelled, -Returned"]
    value_format_name: usd
    label: "Total Gross Revenue"
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  users.last_name,
  users.id,
  users.first_name,
  inventory_items.id,
  inventory_items.product_name,
  products.name,
  products.id
  ]
  }

}
