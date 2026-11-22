-- 1. Suppliers Table
CREATE TABLE suppliers (
    supplier_id VARCHAR(50) PRIMARY KEY,
    supplier_name VARCHAR(150) NOT NULL,
    contact_person VARCHAR(100),
    city VARCHAR(100),
    region VARCHAR(100),
    email VARCHAR(150),
    supplier_category VARCHAR(100),
    payment_terms VARCHAR(50),
    average_lead_time INT,
    supplier_rating NUMERIC(3,2),
    supplier_status VARCHAR(50)
);

-- 2. Warehouses Table
CREATE TABLE warehouses (
    warehouse_id VARCHAR(50) PRIMARY KEY,
    warehouse_name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    region VARCHAR(100),
    warehouse_manager VARCHAR(100),
    storage_capacity VARCHAR(50),      
    warehouse_type VARCHAR(100),
    operating_cost VARCHAR(50),        
    warehouse_status VARCHAR(50)
);

-- 3. Products Table
DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    category VARCHAR(100) NOT NULL,
    sub_category VARCHAR(100),
    brand VARCHAR(100),
    unit_cost NUMERIC(12,2) NOT NULL,
    selling_price NUMERIC(12,2) NOT NULL,
    reorder_level INT,
    safety_stock NUMERIC(10,2),
    lead_time_days INT,
    supplier_id VARCHAR(50),
    CONSTRAINT fk_products_supplier FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
-- 4. Purchase Orders Table
CREATE TABLE IF NOT EXISTS public.purchase_orders (
    purchase_order_id VARCHAR(50) PRIMARY KEY,
    order_date VARCHAR(50),
    supplier_id VARCHAR(50),
    product_id VARCHAR(50),
    warehouse_id VARCHAR(50),
    quantity_ordered INT,
    unit_cost NUMERIC(12,2),
    total_purchase_cost NUMERIC(12,2),
    expected_delivery_date VARCHAR(50),
    actual_delivery_date VARCHAR(50),
    purchase_status VARCHAR(50),
    payment_status VARCHAR(50),
    CONSTRAINT fk_po_supplier FOREIGN KEY (supplier_id) REFERENCES public.suppliers(supplier_id),
    CONSTRAINT fk_po_product FOREIGN KEY (product_id) REFERENCES public.products(product_id),
    CONSTRAINT fk_po_warehouse FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(warehouse_id)
);
-- DROP TABLE IF EXISTS purchase_orders CASCADE;

-- CREATE TABLE stg_purchase_orders (
--     purchase_order_id VARCHAR(50),
--     order_date VARCHAR(50),
--     supplier_id VARCHAR(50),
--     product_id VARCHAR(50),
--     warehouse_id VARCHAR(50),
--     quantity_ordered INT,
--     unit_cost NUMERIC(12,2),
--     total_purchase_cost NUMERIC(12,2),
--     expected_delivery_date VARCHAR(50),
--     actual_delivery_date VARCHAR(50),
--     purchase_status VARCHAR(50),
--     payment_status VARCHAR(50)
-- );
-- SELECT *
-- FROM stg_purchase_orders s
-- WHERE NOT EXISTS (SELECT 1 FROM products p WHERE p.product_id = s.product_id)
--    OR NOT EXISTS (SELECT 1 FROM suppliers sup WHERE sup.supplier_id = s.supplier_id)
--    OR NOT EXISTS (SELECT 1 FROM warehouses w WHERE w.warehouse_id = s.warehouse_id);
-- INSERT INTO purchase_orders (
--     purchase_order_id, order_date, supplier_id, product_id, warehouse_id,
--     quantity_ordered, unit_cost, total_purchase_cost,
--     expected_delivery_date, actual_delivery_date, purchase_status, payment_status
-- )
-- SELECT
--     s.purchase_order_id, s.order_date, s.supplier_id, s.product_id, s.warehouse_id,
--     s.quantity_ordered, s.unit_cost, s.total_purchase_cost,
--     s.expected_delivery_date, s.actual_delivery_date, s.purchase_status, s.payment_status
-- FROM stg_purchase_orders s
-- WHERE EXISTS (SELECT 1 FROM products p WHERE p.product_id = s.product_id)
--   AND EXISTS (SELECT 1 FROM suppliers sup WHERE sup.supplier_id = s.supplier_id)
--   AND EXISTS (SELECT 1 FROM warehouses w WHERE w.warehouse_id = s.warehouse_id);

-- SELECT COUNT(*) AS final_po_count FROM public.purchase_orders;
-- SELECT * FROM public.purchase_orders;

-- DROP TABLE IF EXISTS public.stg_purchase_orders;

-- SELECT COUNT(*) AS total_products FROM public.products;
-- SELECT * FROM public.products WHERE product_id = 'PRD-9999';
-- SELECT * FROM public.products LIMIT 10;
  --Create table for Inventory
CREATE TABLE IF NOT EXISTS public.inventory (
    inventory_id VARCHAR(50) PRIMARY KEY,
    product_id VARCHAR(50),
    warehouse_id VARCHAR(50),
    opening_stock INT,
    stock_received INT,
    stock_issued INT,
    closing_stock INT,
    reserved_stock NUMERIC(10,2),
    available_stock INT,
    reorder_level NUMERIC(10,2),
    safety_stock INT,
    inventory_date DATE,
    CONSTRAINT fk_inv_product FOREIGN KEY (product_id) REFERENCES public.products(product_id),
    CONSTRAINT fk_inv_warehouse FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(warehouse_id)
);
-- DROP TABLE IF EXISTS public.stg_inventory;

-- CREATE TABLE public.stg_inventory (
--     inventory_id VARCHAR(50),
--     product_id VARCHAR(50),
--     warehouse_id VARCHAR(50),
--     opening_stock INT,
--     stock_received VARCHAR(50),
--     stock_issued INT,
--     closing_stock VARCHAR(50),
--     reserved_stock NUMERIC(10,2),
--     available_stock VARCHAR(50),
--     reorder_level NUMERIC(10,2),
--     safety_stock INT,
--     inventory_date VARCHAR(50)
-- );

-- INSERT INTO public.inventory (
--     inventory_id,
--     product_id,
--     warehouse_id,
--     opening_stock,
--     stock_received,
--     stock_issued,
--     closing_stock,
--     reserved_stock,
--     available_stock,
--     reorder_level,
--     safety_stock,
--     inventory_date
-- )
-- SELECT
--     s.inventory_id,
--     s.product_id,
--     s.warehouse_id,
--     s.opening_stock,
--     NULLIF(REPLACE(TRIM(s.stock_received), ',', ''), '')::INT,
--     s.stock_issued,
--     NULLIF(REPLACE(TRIM(s.closing_stock), ',', ''), '')::INT,
--     s.reserved_stock,
--     NULLIF(REPLACE(TRIM(s.available_stock), ',', ''), '')::INT,
--     s.reorder_level,
--     s.safety_stock,
--     TO_DATE(TRIM(s.inventory_date), 'DD/MM/YYYY')
-- FROM public.stg_inventory s
-- WHERE EXISTS (SELECT 1 FROM public.products p WHERE p.product_id = s.product_id)
--   AND EXISTS (SELECT 1 FROM public.warehouses w WHERE w.warehouse_id = s.warehouse_id);

