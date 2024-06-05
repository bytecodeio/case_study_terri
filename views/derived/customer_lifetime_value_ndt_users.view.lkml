# include: "customers.explore.lkml"
view: customer_lifetime_value_ndt_users {
  view_label: "Customer Lifetime Value"
# If necessary, uncomment the line below to include explore_source.

    derived_table: {
      explore_source: users {
        column: id { field: users.id }
        column: first_order_date { field: order_items.first_order_date }
        column: last_order_date { field: order_items.last_order_date }
        column: total_orders { field: order_items.total_orders }
        column: total_sale_price { field: order_items.total_sale_price }
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
      description: "The total revenue (excluding cancelled and Returned orders) by customer"
      sql: ${TABLE}.total_sale_price ;;
      label: "Customer Lifetime Revenue"
    }
    dimension: id {
      primary_key: yes
      hidden: yes
      type: number
      description: "Unique user ID associated with an order"
      sql: ${TABLE}.id ;;

    }
    dimension_group: first_order_date {
      type: time
      description: "The first order date for a customer"
      timeframes: [raw, time, date, week, month, quarter, year]
      convert_tz: no
      sql: ${TABLE}.first_order_date ;;
      label: "First Order"

    }
    dimension_group: last_order_date {
      type: time
      description: "The latest order date of a customer"
      timeframes: [raw, time, date, week, month, quarter, year]
      convert_tz: no
      sql: ${TABLE}.last_order_date;;
      label: "Last Order"
    }
  }
