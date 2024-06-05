view: order_sequence_ndt {
  # If necessary, uncomment the line below to include explore_source.
# include: "order_items.explore.lkml"
    derived_table: {
      explore_source: order_items {
        column: user_id {}
        column: id {}
        column: pop_date_field_date {}
        column: order_sequence {}
        bind_all_filters: yes
      }
    }
    dimension: user_id {
      type: number
      description: "Unique user ID associated with an order"
      sql: ${TABLE}.user_id ;;
    }
    dimension: id {
      primary_key: yes
      # hidden: yes
      type: number
      description: "Unique order item ID associated with a customer"
      sql: ${TABLE}.id ;;
    }
    dimension: created {
      label: "Created"
      description: "Order Created Date"
      type: date
      sql: ${TABLE}.pop_date_field_date ;;
    }
    dimension: order_sequence {
      label: "Order Sequence"
      description: "Order sequence by user"
      type: number
      sql: ${TABLE}.order_sequence ;;
    }
  }