-- SELECT COUNT(*) AS final_inventory_rows FROM public.inventory;
-- DROP TABLE IF EXISTS public.stg_inventory;
-- 6. Stock Movements Table
--Create table for Stock_Movement
CREATE TABLE IF NOT EXISTS public.stock_movement (
    movement_id VARCHAR(50) PRIMARY KEY,
    movement_date DATE NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    warehouse_id VARCHAR(50) NOT NULL,
    movement_type VARCHAR(100),
    reference_id VARCHAR(100),
    quantity_in NUMERIC(12,2),
    quantity_out NUMERIC(12,2),
    unit_cost NUMERIC(12,2),
    movement_value NUMERIC(14,2),
    remarks TEXT,
    CONSTRAINT fk_sm_product FOREIGN KEY (product_id) REFERENCES public.products(product_id),
    CONSTRAINT fk_sm_warehouse FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(warehouse_id)
);
-- DROP TABLE IF EXISTS public.stg_stock_movement;

-- CREATE TABLE public.stg_stock_movement (
--     movement_id VARCHAR(50),
--     movement_date VARCHAR(50),
--     product_id VARCHAR(50),
--     warehouse_id VARCHAR(50),
--     movement_type VARCHAR(100),
--     reference_id VARCHAR(100),
--     quantity_in NUMERIC(12,2),
--     quantity_out NUMERIC(12,2),
--     unit_cost NUMERIC(12,2),
--     movement_value NUMERIC(14,2),
--     remarks TEXT
-- );

-- INSERT INTO public.stock_movement (
--     movement_id,
--     movement_date,
--     product_id,
--     warehouse_id,
--     movement_type,
--     reference_id,
--     quantity_in,
--     quantity_out,
--     unit_cost,
--     movement_value,
--     remarks
-- )
-- SELECT
--     TRIM(s.movement_id),
--     TO_DATE(TRIM(s.movement_date), 'DD/MM/YYYY'),
--     TRIM(s.product_id),
--     TRIM(s.warehouse_id),
--     INITCAP(REGEXP_REPLACE(TRIM(s.movement_type), '\s+', ' ', 'g')),
--     NULLIF(TRIM(s.reference_id), ''),
--     COALESCE(s.quantity_in, 0),
--     COALESCE(s.quantity_out, 0),
--     COALESCE(s.unit_cost, 0),
--     COALESCE(s.movement_value, 0),
--     NULLIF(TRIM(s.remarks), '')
-- FROM public.stg_stock_movement s
-- WHERE s.movement_id IS NOT NULL
--   AND TRIM(s.movement_id) <> ''
--   AND s.movement_date IS NOT NULL
--   AND TRIM(s.movement_date) <> ''
--   AND EXISTS (SELECT 1 FROM public.products p WHERE p.product_id = TRIM(s.product_id))
--   AND EXISTS (SELECT 1 FROM public.warehouses w WHERE w.warehouse_id = TRIM(s.warehouse_id));
-- SELECT * from  stg_stock_movement;
-- SELECT * from  public.stock_movement;
-- SELECT COUNT(*) AS final_stock_movement_rows FROM public.stock_movement;
-- DROP TABLE IF EXISTS public.stg_stock_movement;

-- 7. Customer Orders Table (Note: Primary key matches Excel column 'OrderID')

---Create table for customers_order
CREATE TABLE IF NOT EXISTS public.customer_orders (
    order_id VARCHAR(50) PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    warehouse_id VARCHAR(50) NOT NULL,
    quantity_ordered NUMERIC(12,2),
    unit_selling_price NUMERIC(12,2),
    order_value NUMERIC(14,2),
    order_status VARCHAR(100),
    payment_status VARCHAR(100),
    shipping_method VARCHAR(100),
    expected_delivery_date DATE,
    actual_delivery_date DATE,
    CONSTRAINT fk_co_product FOREIGN KEY (product_id) REFERENCES public.products(product_id),
    CONSTRAINT fk_co_warehouse FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(warehouse_id)
);
-- DROP TABLE IF EXISTS public.stg_customer_orders;

-- CREATE TABLE public.stg_customer_orders (
--     order_id VARCHAR(50),
--     order_date VARCHAR(50),
--     customer_id VARCHAR(50),
--     product_id VARCHAR(50),
--     warehouse_id VARCHAR(50),
--     quantity_ordered NUMERIC(12,2),
--     unit_selling_price NUMERIC(12,2),
--     order_value NUMERIC(14,2),
--     order_status VARCHAR(100),
--     payment_status VARCHAR(100),
--     shipping_method VARCHAR(100),
--     expected_delivery_date VARCHAR(50),
--     actual_delivery_date VARCHAR(50)
-- );
-- select * from public.stg_customer_orders
-- INSERT INTO public.customer_orders (
--     order_id,
--     order_date,
--     customer_id,
--     product_id,
--     warehouse_id,
--     quantity_ordered,
--     unit_selling_price,
--     order_value,
--     order_status,
--     payment_status,
--     shipping_method,
--     expected_delivery_date,
--     actual_delivery_date
-- )
-- SELECT
--     TRIM(s.order_id),
--     TO_DATE(TRIM(s.order_date), 'DD/MM/YYYY'),
--     TRIM(s.customer_id),
--     TRIM(s.product_id),
--     TRIM(s.warehouse_id),
--     COALESCE(s.quantity_ordered, 0),
--     COALESCE(s.unit_selling_price, 0),
--     COALESCE(s.order_value, 0),
--     INITCAP(REGEXP_REPLACE(TRIM(s.order_status), '\s+', ' ', 'g')),
--     INITCAP(REGEXP_REPLACE(TRIM(s.payment_status), '\s+', ' ', 'g')),
--     INITCAP(REGEXP_REPLACE(TRIM(s.shipping_method), '\s+', ' ', 'g')),
--     CASE
--         WHEN s.expected_delivery_date IS NOT NULL AND TRIM(s.expected_delivery_date) <> ''
--         THEN TO_DATE(TRIM(s.expected_delivery_date), 'DD/MM/YYYY')
--     END,
--     CASE
--         WHEN s.actual_delivery_date IS NOT NULL AND TRIM(s.actual_delivery_date) <> ''
--         THEN TO_DATE(TRIM(s.actual_delivery_date), 'DD/MM/YYYY')
--     END
-- FROM public.stg_customer_orders s
-- WHERE s.order_id IS NOT NULL
--   AND TRIM(s.order_id) <> ''
--   AND s.order_date IS NOT NULL
--   AND TRIM(s.order_date) <> ''
--   AND EXISTS (SELECT 1 FROM public.products p WHERE p.product_id = TRIM(s.product_id))
--   AND EXISTS (SELECT 1 FROM public.warehouses w WHERE w.warehouse_id = TRIM(s.warehouse_id));
--   SELECT COUNT(*) AS final_customer_orders_rows FROM public.customer_orders;
--   select * from  public.customer_orders;
--   DROP TABLE IF EXISTS public.stg_customer_orders;

