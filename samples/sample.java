// Java sample for syntax highlighting
package com.galewind.samples;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Aggregates order totals grouped by customer.
 */
public final class OrderReport {

    public enum Status {
        PENDING, SHIPPED, CANCELLED
    }

    public record Order(String customer, double total, Status status) {
        public boolean isBillable() {
            return status != Status.CANCELLED;
        }
    }

    private static final double TAX_RATE = 0.0825;

    public Map<String, Double> totalsByCustomer(List<Order> orders) {
        return orders.stream()
            .filter(Order::isBillable)
            .collect(Collectors.groupingBy(
                Order::customer,
                Collectors.summingDouble(order -> order.total() * (1 + TAX_RATE))));
    }

    public static void main(String[] args) {
        var report = new OrderReport();
        var orders = List.of(
            new Order("acme", 120.50, Status.SHIPPED),
            new Order("acme", 80.00, Status.PENDING),
            new Order("globex", 999.99, Status.CANCELLED));

        report.totalsByCustomer(orders).forEach((customer, total) ->
            System.out.printf("%-8s %,.2f%n", customer, total));
    }
}
