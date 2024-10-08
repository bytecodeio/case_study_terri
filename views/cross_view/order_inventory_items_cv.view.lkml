# Cross view for shared Order Items and Inventory Items measures
view: order_inventory_items_cv {
  view_label: "Order Items"


  ## MEASURES ##
  measure: total_gross_margin_amount {
    description: "Total profit margin amount (difference between Total Gross Revenue and Cost of Goods Sold)"
    type: number
    sql: ${order_items.total_gross_revenue} - ${inventory_items.total_cost} ;;
    drill_fields: [products.category, products.brand, total_gross_margin_amount]
    value_format_name: usd_0
    label: "Gross Margin Amount"
  }
  measure: gross_margin_percent {
    description: "Total Gross Margin Amount / Total Gross Revenue"
    type:  number
    sql: ${total_gross_margin_amount} / NULLIF(${order_items.total_gross_revenue},0) ;;
    value_format_name: percent_1
    label: "Gross Margin %"
  }
  measure: gross_margin_percent_w_custom_tooltip {
    description: "Total Gross Margin Amount / Total Gross Revenue"
    # hidden: yes
    type:  number
    sql: ${gross_margin_percent} ;;
    value_format_name: percent_1
    html: {{rendered_value }}
      <h6> Gross Margin Amount:</h6>
      <h6>{{ total_gross_margin_amount._rendered_value }}</h6>;;
    label: "Gross Margin %"
  }
}