-- 8. Logistics Table
-- DROP TABLE IF EXISTS public.stg_logistics;

-- DROP TABLE IF EXISTS public.stg_logistics;

-- CREATE TABLE public.stg_logistics (
--     shipment_id VARCHAR(50),
--     order_id VARCHAR(50),
--     warehouse_id VARCHAR(50),
--     shipping_company VARCHAR(100),
--     shipping_method VARCHAR(100),
--     dispatch_date VARCHAR(50),
--     expected_delivery_date VARCHAR(50),
--     actual_delivery_date VARCHAR(50),
--     shipping_cost VARCHAR(50),
--     distance_km VARCHAR(50),
--     delivery_status VARCHAR(50),
--     delay_days VARCHAR(50)
-- );
--Create a table for logistics 
CREATE TABLE IF NOT EXISTS public.logistics (
    shipment_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    warehouse_id VARCHAR(50) NOT NULL,
    shipping_company VARCHAR(100),
    shipping_method VARCHAR(100),
    dispatch_date DATE,
    expected_delivery_date DATE,
    actual_delivery_date DATE,
    shipping_cost NUMERIC(12,2),
    distance_km NUMERIC(10,2),
    delivery_status VARCHAR(50),
    delay_days INT,
    CONSTRAINT fk_log_order FOREIGN KEY (order_id) REFERENCES public.customer_orders(order_id),
    CONSTRAINT fk_log_warehouse FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(warehouse_id)
);

-- INSERT INTO public.logistics (
--     shipment_id,
--     order_id,
--     warehouse_id,
--     shipping_company,
--     shipping_method,
--     dispatch_date,
--     expected_delivery_date,
--     actual_delivery_date,
--     shipping_cost,
--     distance_km,
--     delivery_status,
--     delay_days
-- )
-- SELECT
--     TRIM(s.shipment_id),
--     TRIM(s.order_id),
--     TRIM(s.warehouse_id),
--     NULLIF(REGEXP_REPLACE(TRIM(s.shipping_company), '\s+', ' ', 'g'), ''),
--     NULLIF(INITCAP(REGEXP_REPLACE(TRIM(s.shipping_method), '\s+', ' ', 'g')), ''),
--     CASE
--         WHEN s.dispatch_date IS NOT NULL AND TRIM(s.dispatch_date) <> ''
--         THEN TO_DATE(TRIM(s.dispatch_date), 'DD/MM/YYYY')
--     END,
--     CASE
--         WHEN s.expected_delivery_date IS NOT NULL AND TRIM(s.expected_delivery_date) <> ''
--         THEN TO_DATE(TRIM(s.expected_delivery_date), 'DD/MM/YYYY')
--     END,
--     CASE
--         WHEN s.actual_delivery_date IS NOT NULL AND TRIM(s.actual_delivery_date) <> ''
--         THEN TO_DATE(TRIM(s.actual_delivery_date), 'DD/MM/YYYY')
--     END,
--     COALESCE(NULLIF(REPLACE(TRIM(s.shipping_cost), ',', ''), ''), '0')::NUMERIC(12,2),
--     NULLIF(REPLACE(TRIM(s.distance_km), ',', ''), '')::NUMERIC(10,2),
--     CASE
--         WHEN UPPER(TRIM(s.delivery_status)) = 'ON-TIME' THEN 'On-Time'
--         ELSE NULLIF(INITCAP(REGEXP_REPLACE(TRIM(s.delivery_status), '\s+', ' ', 'g')), '')
--     END,
--     COALESCE(NULLIF(REPLACE(TRIM(s.delay_days), ',', ''), ''), '0')::NUMERIC(10,2)::INT
-- FROM public.stg_logistics s
-- WHERE s.shipment_id IS NOT NULL
--   AND TRIM(s.shipment_id) <> ''
--   AND s.order_id IS NOT NULL
--   AND TRIM(s.order_id) <> ''
--   AND EXISTS (SELECT 1 FROM public.customer_orders o WHERE o.order_id = TRIM(s.order_id))
--   AND EXISTS (SELECT 1 FROM public.warehouses w WHERE w.warehouse_id = TRIM(s.warehouse_id));
-- SELECT COUNT(*) AS final_logistics_rows FROM public.logistics;
-- DROP TABLE IF EXISTS public.stg_logistics;

-- Section(A) Inventory Performance KPIs
-- 1:Total Inventory Value
SELECT
    COUNT(*) AS sku_warehouse_records,
    SUM(COALESCE(i.available_stock, 0)) AS total_available_units,
    SUM(COALESCE(i.closing_stock, 0)) AS total_closing_units,
    ROUND(SUM(COALESCE(i.available_stock, 0) * COALESCE(p.unit_cost, 0)), 2) AS total_available_inventory_value_pkr,
    ROUND(SUM(COALESCE(i.closing_stock, 0) * COALESCE(p.unit_cost, 0)), 2) AS total_closing_inventory_value_pkr,
    ROUND(SUM(COALESCE(i.reserved_stock, 0) * COALESCE(p.unit_cost, 0)), 2) AS total_reserved_inventory_value_pkr
FROM public.inventory i
INNER JOIN public.products p
    ON i.product_id = p.product_id;
--2:1. Overall Stockout Rate
SELECT
    COUNT(*) AS total_sku_warehouse_records,
    COUNT(CASE WHEN COALESCE(i.available_stock, 0) <= 0 THEN 1 END) AS stockout_records,
    ROUND(
        COUNT(CASE WHEN COALESCE(i.available_stock, 0) <= 0 THEN 1 END) * 100.0 /
        NULLIF(COUNT(*), 0),
        2
    ) AS stockout_rate_pct
FROM public.inventory i
INNER JOIN public.products p
    ON i.product_id = p.product_id;
	
-- 2. Category-Wise Stockout Rate
SELECT
    p.category,
    COUNT(*) AS total_sku_warehouse_records,
    COUNT(CASE WHEN COALESCE(i.available_stock, 0) <= 0 THEN 1 END) AS stockout_records,
    ROUND(
        COUNT(CASE WHEN COALESCE(i.available_stock, 0) <= 0 THEN 1 END) * 100.0 /
        NULLIF(COUNT(*), 0),
        2
    ) AS stockout_rate_pct
FROM public.inventory i
INNER JOIN public.products p
    ON i.product_id = p.product_id
GROUP BY p.category
ORDER BY stockout_rate_pct DESC, stockout_records DESC;
--3: Warehouse-Wise Stockout Rate
SELECT
    w.warehouse_id,
    w.warehouse_name,
    w.city,
    COUNT(*) AS total_sku_warehouse_records,
    COUNT(CASE WHEN COALESCE(i.available_stock, 0) <= 0 THEN 1 END) AS stockout_records,
    ROUND(
        COUNT(CASE WHEN COALESCE(i.available_stock, 0) <= 0 THEN 1 END) * 100.0 /
        NULLIF(COUNT(*), 0),
        2
    ) AS stockout_rate_pct
FROM public.inventory i
INNER JOIN public.products p
    ON i.product_id = p.product_id
INNER JOIN public.warehouses w
    ON i.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_id, w.warehouse_name, w.city
