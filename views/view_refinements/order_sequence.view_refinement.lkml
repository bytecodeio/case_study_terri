# Refinement view file for any additions to the customer_lifetime_value view
# which will be treated as the raw view file


include: "/views/derived/order_sequence_ndt.view"
# include: "/views/pop_base/method2_base.view.lkml"

view: +order_sequence_ndt {
  # extends: [method2_base]

  ## DIMENSIONS ##
  # dimension_group: pop_date_field {
  #   sql: ${first_order_date_raw} ;;
  # }

  dimension: days_between_orders {
    label: "Days Between Orders"
    description: "Number of days between orders"
    type: number
    sql: DATE_DIFF(${next_order_date},${created},day);;
  }

  dimension: has_subsequent_order {
    label: "First Purchase (Yes/No)"
    description: "Indicator for whether or not a customer placed a subsequent order on the website"
    type: yesno
    sql: ${next_order_date} is not null;;
  }

  dimension: is_cancelled_returned {
    label: "Cancelled or Returned Order (Yes/No)"
    description: "Indicator for whether a purchase was cancelled or returned"
    type: yesno
    sql: ${status} IN ('Cancelled', 'Returned') ;;
  }

  dimension: is_first_purchase {
    label: "First Purchase (Yes/No)"
    description: "Indicator for whether a purchase is a customer’s first purchase or not"
    type: yesno
    sql: ${order_sequence} = 1 ;;
  }

  dimension: is_one_time_purchase {
    label: "One Time Purchase (Yes/No)"
    description: "Indicator for whether a purchase is a one time purchase or not"
    type: yesno
    sql: ${order_sequence} = 1 and ${next_order_date} is null ;;
  }

  ## MEASURES ##

  measure: 60_day_repeat_purchase_rate {
    type: number
    sql: ${total_60_day_repeat_customers}/${total_customers} ;;
    value_format_name: percent_2
  }

  measure: average_days_between_orders {
    label: "Average Days Between Orders"
    description: "Average number of days between orders"
    type: average
    sql: ${days_between_orders} ;;
  }

  measure: next_order_date{
    label: "Next Order Date"
    description: "Date of the next order by user"
    type: date
    sql: LEAD(${created},1) OVER(PARTITION BY ${user_id} ORDER BY ${created}) ;;
  }

  measure: total_customers {
    type: count_distinct
    sql: ${user_id} ;;
    label: "Total Customers"
  }

  measure: total_60_day_repeat_customers {
    label: "Total 60 Day Repeat Customers"
    description: "The percent of customers that have purchased from the website again within 60 days of a prior purchase"
    type: count_distinct
    filters: [days_between_orders: "<=60"]
    sql: ${user_id} ;;
  }



}