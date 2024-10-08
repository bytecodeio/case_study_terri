view: order_items {
  sql_table_name: `thelook.order_items` ;;
  drill_fields: [id]

  ## DIMENSIONS ##
  dimension: id {
    primary_key: yes
    # hidden: yes
    type: number
    sql: ${TABLE}.id ;;
    label: "ID"
  }
  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      day_of_week_index,
      day_of_year,
      week,
      month,
      month_name,
      month_num,
      day_of_month,
      quarter,
      year]
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

  measure: total_orders {
    type: count_distinct
    sql: ${order_id} ;;
    label: "Total Orders"
  }

## PARAMETERS ##
  parameter: date_granularity {
    type: unquoted
    allowed_value: {
      label: "By Day"
      value: "day"
    }
    allowed_value: {
      label: "By Week"
      value: "week"
    }
    allowed_value: {
      label: "By Month"
      value: "month"
    }
    allowed_value: {
      label: "By Quarter"
      value: "quarter"
    }
    allowed_value: {
      label: "By Year"
      value: "year"
    }
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
