view: order_inventory_items_cv {

  ## DIMENSIONS ##
  dimension: gross_margin_amount {
    description: "Total margin amount"
    type: number
    sql: ${order_items.sale_price} - ${inventory_items.cost} ;;
    value_format_name: usd
    label: "Gross Margin Amount"
  }

  ## MEASURES ##
  measure: average_gross_margin {
    description: "Average gross margin amount"
    type: average
    sql: ${gross_margin_amount} ;;
    value_format_name: usd
  }
  measure: gross_margin_percent {
    description: "Total Gross Margin Amount / Total Gross Revenue"
    type:  number
    sql: ${total_gross_margin_amount} / ${order_items.total_gross_revenue} ;;
    value_format_name: percent_2
    label: "Gross Margin %"
  }
  measure: total_gross_margin_amount {
    description: "Total gross margin amount"
    type: sum
    sql: ${gross_margin_amount};;
    value_format_name: usd
  }
  view_label: "Order Items"
}
