view: order_items_test {
  sql_table_name: `thelook.order_items_test` ;;

  ## DIMENSIONS ##
  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  ## MEASURES ##
  measure: count {
    type: count
  }
}
