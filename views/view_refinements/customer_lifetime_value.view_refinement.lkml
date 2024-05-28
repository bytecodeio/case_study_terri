# Refinement view file for any additions to the customer_lifetime_value view
# which will be treated as the raw view file


include: "/views/derived/customer_lifetime_value.view"
include: "/views/pop_base/method6_base.view.lkml"

view: +customer_lifetime_value {
  extends: [method6_base]

  ## DIMENSIONS ##
  dimension_group: pop_date_field {
    sql: ${first_order_dt_raw} ;;
  }

  dimension: days_from_last_order {
    type: number
    description: "Calculates the days from the last order made by a customer"
    sql: date_diff(current_date(), ${last_order_dt_date}, day) ;;
    label: "Days Since Last Order"
  }

  dimension: is_active {
    type: yesno
    description: "Identifies if a user has made an order within the last 90 days"
    sql: ${days_from_last_order} <= 90 ;;
  }

  dimension: is_repeat_customer {
    type: yesno
    description: "Identifies whether a customer is a repeat customer or not"
    sql: ${customer_lifetime_orders} > 1 ;;
  }

  dimension: order_tiers {
    type: tier
    description: "Lifetime order tiers"
    tiers: [1,2,3,6,10]
    sql: ${customer_lifetime_orders} ;;
    style: integer
    label: "Lifetime Order Tiers"
  }

  dimension: revenue_tiers {
    type: tier
    description: "Lifetime revenue tiers"
    tiers: [5,20,50,100,500,1000]
    sql: ${customer_lifetime_revenue} ;;
    style: integer
    label: "Lifetime Revenue Tiers"
  }

  ## MEASURES ##
  measure: average_days_since_last_order {
    type: average
    description: "Average number of days since customers have placed their last order"
    sql: ${days_from_last_order} ;;
    label: "Average Days Since Last Order"
  }

  measure: average_lifetime_orders {
    type: average
    description: "Average lifetime orders (across multiple users)"
    sql: ${customer_lifetime_orders} ;;
    label: "Average Lifetime Orders"
  }

  measure: average_lifetime_revenue {
    type: average
    description: "Average lifetime revenue (across multiple users)"
    sql: ${customer_lifetime_revenue} ;;
    value_format_name: usd_0
    label: "Average Lifetime Revenue"
  }

  measure: total_customers {
    type: count_distinct
    sql: ${user_id} ;;
    label: "Total Customers"
  }

  measure: total_lifetime_orders {
    type: sum
    description: "Total lifetime orders (across multiple users)"
    sql: ${customer_lifetime_orders} ;;
    label: "Total Lifetime Orders"
  }

  measure: total_lifetime_revenue {
    type: sum
    description: "Total lifetime revenue (across multiple users)"
    sql: ${customer_lifetime_revenue} ;;
    value_format_name: usd_0
    label: "Total Lifetime Revenue"
  }

}
