-- SQL sample for syntax highlighting
CREATE TABLE IF NOT EXISTS customers (
    id          BIGINT PRIMARY KEY,
    name        VARCHAR(120) NOT NULL,
    email       VARCHAR(255) UNIQUE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
    id           BIGINT PRIMARY KEY,
    customer_id  BIGINT NOT NULL REFERENCES customers (id),
    total_cents  INTEGER NOT NULL CHECK (total_cents >= 0),
    status       VARCHAR(20) NOT NULL DEFAULT 'pending',
    placed_at    TIMESTAMP NOT NULL
);

INSERT INTO customers (id, name, email)
VALUES
    (1, 'Acme Corp', 'billing@acme.test'),
    (2, 'Globex', NULL);

-- Top customers by lifetime spend in the last year
WITH recent_orders AS (
    SELECT
        customer_id,
        total_cents,
        placed_at
    FROM orders
    WHERE status <> 'cancelled'
      AND placed_at >= CURRENT_DATE - INTERVAL '1 year'
)
SELECT
    c.name,
    COUNT(o.customer_id)                       AS order_count,
    SUM(o.total_cents) / 100.0                 AS lifetime_value,
    RANK() OVER (ORDER BY SUM(o.total_cents) DESC) AS spend_rank
FROM customers AS c
LEFT JOIN recent_orders AS o ON o.customer_id = c.id
GROUP BY c.id, c.name
HAVING SUM(o.total_cents) > 10000
ORDER BY lifetime_value DESC
LIMIT 10;