ORDER BY stockout_rate_pct DESC, stockout_records DESC;

-- 4:Overall Inventory Turnover
WITH cogs_calc AS (
    SELECT
        SUM(COALESCE(co.quantity_ordered, 0) * COALESCE(p.unit_cost, 0)) AS annual_cogs_pkr
    FROM public.customer_orders co
    INNER JOIN public.products p
        ON co.product_id = p.product_id
    WHERE TRIM(co.order_status) = 'Delivered'
),
avg_inv_calc AS (
    SELECT
        SUM(((COALESCE(i.opening_stock, 0) + COALESCE(i.closing_stock, 0)) / 2.0) * COALESCE(p.unit_cost, 0)) AS avg_inventory_value_pkr
    FROM public.inventory i
    INNER JOIN public.products p
        ON i.product_id = p.product_id
)
SELECT
    ROUND(c.annual_cogs_pkr, 2) AS annual_cogs_pkr,
    ROUND(a.avg_inventory_value_pkr, 2) AS avg_inventory_value_pkr,
    ROUND(c.annual_cogs_pkr / NULLIF(a.avg_inventory_value_pkr, 0), 2) AS inventory_turnover_ratio
FROM cogs_calc c
CROSS JOIN avg_inv_calc a;

--5:Days Inventory Outstanding (DIO)

WITH cogs_calc AS (
    SELECT
        SUM(COALESCE(co.quantity_ordered, 0) * COALESCE(p.unit_cost, 0)) AS annual_cogs_pkr
    FROM public.customer_orders co
    INNER JOIN public.products p
        ON co.product_id = p.product_id
    WHERE TRIM(co.order_status) = 'Delivered'
),
avg_inv_calc AS (
    SELECT
        SUM(((COALESCE(i.opening_stock, 0) + COALESCE(i.closing_stock, 0)) / 2.0) * COALESCE(p.unit_cost, 0)) AS avg_inventory_value_pkr
    FROM public.inventory i
    INNER JOIN public.products p
        ON i.product_id = p.product_id
)
SELECT
    ROUND(c.annual_cogs_pkr, 2) AS annual_cogs_pkr,
    ROUND(a.avg_inventory_value_pkr, 2) AS avg_inventory_value_pkr,
    ROUND(c.annual_cogs_pkr / NULLIF(a.avg_inventory_value_pkr, 0), 2) AS inventory_turnover_ratio,
    ROUND(
        365.0 / NULLIF(c.annual_cogs_pkr / NULLIF(a.avg_inventory_value_pkr, 0), 0),
        1
    ) AS days_inventory_outstanding
FROM cogs_calc c
CROSS JOIN avg_inv_calc a;

-- 6. Excess Inventory
SELECT
    COUNT(*) AS total_sku_warehouse_records,
    COUNT(
        CASE
            WHEN GREATEST(
                0,
                COALESCE(i.closing_stock, 0) - COALESCE(p.reorder_level * 2, p.safety_stock * 2, 0)
            ) > 0 THEN 1
        END
    ) AS excess_stock_records,
    SUM(
        GREATEST(
            0,
            COALESCE(i.closing_stock, 0) - COALESCE(p.reorder_level * 2, p.safety_stock * 2, 0)
        )
    ) AS total_excess_units,
    ROUND(
        SUM(
            GREATEST(
                0,
                COALESCE(i.closing_stock, 0) - COALESCE(p.reorder_level * 2, p.safety_stock * 2, 0)
            ) * COALESCE(p.unit_cost, 0)
        ),
        2
    ) AS excess_inventory_value_pkr,
    ROUND(
        SUM(
            GREATEST(
                0,
                COALESCE(i.closing_stock, 0) - COALESCE(p.reorder_level * 2, p.safety_stock * 2, 0)
            ) * COALESCE(p.unit_cost, 0)
        ) * 0.20,
        2
    ) AS est_annual_holding_cost_pkr
FROM public.inventory i
INNER JOIN public.products p
    ON i.product_id = p.product_id;

-- 7. Reorder Requirement

SELECT
    COUNT(*) AS total_sku_warehouse_records,
    COUNT(
        CASE
            WHEN GREATEST(0, COALESCE(p.reorder_level, 0) - COALESCE(i.available_stock, 0)) > 0
            THEN 1
        END
    ) AS items_needing_reorder,
    SUM(
        GREATEST(0, COALESCE(p.reorder_level, 0) - COALESCE(i.available_stock, 0))
    ) AS total_reorder_units_needed,
    ROUND(
        SUM(
            GREATEST(0, COALESCE(p.reorder_level, 0) - COALESCE(i.available_stock, 0))
            * COALESCE(p.unit_cost, 0)
        ),
        2
    ) AS estimated_replenishment_cost_pkr
FROM public.inventory i
INNER JOIN public.products p
    ON i.product_id = p.product_id;

 -- SectionB:Supplier Performance KPIs	

-- 1. On-Time Delivery Rate
SELECT
    s.supplier_id,
    s.supplier_name,
    COUNT(CASE WHEN po.actual_delivery_date IS NOT NULL THEN 1 END) AS total_completed_deliveries,
    COUNT(CASE WHEN po.actual_delivery_date <= po.expected_delivery_date THEN 1 END) AS on_time_deliveries,
    ROUND(
        COUNT(CASE WHEN po.actual_delivery_date <= po.expected_delivery_date THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN po.actual_delivery_date IS NOT NULL THEN 1 END), 0),
        2
    ) AS on_time_delivery_rate_pct
FROM public.suppliers s
LEFT JOIN public.purchase_orders po
    ON s.supplier_id = po.supplier_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY on_time_delivery_rate_pct DESC NULLS LAST;

-- 2. Average Lead Time
SELECT
    s.supplier_id,
    s.supplier_name,
    COUNT(CASE WHEN po.actual_delivery_date IS NOT NULL THEN 1 END) AS total_completed_deliveries,
    SUM(
        CASE
            WHEN po.actual_delivery_date IS NOT NULL
            THEN (po.actual_delivery_date::date - po.order_date::date)
            ELSE 0
        END
    ) AS total_lead_days,
    ROUND(
        AVG(
            CASE
                WHEN po.actual_delivery_date IS NOT NULL
                THEN (po.actual_delivery_date::date - po.order_date::date)
            END
        ),
        1
    ) AS avg_lead_time_days
FROM public.suppliers s
LEFT JOIN public.purchase_orders po
    ON s.supplier_id = po.supplier_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY avg_lead_time_days ASC NULLS LAST;
	
-- 3. Supplier Delay Rate
SELECT
    s.supplier_id,
    s.supplier_name,
    COUNT(CASE WHEN po.actual_delivery_date IS NOT NULL THEN 1 END) AS total_completed_deliveries,
    COUNT(CASE WHEN po.actual_delivery_date > po.expected_delivery_date THEN 1 END) AS late_deliveries,
    ROUND(
        COUNT(CASE WHEN po.actual_delivery_date > po.expected_delivery_date THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN po.actual_delivery_date IS NOT NULL THEN 1 END), 0),
        2
    ) AS supplier_delay_rate_pct
