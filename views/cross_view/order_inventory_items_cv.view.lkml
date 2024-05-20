view: order_inventory_items_cv {

  ## DIMENSIONS ##


  ## MEASURES ##
  measure: total_gross_margin_amount {
    description: "Total profit margin amount (difference between Total Gross Revenue and Cost of Goods Sold)"
    type: number
    sql: ${order_items.total_gross_revenue} - ${inventory_items.cost} ;;
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
  view_label: "Order Items"
}
