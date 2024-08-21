view: order_sequence_ndt {
  # If necessary, uncomment the line below to include explore_source.
# include: "order_items.explore.lkml"
    derived_table: {
      explore_source: order_items {
        column: user_id {}
        column: order_id {}
        column: id {}
        column: created {
          field: order_items.pop_date_field_date
        }
        column: delivered {
          field: order_items.delivered_date
        }
        column: status {}
        derived_column: order_sequence {
          sql: DENSE_RANK() OVER(PARTITION BY user_id ORDER BY order_id) ;;
        }
        derived_column: next_order_date {
          sql: LEAD(created,1) OVER(PARTITION BY user_id ORDER BY created) ;;
        }
        derived_column: items_per_order {
          sql: COUNT(id) OVER(PARTITION BY order_id) ;;
        }
        # bind_all_filters: yes
      }
    }
    # extends: [method2_base]

  ## DIMENSIONS ##
  # dimension_group: pop_date_field {
  #   sql: ${first_order_date_raw} ;;
  # }
    dimension: user_id {
      type: number
      description: "Unique user ID associated with an order"
      sql: ${TABLE}.user_id ;;
    }
    dimension: id {
      primary_key: yes
      hidden: yes
      type: number
      description: "Unique item ID associated with an order"
      sql: ${TABLE}.id ;;
    }
    dimension: order_id {
      type: number
      description: "Unique order ID of an order"
      sql: ${TABLE}.order_id ;;
    }
    dimension_group: created {
      label: "Created"
      description: "Order Created Date"
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        month_name,
        month_num,
        quarter,
        year]
      sql: ${TABLE}.created ;;
    }
    dimension: delivered {
      label: "Delivered"
      description: "Order Created Date"
      type: date
      sql: ${TABLE}.delivered ;;
    }
    dimension: days_between_orders {
      label: "Days Between Orders"
      description: "Number of days between orders"
      type: number
      sql: DATE_DIFF(${next_order_date},${created_date},day);;
    }
    dimension: days_to_deliver {
      label: "Days to Deliver"
      description: "Number of days to deliver an order"
      type: number
      sql: DATE_DIFF(${delivered},${created_date},day) ;;
    }
  dimension: dynamic_created_date {
    type: string
    label_from_parameter: date_granularity
    sql:
      {% if date_granularity._parameter_value == 'day' %}
        ${created_date}
      {% elsif date_granularity._parameter_value == 'week' %}
        ${created_week}
      {% elsif date_granularity._parameter_value == 'month' %}
        ${created_month}
      {% elsif date_granularity._parameter_value == 'quarter' %}
        ${created_quarter}
      {% elsif date_granularity._parameter_value == 'quarter' %}
        ${created_year}
      {% else %}
        ${created_date}
      {% endif %};;
  }
    dimension: has_subsequent_order {
      label: "Has Subsequent Order (Yes/No)"
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
      label: "First Purchase"
      description: "Indicator for whether a purchase is a customer’s first purchase or not"
      type: yesno
      sql: ${order_sequence} = 1 ;;
    }
    dimension: is_one_time_purchase {
      label: "One Time Purchase"
      description: "Indicator for whether a purchase is a one time purchase or not"
      type: yesno
      sql: ${order_sequence} = 1 and ${next_order_date} is null ;;
    }
    dimension: items_per_order {
      label: "Number of Items per Order"
      description: "Indicator for whether a purchase is a one time purchase or not"
      type: number
      sql: ${TABLE}.items_per_order ;;
    }
    dimension: next_order_date {
      label: "Next Order Date"
      description: "Date of the next order by user"
      type: date
      sql: ${TABLE}.next_order_date ;;
    }
    dimension: order_sequence {
      label: "Order Sequence"
      description: "Order sequence by user"
      type: number
      sql: ${TABLE}.order_sequence ;;
    }
    dimension: status {
      label: "Order Status"
      description: "Order status"
      type: string
      sql: ${TABLE}.status ;;
    }

  ## MEASURES ##

  measure: 60_day_repeat_purchase_rate {
    type: number
    sql: ${total_60_day_repeat_customers}/${total_customers} ;;
    value_format_name: percent_1
  }

  measure: average_days_between_orders {
    label: "Average Days Between Orders"
    description: "Average number of days between orders"
    type: average
    sql: ${days_between_orders} ;;
    value_format: "#.0"
  }

  measure: average_days_to_deliver {
    label: "Average Days to Deliver"
    description: "Average number of days from when an order is made to when it is delivered"
    type: average
    sql: ${days_to_deliver} ;;
    value_format: "#.0"
  }

  measure: average_items_per_order {
    label: "Average Number of Items per Order"
    description: "Average number of items ordered by customer by order"
    type: average
    sql: ${items_per_order} ;;
    value_format: "#.0"
  }

  measure: percent_canceled_returned {
    label: "Percent Canceled or Returned"
    description: "Percent of orders that were canceled or returned"
    type: number
    sql: ${total_canceled_returned} / ${total_orders} ;;
    value_format_name: "percent_1"
  }

  measure: total_customers {
    type: count_distinct
    sql: ${user_id} ;;
    label: "Total Customers"
  }

  measure: total_orders {
    type: count_distinct
    sql: ${TABLE}.order_id ;;
    label: "Total Orders"
  }

  measure: total_canceled_returned {
    type: count_distinct
    sql: ${TABLE}.order_id ;;
    filters: [status: "Returned, Canceled"]
  }

  measure: total_60_day_repeat_customers {
    label: "Total 60 Day Repeat Customers"
    description: "The number of customers that have purchased from the website again within 60 days of a prior purchase"
    type: count_distinct
    filters: [days_between_orders: "<=60"]
    sql: ${user_id} ;;
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
  }
