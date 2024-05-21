view: order_inventory_items_cv {
  view_label: "Order Items"

  ## DIMENSIONS ##


  ## MEASURES ##
  # measure: current_period_total_gross_margin {
  #   description: "Current period total profit margin amount (difference between Total Gross Revenue and Cost of Goods Sold)"
  #   type: sum
  #   sql: ${order_items.total_gross_revenue} - ${inventory_items.total_cost} ;;
  #   drill_fields: [products.category, products.brand, total_gross_margin_amount]
  #   filters: [order_items.period_selected: "Second Period"]
  #   value_format_name: usd
  #   label: "Total Gross Revenue (Current Period)"
  # }
  # measure: previous_period_total_gross_margin {
  #   description: "Previous period total profit margin amount (difference between Total Gross Revenue and Cost of Goods Sold)"
  #   type: number
  #   sql: ${total_gross_margin_amount} ;;
  #   drill_fields: [products.category, products.brand, total_gross_margin_amount]
  #   filters: [order_items.period_selected: "First Period"]
  #   value_format_name: usd
  #   label: "Total Gross Revenue (Previous Period)"
  # }
  measure: total_gross_margin_amount {
    description: "Total profit margin amount (difference between Total Gross Revenue and Cost of Goods Sold)"
    type: number
    sql: ${order_items.total_gross_revenue} - ${inventory_items.total_cost} ;;
    drill_fields: [products.category, products.brand, total_gross_margin_amount]
    value_format_name: usd
    label: "Gross Margin Amount"
  }
  measure: gross_margin_percent {
    description: "Total Gross Margin Amount / Total Gross Revenue"
    type:  number
    sql: ${total_gross_margin_amount} / NULLIF(${order_items.total_gross_revenue},0) ;;
    value_format_name: percent_2
    label: "Gross Margin %"
  }
}
