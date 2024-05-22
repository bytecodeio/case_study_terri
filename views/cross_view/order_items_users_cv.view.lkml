# Cross view for shared Order Items and User measures
view: order_items_users_cv {
  view_label: "Order Items"

  ## MEASURES ##
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
    drill_fields: [users.gender, users.age_tiers, average_spend_per_customer]
    link: {
      label: "Avg Spend per Customer Drill"
      url:"{{ link }}&f[users.age]=%3E%3D15&sorts=users.gender+desc"
    }
    label: "Average Spend per Customer"
  }
}