FROM public.suppliers s
LEFT JOIN public.purchase_orders po
    ON s.supplier_id = po.supplier_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY supplier_delay_rate_pct DESC NULLS LAST;

-- 4. Purchase Value
SELECT
    s.supplier_id,
    s.supplier_name,
    COUNT(po.purchase_order_id) AS total_pos,
    ROUND(
        SUM(
            CASE
                WHEN TRIM(COALESCE(po.purchase_status, '')) <> 'Cancelled'
                THEN COALESCE(po.total_purchase_cost, 0)
                ELSE 0
            END
        ),
        2
    ) AS total_purchase_value_pkr
FROM public.suppliers s
LEFT JOIN public.purchase_orders po
    ON s.supplier_id = po.supplier_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY total_purchase_value_pkr DESC;

-- 5. Supplier Performance Weighted Score
WITH parsed_po AS (
    SELECT
        po.supplier_id,
        po.purchase_status,
        COALESCE(po.quantity_ordered, 0) AS quantity_ordered,
        CASE
            WHEN NULLIF(TRIM(po.actual_delivery_date), '') IS NULL THEN NULL
            WHEN TRIM(po.actual_delivery_date) ~ '^\d{4}-\d{2}-\d{2}$' THEN TRIM(po.actual_delivery_date)::DATE
            WHEN TRIM(po.actual_delivery_date) ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(TRIM(po.actual_delivery_date), 'DD/MM/YYYY')
            WHEN TRIM(po.actual_delivery_date) ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_DATE(TRIM(po.actual_delivery_date), 'DD-MM-YYYY')
        END AS actual_dt,
        CASE
            WHEN NULLIF(TRIM(po.expected_delivery_date), '') IS NULL THEN NULL
            WHEN TRIM(po.expected_delivery_date) ~ '^\d{4}-\d{2}-\d{2}$' THEN TRIM(po.expected_delivery_date)::DATE
            WHEN TRIM(po.expected_delivery_date) ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(TRIM(po.expected_delivery_date), 'DD/MM/YYYY')
            WHEN TRIM(po.expected_delivery_date) ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_DATE(TRIM(po.expected_delivery_date), 'DD-MM-YYYY')
        END AS expected_dt,
        CASE
            WHEN NULLIF(TRIM(po.order_date), '') IS NULL THEN NULL
            WHEN TRIM(po.order_date) ~ '^\d{4}-\d{2}-\d{2}$' THEN TRIM(po.order_date)::DATE
            WHEN TRIM(po.order_date) ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(TRIM(po.order_date), 'DD/MM/YYYY')
            WHEN TRIM(po.order_date) ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_DATE(TRIM(po.order_date), 'DD-MM-YYYY')
        END AS order_dt
    FROM public.purchase_orders po
),
base_po AS (
    SELECT
        supplier_id,
        COUNT(CASE WHEN actual_dt IS NOT NULL THEN 1 END) AS delivered_pos,
        COUNT(CASE WHEN actual_dt IS NOT NULL AND expected_dt IS NOT NULL AND actual_dt <= expected_dt THEN 1 END) AS on_time_pos,
        AVG(
            CASE
                WHEN actual_dt IS NOT NULL AND order_dt IS NOT NULL
                THEN (actual_dt - order_dt)
            END
        ) AS avg_actual_lead,
        AVG(
            CASE
                WHEN expected_dt IS NOT NULL AND order_dt IS NOT NULL
                THEN (expected_dt - order_dt)
            END
        ) AS avg_expected_lead,
        SUM(
            CASE
                WHEN TRIM(COALESCE(purchase_status, '')) <> 'Cancelled'
                THEN quantity_ordered
                ELSE 0
            END
        ) AS ordered_qty
    FROM parsed_po
    GROUP BY supplier_id
),
returns_by_supplier AS (
    SELECT
        p.supplier_id,
        SUM(COALESCE(sm.quantity_out, 0)) AS returned_qty
    FROM public.stock_movement sm
    INNER JOIN public.products p
        ON sm.product_id = p.product_id
    WHERE TRIM(COALESCE(sm.movement_type, '')) = 'Return'
    GROUP BY p.supplier_id
)
SELECT
    s.supplier_id,
    s.supplier_name,
    ROUND(
        COALESCE(b.on_time_pos, 0) * 100.0 / NULLIF(b.delivered_pos, 0),
        2
    ) AS otd_pct,
    ROUND(
        LEAST(100.0, GREATEST(0.0, COALESCE(b.avg_expected_lead, 0) * 100.0 / NULLIF(b.avg_actual_lead, 0))),
        2
    ) AS lead_time_score,
    ROUND(
        GREATEST(0.0, 100.0 - (COALESCE(r.returned_qty, 0) * 100.0 / NULLIF(b.ordered_qty, 0))),
        2
    ) AS quality_score,
    ROUND(
        (0.50 * COALESCE(b.on_time_pos, 0) * 100.0 / NULLIF(b.delivered_pos, 0)) +
        (0.30 * LEAST(100.0, GREATEST(0.0, COALESCE(b.avg_expected_lead, 0) * 100.0 / NULLIF(b.avg_actual_lead, 0)))) +
        (0.20 * GREATEST(0.0, 100.0 - (COALESCE(r.returned_qty, 0) * 100.0 / NULLIF(b.ordered_qty, 0)))),
        2
    ) AS supplier_weighted_score
FROM public.suppliers s
LEFT JOIN base_po b
    ON s.supplier_id = b.supplier_id
LEFT JOIN returns_by_supplier r
    ON s.supplier_id = r.supplier_id
ORDER BY supplier_weighted_score DESC NULLS LAST;

-- SectionC Warehouse & Logistics KPIs

 -- 1:Warehouse Utilization
 SELECT
    w.warehouse_id,
    w.warehouse_name,
    w.city,
    COALESCE(SUM(i.closing_stock), 0) AS used_capacity,
    COALESCE(
        NULLIF(REGEXP_REPLACE(COALESCE(w.storage_capacity::TEXT, ''), '[^0-9.-]', '', 'g'), '')::NUMERIC,
        0
    ) AS total_capacity,
    ROUND(
        COALESCE(SUM(i.closing_stock), 0) * 100.0 /
        NULLIF(
            NULLIF(REGEXP_REPLACE(COALESCE(w.storage_capacity::TEXT, ''), '[^0-9.-]', '', 'g'), '')::NUMERIC,
            0
        ),
        2
    ) AS warehouse_utilization_pct
FROM public.warehouses w
LEFT JOIN public.inventory i
    ON w.warehouse_id = i.warehouse_id
GROUP BY w.warehouse_id, w.warehouse_name, w.city, w.storage_capacity
ORDER BY warehouse_utilization_pct DESC NULLS LAST;

ALTER TABLE public.warehouses
    ALTER COLUMN storage_capacity TYPE NUMERIC
    USING (
        NULLIF(REGEXP_REPLACE(COALESCE(storage_capacity::TEXT, ''), '[^0-9.-]', '', 'g'), '')::NUMERIC
    );

-- 2. Average Delivery Time

