# Refinement view file for any additions to the customer_lifetime_value view
# which will be treated as the raw view file


include: "/views/derived/customer_lifetime_value_ndt_users.view"
# include: "/views/pop_base/method2_base.view.lkml"

view: +customer_lifetime_value_ndt_users {
  # extends: [method2_base]

  ## DIMENSIONS ##
  # dimension_group: pop_date_field {
  #   sql: ${first_order_date_raw} ;;
  # }

  dimension: days_from_last_order {
    type: number
    description: "Calculates the days from the last order made by a customer"
    sql: date_diff(current_date(), ${last_order_date_date}, day) ;;
    convert_tz: no
    label: "Days Since Last Order"
  }

  dimension: is_active_customer {
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
    description: "Lifetime number of orders grouped by tier"
    tiers: [1,2,3,6,10]
    sql: ${customer_lifetime_orders} ;;
    style: integer
    label: "Lifetime Order Tiers"
  }

  dimension: revenue_tiers {
    type: tier
    hidden: yes
    tiers: [5,20,50,100,500,1000]
    sql: ${customer_lifetime_revenue} ;;
    style: integer
  }

  dimension: revenue_tiers_clean {
    type: string
    description: "Lifetime revenue tiers"
    order_by_field: revenue_tiers_sort
    sql: case
            when ${revenue_tiers} = "Below 5" then "$0.00 - $4.99"
            when ${revenue_tiers} = "5 to 19" then "$5.00 - $19.99"
            when ${revenue_tiers} = "20 to 49" then "$20.00 - $49.99"
            when ${revenue_tiers} = "50 to 99" then "$50.00 - $99.99"
            when ${revenue_tiers} = "100 to 499" then "$100.00 - $499.99"
            when ${revenue_tiers} = "500 to 999" then "$500.00 - $999.99"
        else "$1000.00 +" end;;
    label: "Lifetime Revenue Tiers"
  }

  dimension: revenue_tiers_sort {
    type: number
    hidden: yes
    sql: case
            when ${revenue_tiers} = "Below 5" then 1
            when ${revenue_tiers} = "5 to 19" then 2
            when ${revenue_tiers} = "20 to 49" then 3
            when ${revenue_tiers} = "50 to 99" then 4
            when ${revenue_tiers} = "100 to 499" then 5
            when ${revenue_tiers} = "500 to 999" then 6
            else 7
       end;;
  }

  ## MEASURES ##
  measure: active_customer_rate {
    type: number
    description: "Percent of users that have made an order within the last 90 days"
    sql: ${total_active_users} / NULLIF(${total_customers},0) ;;
    value_format_name: percent_1
    label: "Active Customer Percentage"
  }

  measure: average_days_since_last_order {
    type: average
    description: "Average number of days since customers have placed their last order"
    sql: ${days_from_last_order} ;;
    label: "Average Days Since Last Order"
  }

  measure: average_lifetime_orders {
    type: average
    description: "Average lifetime orders (across customers)"
    sql: ${customer_lifetime_orders} ;;
    label: "Average Lifetime Orders"
  }

  measure: average_lifetime_revenue {
    type: average
    description: "Average lifetime revenue (across customers)"
    sql: ${customer_lifetime_revenue} ;;
    value_format_name: usd_0
    label: "Average Lifetime Revenue"
  }

  measure: repeat_purchase_rate {
    type: number
    description: "Percent of users that have made more than 1 order"
    sql: ${total_repeat_users} / NULLIF(${total_customers},0) ;;
    value_format_name: percent_1
    label: "Repeat Customer Percentage"
  }

  measure: total_active_users {
    type: count_distinct
    description: "Total # of active customers that purchased an item within the last 90 days"
    sql: ${id} ;;
    filters: [is_active_customer: "yes"]
    label: "Total Active Customers"
  }

  measure: total_customers {
    type: count_distinct
    sql: ${id} ;;
    label: "Total Customers"
  }

  measure: total_lifetime_orders {
    type: sum
    description: "Total lifetime orders (across customers)"
    sql: ${customer_lifetime_orders} ;;
    label: "Total Lifetime Orders"
  }

  measure: total_lifetime_revenue {
    type: sum
    description: "Total lifetime revenue (across customers)"
    sql: ${customer_lifetime_revenue} ;;
    value_format_name: usd_0
    label: "Total Lifetime Revenue"
  }

  measure: total_repeat_users {
    type: count_distinct
    description: "Total # of repeat customers"
    sql: ${id} ;;
    filters: [is_repeat_customer: "yes"]
    label: "Total Repeat Customers"
  }

}
