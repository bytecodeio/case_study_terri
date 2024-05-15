view: order_items_users_cv {
  measure: users_with_returns_percent {
    description: "% of users with returns"
    type: number
    sql: 1.0 * ${order_items.count_customers_returning_items}
      / NULLIF(${users.count},0);;
    value_format_name: percent_2
    label: "% of Users with Returns"
  }
  measure: average_spend_per_customer {
    description: "Average spend per customer"
    type: number
    sql: ${order_items.total_sale_price} / ${users.count} ;;
    value_format_name: usd_0
    label: "Average Spend per Customer"
  }
  view_label: "Order Items"
}