WITH parsed_shipments AS (
    SELECT
        l.shipment_id,
        l.warehouse_id,
        l.shipping_company,
        CASE
            WHEN NULLIF(TRIM(l.dispatch_date::TEXT), '') IS NULL THEN NULL
            WHEN TRIM(l.dispatch_date::TEXT) ~ '^\d{4}-\d{2}-\d{2}$' THEN TRIM(l.dispatch_date::TEXT)::DATE
            WHEN TRIM(l.dispatch_date::TEXT) ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(TRIM(l.dispatch_date::TEXT), 'DD/MM/YYYY')
            WHEN TRIM(l.dispatch_date::TEXT) ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_DATE(TRIM(l.dispatch_date::TEXT), 'DD-MM-YYYY')
        END AS dispatch_dt,
        CASE
            WHEN NULLIF(TRIM(l.actual_delivery_date::TEXT), '') IS NULL THEN NULL
            WHEN TRIM(l.actual_delivery_date::TEXT) ~ '^\d{4}-\d{2}-\d{2}$' THEN TRIM(l.actual_delivery_date::TEXT)::DATE
            WHEN TRIM(l.actual_delivery_date::TEXT) ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(TRIM(l.actual_delivery_date::TEXT), 'DD/MM/YYYY')
            WHEN TRIM(l.actual_delivery_date::TEXT) ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_DATE(TRIM(l.actual_delivery_date::TEXT), 'DD-MM-YYYY')
        END AS actual_delivery_dt
    FROM public.logistics l
)
SELECT
    w.warehouse_id,
    w.warehouse_name,
    w.city,
    COUNT(CASE WHEN ps.actual_delivery_dt IS NOT NULL AND ps.dispatch_dt IS NOT NULL THEN 1 END) AS delivered_shipments,
    SUM(
        CASE
            WHEN ps.actual_delivery_dt IS NOT NULL AND ps.dispatch_dt IS NOT NULL
            THEN (ps.actual_delivery_dt - ps.dispatch_dt)
            ELSE 0
        END
    ) AS total_delivery_days,
    ROUND(
        AVG(
            CASE
                WHEN ps.actual_delivery_dt IS NOT NULL AND ps.dispatch_dt IS NOT NULL
                THEN (ps.actual_delivery_dt - ps.dispatch_dt)
            END
        ),
        1
    ) AS avg_delivery_time_days
FROM public.warehouses w
LEFT JOIN parsed_shipments ps
    ON w.warehouse_id = ps.warehouse_id
GROUP BY w.warehouse_id, w.warehouse_name, w.city
ORDER BY avg_delivery_time_days ASC NULLS LAST;

-- 3. Shipping Cost per Order

SELECT
    ROUND(
        SUM(
            COALESCE(
                NULLIF(REGEXP_REPLACE(COALESCE(l.shipping_cost::TEXT, ''), '[^0-9.-]', '', 'g'), '')::NUMERIC,
                0
            )
        ),
        2
    ) AS total_shipping_cost_pkr,
    COUNT(DISTINCT l.order_id) AS total_orders,
    ROUND(
        SUM(
            COALESCE(
                NULLIF(REGEXP_REPLACE(COALESCE(l.shipping_cost::TEXT, ''), '[^0-9.-]', '', 'g'), '')::NUMERIC,
                0
            )
        ) / NULLIF(COUNT(DISTINCT l.order_id), 0),
        2
    ) AS shipping_cost_per_order_pkr
FROM public.logistics l;

 -- 4. Delayed Shipment Rate

 WITH parsed_delays AS (
    SELECT
        l.shipment_id,
        l.warehouse_id,
        l.shipping_company,
        TRIM(COALESCE(l.delivery_status, '')) AS delivery_status,
        CASE
            WHEN NULLIF(TRIM(l.expected_delivery_date::TEXT), '') IS NULL THEN NULL
            WHEN TRIM(l.expected_delivery_date::TEXT) ~ '^\d{4}-\d{2}-\d{2}$' THEN TRIM(l.expected_delivery_date::TEXT)::DATE
            WHEN TRIM(l.expected_delivery_date::TEXT) ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(TRIM(l.expected_delivery_date::TEXT), 'DD/MM/YYYY')
            WHEN TRIM(l.expected_delivery_date::TEXT) ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_DATE(TRIM(l.expected_delivery_date::TEXT), 'DD-MM-YYYY')
        END AS expected_dt,
        CASE
            WHEN NULLIF(TRIM(l.actual_delivery_date::TEXT), '') IS NULL THEN NULL
            WHEN TRIM(l.actual_delivery_date::TEXT) ~ '^\d{4}-\d{2}-\d{2}$' THEN TRIM(l.actual_delivery_date::TEXT)::DATE
            WHEN TRIM(l.actual_delivery_date::TEXT) ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(TRIM(l.actual_delivery_date::TEXT), 'DD/MM/YYYY')
            WHEN TRIM(l.actual_delivery_date::TEXT) ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_DATE(TRIM(l.actual_delivery_date::TEXT), 'DD-MM-YYYY')
        END AS actual_dt
    FROM public.logistics l
)
SELECT
    COUNT(CASE WHEN actual_dt IS NOT NULL THEN 1 END) AS total_completed_shipments,
    COUNT(CASE WHEN actual_dt IS NOT NULL AND expected_dt IS NOT NULL AND actual_dt > expected_dt THEN 1 END) AS delayed_shipments,
    ROUND(
        COUNT(CASE WHEN actual_dt IS NOT NULL AND expected_dt IS NOT NULL AND actual_dt > expected_dt THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN actual_dt IS NOT NULL THEN 1 END), 0),
        2
    ) AS delayed_shipment_rate_pct
FROM parsed_delays;

-- 5. Stock Availability

SELECT
    w.warehouse_id,
    w.warehouse_name,
    w.city,
    COALESCE(SUM(i.available_stock), 0) AS total_available_stock,
    COALESCE(SUM(i.closing_stock), 0) AS total_closing_stock,
    ROUND(
        COALESCE(SUM(i.available_stock), 0) * 100.0 /
        NULLIF(COALESCE(SUM(i.closing_stock), 0), 0),
        2
    ) AS stock_availability_pct
FROM public.warehouses w
LEFT JOIN public.inventory i
    ON w.warehouse_id = i.warehouse_id
GROUP BY w.warehouse_id, w.warehouse_name, w.city
ORDER BY stock_availability_pct DESC NULLS LAST;

