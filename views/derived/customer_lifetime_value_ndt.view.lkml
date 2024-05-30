view: customer_lifetime_value_ndt {
  view_label: "Customer Lifetime Value"
# If necessary, uncomment the line below to include explore_source.
# include: "order_items.explore.lkml"

    derived_table: {
      explore_source: order_items {
        column: first_order_date {}
        column: last_order_date {}
        column: user_id {}
        column: total_orders {}
        column: total_sale_price {}
        bind_all_filters: yes
        # filters: [order_items.status: "-Cancelled, -Returned"]
      }
    }

    ## DIMENSIONS ##
  dimension: customer_lifetime_orders {
    type: number
    description: "The total number of orders by customer"
    sql: ${TABLE}.total_orders ;;
    label: "Customer Lifetime Orders"
  }
  dimension: customer_lifetime_revenue {
    type: number
    description: "The total revenue by customer"
    sql: ${TABLE}.total_sale_price ;;
    label: "Customer Lifetime Revenue"
  }
  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: number
    description: "Unique user ID associated with an order"
    sql: ${TABLE}.user_id ;;
  }
  dimension_group: first_order_date {
    type: time
    description: "The first order date for a customer"
    timeframes: [raw,
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
    convert_tz: no
    sql: ${TABLE}.first_order_date ;;
    label: "First Order"
  }
  dimension_group: last_order_date {
    type: time
    description: "The latest order date of a customer"
    timeframes: [raw,
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
    convert_tz: no
    sql: ${TABLE}.last_order_date;;
    label: "Last Order"
  }
  }
