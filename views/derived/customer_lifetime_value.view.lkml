# # Derived table for aggregated lifetime value data at the user level
# view: customer_lifetime_value {
#   derived_table: {
#     sql: select
#         user_id
#         ,min(created_at) as first_order_dt
#         ,max(created_at) as last_order_dt
#         ,count(distinct order_id) as customer_lifetime_orders
#         ,sum(sale_price) as customer_lifetime_revenue
#       from `looker-partners.thelook.order_items`
#       where status not in ('Cancelled', 'Returned')
#       group by 1 ;;
#   }

#   ## DIMENSIONS ##

#   dimension: customer_lifetime_orders {
#     type: number
#     description: "The total number of orders by customer"
#     sql: ${TABLE}.customer_lifetime_orders ;;
#     label: "Customer Lifetime Orders"
#   }

#   dimension: customer_lifetime_revenue {
#     type: number
#     description: "The total revenue (excluding cancelled and Returned orders) by customer"
#     sql: ${TABLE}.customer_lifetime_revenue ;;
#     label: "Customer Lifetime Revenue"
#   }

#   dimension_group: first_order_dt {
#     type: time
#     description: "The first order date of a customer"
#     timeframes: [raw, time, date, week, month, quarter, year]
#     sql: ${TABLE}.first_order_dt ;;
#     label: "First Order"
#   }

#   dimension_group: last_order_dt {
#     type: time
#     description: "The latest order date of a customer"
#     timeframes: [raw, time, date, week, month, quarter, year]
#     sql: ${TABLE}.last_order_dt ;;
#     label: "Last Order"
#   }

#   dimension: user_id {
#     primary_key: yes
#     type: number
#     description: "Unique user ID associated with an order"
#     sql: ${TABLE}.user_id ;;
#     label: "User ID"
#   }

# }