-- Section D cost reduction
-- 1:Inventory Holding Cost Savings
WITH annual_sales AS (
    SELECT
        co.product_id,
        SUM(
            CASE
                WHEN TRIM(COALESCE(co.order_status, '')) = 'Delivered'
                THEN COALESCE(co.quantity_ordered, 0)
                ELSE 0
            END
        ) AS units_sold_2025
    FROM public.customer_orders co
    GROUP BY co.product_id
),
sku_stock AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        COALESCE(s.units_sold_2025, 0) AS units_sold_2025,
        SUM(COALESCE(i.closing_stock, 0)) AS total_closing_stock,
        SUM(COALESCE(i.closing_stock, 0) * COALESCE(p.unit_cost, 0)) AS tied_up_capital_pkr,
        ROUND(
            SUM(COALESCE(i.closing_stock, 0) * COALESCE(p.unit_cost, 0)) * 0.20,
            2
        ) AS est_annual_holding_cost_pkr
    FROM public.products p
    INNER JOIN public.inventory i
        ON p.product_id = i.product_id
    LEFT JOIN annual_sales s
        ON p.product_id = s.product_id
    GROUP BY p.product_id, p.product_name, p.category, s.units_sold_2025
    HAVING COALESCE(s.units_sold_2025, 0) < 25
       AND SUM(COALESCE(i.closing_stock, 0)) > 50
)
SELECT
    COUNT(*) AS slow_dead_sku_count,
    ROUND(SUM(tied_up_capital_pkr), 2) AS total_tied_up_capital_pkr,
    ROUND(SUM(est_annual_holding_cost_pkr), 2) AS current_annual_holding_cost_pkr,
    ROUND(SUM(tied_up_capital_pkr) * 0.50, 2) AS potential_unlocked_capital_50pct_pkr,
    ROUND(SUM(est_annual_holding_cost_pkr) * 0.50, 2) AS potential_holding_cost_saving_50pct_pkr
FROM sku_stock;

-- 2:Courier Cost Reduction
WITH courier_stats AS (
    SELECT
        TRIM(COALESCE(l.shipping_company, 'Unknown')) AS shipping_company,
        COUNT(l.shipment_id) AS total_shipments,
        ROUND(
            AVG(
                NULLIF(REGEXP_REPLACE(COALESCE(l.shipping_cost::TEXT, ''), '[^0-9.-]', '', 'g'), '')::NUMERIC
            ),
            2
        ) AS avg_shipping_cost_pkr,
        ROUND(
            SUM(
                COALESCE(
                    NULLIF(REGEXP_REPLACE(COALESCE(l.shipping_cost::TEXT, ''), '[^0-9.-]', '', 'g'), '')::NUMERIC,
                    0
                )
            ),
            2
        ) AS total_shipping_cost_pkr,
        ROUND(
            COUNT(CASE WHEN l.actual_delivery_date <= l.expected_delivery_date THEN 1 END) * 100.0 /
            NULLIF(COUNT(CASE WHEN l.actual_delivery_date IS NOT NULL THEN 1 END), 0),
            2
        ) AS otd_rate_pct
    FROM public.logistics l
    GROUP BY TRIM(COALESCE(l.shipping_company, 'Unknown'))
),
best_cost AS (
    SELECT MIN(avg_shipping_cost_pkr) AS min_avg_cost_pkr
    FROM courier_stats
    WHERE total_shipments > 0
)
SELECT
    c.shipping_company,
    c.total_shipments,
    c.otd_rate_pct,
    c.avg_shipping_cost_pkr,
    c.total_shipping_cost_pkr,
    b.min_avg_cost_pkr AS benchmark_min_avg_cost_pkr,
    ROUND(
        GREATEST(0, c.total_shipping_cost_pkr - (c.total_shipments * b.min_avg_cost_pkr)),
        2
    ) AS potential_freight_saving_pkr
FROM courier_stats c
CROSS JOIN best_cost b
ORDER BY potential_freight_saving_pkr DESC;


-- SECTION(D)Core Analytical Views: Inventory, Supplier, Warehouse & Logistics

-- 1. Inventory Performance KPIs View (vw_inventory_kpis)

CREATE OR REPLACE VIEW public.vw_inventory_kpis AS
WITH sku_cogs AS (
    SELECT
        co.product_id,
        SUM(
            CASE
                WHEN TRIM(COALESCE(co.order_status, '')) = 'Delivered'
                THEN COALESCE(co.quantity_ordered, 0) * COALESCE(p.unit_cost, 0)
                ELSE 0
            END
        ) AS annual_cogs_pkr
    FROM public.customer_orders co
    INNER JOIN public.products p
        ON co.product_id = p.product_id
    GROUP BY co.product_id
),
sku_avg_inv AS (
    SELECT
        i.product_id,
        SUM(((COALESCE(i.opening_stock, 0) + COALESCE(i.closing_stock, 0)) / 2.0) * COALESCE(p.unit_cost, 0)) AS avg_inventory_value_pkr
    FROM public.inventory i
    INNER JOIN public.products p
        ON i.product_id = p.product_id
    GROUP BY i.product_id
),
sku_velocity AS (
    SELECT
        p.product_id,
        COALESCE(c.annual_cogs_pkr, 0) / NULLIF(a.avg_inventory_value_pkr, 0) AS inventory_turnover_ratio,
        365.0 / NULLIF(COALESCE(c.annual_cogs_pkr, 0) / NULLIF(a.avg_inventory_value_pkr, 0), 0) AS dio_days
    FROM public.products p
    LEFT JOIN sku_cogs c
        ON p.product_id = c.product_id
    LEFT JOIN sku_avg_inv a
        ON p.product_id = a.product_id
)
SELECT
    i.inventory_id,
    i.product_id,
    p.product_name,
    p.category,
    i.warehouse_id,
    w.warehouse_name,
    w.city,
    COALESCE(i.opening_stock, 0) AS opening_stock,
    COALESCE(i.closing_stock, 0) AS closing_stock,
    COALESCE(i.available_stock, 0) AS available_stock,
    COALESCE(p.unit_cost, 0) AS unit_cost_pkr,
    COALESCE(p.reorder_level, 0) AS reorder_level,
    COALESCE(p.safety_stock, 0) AS safety_stock,
    ROUND(COALESCE(i.available_stock, 0) * COALESCE(p.unit_cost, 0), 2) AS total_inventory_value_pkr,
    CASE WHEN COALESCE(i.available_stock, 0) <= 0 THEN 1 ELSE 0 END AS is_stockout_flag,
    ROUND(COALESCE(v.inventory_turnover_ratio, 0), 2) AS inventory_turnover_ratio,
    ROUND(v.dio_days, 1) AS days_inventory_outstanding,
    GREATEST(
        0,
        COALESCE(i.closing_stock, 0) - COALESCE(p.reorder_level * 2, p.safety_stock * 2, 0)
    ) AS excess_inventory_units,
    ROUND(
        GREATEST(0, COALESCE(i.closing_stock, 0) - COALESCE(p.reorder_level * 2, p.safety_stock * 2, 0))
        * COALESCE(p.unit_cost, 0),
        2
    ) AS excess_inventory_value_pkr,
    GREATEST(0, COALESCE(p.reorder_level, 0) - COALESCE(i.available_stock, 0)) AS reorder_requirement_units
FROM public.inventory i
INNER JOIN public.products p
    ON i.product_id = p.product_id
INNER JOIN public.warehouses w
    ON i.warehouse_id = w.warehouse_id
LEFT JOIN sku_velocity v
    ON i.product_id = v.product_id;

-- 2. Supplier Performance KPIs View (vw_supplier_kpis)

