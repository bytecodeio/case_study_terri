# Refinement view file for any additions to the order_items view
# which will be treated as the raw view file


include: "/views/base/order_items.view"
include: "/views/pop_base/method7_base.view.lkml"

view: +order_items {
  extends: [method7_base]

  ## DIMENSIONS ##
  dimension_group: pop_date_field {
    sql: ${created_raw} ;;
  }
  dimension: product_id {
    hidden: yes
  }

  ## MEASURES ##
  measure: average_sale_price {
    description: "Average sale price of items sold"
      type: average
      sql: ${sale_price} ;;
      value_format_name: usd_0
      label: "Average Sale Price"
  }
  measure: cumulative_total_sales {
    description: "Running total of total sales from items sold"
    type: running_total
    sql: ${total_sale_price} ;;
    value_format_name: usd_0
    label: "Cumulative Total Sales"
  }
  measure: count_items_returned {
    description: "Number of items returned"
    type: count_distinct
    sql: ${inventory_item_id} ;;
    filters: [status: "Returned"]
    label: "Number of Items Returned"
  }
  measure: count_customers_returning_items {
    description: "Number of customers who have returned an item"
    type: count_distinct
    sql: ${user_id} ;;
    filters: [status: "Returned"]
    label: "Number of Customers Returning Items"
  }
  measure: first_order_date {
    type: date
    hidden: yes
    sql: min(${created_date}) ;;
    convert_tz: no
    label: "First Order Date"
  }
  measure: last_order_date {
    type: date
    hidden: yes
    sql: max(${created_date}) ;;
    convert_tz: no
    label: "Last Order Date"
  }
  measure: total_sale_price {
    description: "Total sales from items sold"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd_0
    label: "Total Sale Price"
  }
  measure: total_gross_revenue {
    description: "Total revenue from completed sales (cancelled and returned orders excluded)"
    type: sum
    sql: ${sale_price} ;;
    filters: [status: "-Cancelled, -Returned"]
    value_format_name: usd_0
    link: {
      label: "Drill by Margin"
      url: "{% assign vis= '{\"x_axis_gridlines\":false,
            \"y_axis_gridlines\":true,
            \"show_view_names\":false,
            \"show_y_axis_labels\":true,
            \"show_y_axis_ticks\":true,
            \"y_axis_tick_density\":\"default\",
            \"y_axis_tick_density_custom\":5,
            \"show_x_axis_label\":true,
            \"show_x_axis_ticks\":true,
            \"y_axis_scale_mode\":\"linear\",
            \"x_axis_reversed\":false,
            \"y_axis_reversed\":false,
            \"plot_size_by_field\":false,
            \"trellis\":\"\",
            \"stacking\":\"\",
            \"limit_displayed_rows\":false,
            \"legend_position\":\"center\",
            \"point_style\":\"none\",
            \"show_value_labels\":true,
            \"label_density\":25,
            \"x_axis_scale\":\"auto\",
            \"y_axis_combined\":true,
            \"show_null_points\":true,
            \"interpolation\":\"linear\",
            \"x_axis_zoom\":true,
            \"y_axis_zoom\":true,
            \"series_types\":{},
            \"type\":\"looker_line\",
            \"defaults_version\":1,
            \"ordering\":\"none\",
            \"show_null_labels\":false,
            \"show_totals_labels\":false,
            \"show_silhouette\":false,
            \"totals_color\":\"#808080\"}' %}

            {{margin_drill_dummy._link}}&vis_config={{vis | encode_uri}}"
    }
  }
  measure: margin_drill_dummy {
    hidden: no
    type: number
    sql: 1 ;;
    drill_fields: [order_inventory_items_cv.gross_margin_percent,
order_items.created_month]
  }


}