CREATE OR REPLACE VIEW public.vw_supplier_kpis AS
WITH parsed_po AS (
    SELECT
        po.purchase_order_id,
        po.supplier_id,
        po.purchase_status,
        COALESCE(po.quantity_ordered, 0) AS quantity_ordered,
        COALESCE(po.total_purchase_cost, 0) AS total_purchase_cost,
        CASE
            WHEN NULLIF(TRIM(po.order_date::TEXT), '') IS NULL THEN NULL
            WHEN TRIM(po.order_date::TEXT) ~ '^\d{4}-\d{2}-\d{2}$' THEN TRIM(po.order_date::TEXT)::DATE
            WHEN TRIM(po.order_date::TEXT) ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(TRIM(po.order_date::TEXT), 'DD/MM/YYYY')
            WHEN TRIM(po.order_date::TEXT) ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_DATE(TRIM(po.order_date::TEXT), 'DD-MM-YYYY')
        END AS order_dt,
        CASE
            WHEN NULLIF(TRIM(po.expected_delivery_date::TEXT), '') IS NULL THEN NULL
            WHEN TRIM(po.expected_delivery_date::TEXT) ~ '^\d{4}-\d{2}-\d{2}$' THEN TRIM(po.expected_delivery_date::TEXT)::DATE
            WHEN TRIM(po.expected_delivery_date::TEXT) ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(TRIM(po.expected_delivery_date::TEXT), 'DD/MM/YYYY')
            WHEN TRIM(po.expected_delivery_date::TEXT) ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_DATE(TRIM(po.expected_delivery_date::TEXT), 'DD-MM-YYYY')
        END AS expected_dt,
        CASE
            WHEN NULLIF(TRIM(po.actual_delivery_date::TEXT), '') IS NULL THEN NULL
            WHEN TRIM(po.actual_delivery_date::TEXT) ~ '^\d{4}-\d{2}-\d{2}$' THEN TRIM(po.actual_delivery_date::TEXT)::DATE
            WHEN TRIM(po.actual_delivery_date::TEXT) ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(TRIM(po.actual_delivery_date::TEXT), 'DD/MM/YYYY')
            WHEN TRIM(po.actual_delivery_date::TEXT) ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_DATE(TRIM(po.actual_delivery_date::TEXT), 'DD-MM-YYYY')
        END AS actual_dt
    FROM public.purchase_orders po
),
po_agg AS (
    SELECT
        supplier_id,
        COUNT(purchase_order_id) AS total_pos,
        COUNT(CASE WHEN actual_dt IS NOT NULL THEN 1 END) AS total_deliveries,
        COUNT(CASE WHEN actual_dt IS NOT NULL AND expected_dt IS NOT NULL AND actual_dt <= expected_dt THEN 1 END) AS on_time_deliveries,
        COUNT(CASE WHEN actual_dt IS NOT NULL AND expected_dt IS NOT NULL AND actual_dt > expected_dt THEN 1 END) AS late_deliveries,
        SUM(CASE WHEN actual_dt IS NOT NULL AND order_dt IS NOT NULL THEN (actual_dt - order_dt) ELSE 0 END) AS total_lead_days,
        AVG(CASE WHEN actual_dt IS NOT NULL AND order_dt IS NOT NULL THEN (actual_dt - order_dt) END) AS avg_lead_time_days,
        AVG(CASE WHEN expected_dt IS NOT NULL AND order_dt IS NOT NULL THEN (expected_dt - order_dt) END) AS avg_expected_lead_days,
        SUM(CASE WHEN TRIM(COALESCE(purchase_status, '')) <> 'Cancelled' THEN total_purchase_cost ELSE 0 END) AS purchase_value_pkr,
        SUM(CASE WHEN TRIM(COALESCE(purchase_status, '')) <> 'Cancelled' THEN quantity_ordered ELSE 0 END) AS ordered_qty
    FROM parsed_po
    GROUP BY supplier_id
),
returns_agg AS (
    SELECT
        p.supplier_id,
        SUM(COALESCE(sm.quantity_out, 0)) AS returned_qty
    FROM public.stock_movement sm
    INNER JOIN public.products p
        ON sm.product_id = p.product_id
    WHERE TRIM(COALESCE(sm.movement_type, '')) = 'Return'
    GROUP BY p.supplier_id
)
SELECT
    s.supplier_id,
    s.supplier_name,
    s.city,
    COALESCE(a.total_pos, 0) AS total_pos,
    COALESCE(a.total_deliveries, 0) AS total_deliveries,
    ROUND(COALESCE(a.on_time_deliveries, 0) * 100.0 / NULLIF(a.total_deliveries, 0), 2) AS on_time_delivery_rate_pct,
    COALESCE(a.total_lead_days, 0) AS total_lead_days,
    ROUND(a.avg_lead_time_days, 1) AS average_lead_time_days,
    ROUND(COALESCE(a.late_deliveries, 0) * 100.0 / NULLIF(a.total_deliveries, 0), 2) AS supplier_delay_rate_pct,
    ROUND(COALESCE(a.purchase_value_pkr, 0), 2) AS purchase_value_pkr,
    ROUND(
        (0.50 * COALESCE(a.on_time_deliveries, 0) * 100.0 / NULLIF(a.total_deliveries, 0)) +
        (0.30 * LEAST(100.0, GREATEST(0.0, COALESCE(a.avg_expected_lead_days, 0) * 100.0 / NULLIF(a.avg_lead_time_days, 0)))) +
        (0.20 * GREATEST(0.0, 100.0 - (COALESCE(r.returned_qty, 0) * 100.0 / NULLIF(a.ordered_qty, 0)))),
        2
    ) AS supplier_performance_weighted_score
FROM public.suppliers s
LEFT JOIN po_agg a
    ON s.supplier_id = a.supplier_id
LEFT JOIN returns_agg r
    ON s.supplier_id = r.supplier_id;
	
-- 3. Warehouse Capacity & Stock Availability View (vw_warehouse_kpis)

CREATE OR REPLACE VIEW public.vw_warehouse_kpis AS
SELECT
    w.warehouse_id,
    w.warehouse_name,
    w.city,
    COALESCE(SUM(i.closing_stock), 0) AS used_capacity,
    COALESCE(
        NULLIF(REGEXP_REPLACE(COALESCE(w.storage_capacity::TEXT, ''), '[^0-9.-]', '', 'g'), '')::NUMERIC,
        0
    ) AS total_capacity,
    ROUND(
        COALESCE(SUM(i.closing_stock), 0) * 100.0 /
        NULLIF(
            NULLIF(REGEXP_REPLACE(COALESCE(w.storage_capacity::TEXT, ''), '[^0-9.-]', '', 'g'), '')::NUMERIC,
            0
        ),
        2
    ) AS warehouse_utilization_pct,
    COALESCE(SUM(i.available_stock), 0) AS available_stock,
    COALESCE(SUM(i.closing_stock), 0) AS total_stock,
    ROUND(
        COALESCE(SUM(i.available_stock), 0) * 100.0 /
        NULLIF(COALESCE(SUM(i.closing_stock), 0), 0),
        2
    ) AS stock_availability_pct
FROM public.warehouses w
LEFT JOIN public.inventory i
    ON w.warehouse_id = i.warehouse_id
GROUP BY w.warehouse_id, w.warehouse_name, w.city, w.storage_capacity;

	



