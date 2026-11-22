<div align="center">

<!-- Animated Typing SVG Banner -->
<a href="https://github.com/muhammadasad-dev118/supply_chain_inventory">
  <img src="https://readme-typing-svg.demolab.com?font=Inter&weight=700&size=28&duration=3000&pause=1000&color=14B8A6&center=true&vCenter=true&repeat=true&width=820&lines=Supply+Chain+%26+Inventory+Analytics;Power+BI+Dashboard+%7C+SQL+Views+%7C+FY+2025+Audit;Stock+Valuation+%7C+Supplier+OTD+%7C+3PL+Logistics" alt="Typing SVG" />
</a>

<br />

<!-- Animated / Dynamic Badges -->
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Analytics-0EA5E9?style=for-the-badge&logo=databricks&logoColor=white)
![Status](https://img.shields.io/badge/Audit%20Scope-FY%202025-10B981?style=for-the-badge)
![Currency](https://img.shields.io/badge/Currency-PKR-F59E0B?style=for-the-badge)

<br />

<!-- Optional Logo Preview (uncomment once uploaded to repo) -->
<!-- <img src="./supply_chain_logo.png" alt="Supply Chain Inventory Logo" width="220" /> -->

</div>

---

## Overview

An end-to-end **Supply Chain & Inventory Analytics** solution built to audit working capital allocation, warehouse capacity balance, supplier reliability, and outbound 3PL courier performance across **8 tables**, **6 warehouses**, **35 suppliers**, and **220 SKUs** in **PKR**.

Designed with a high-contrast dark theme (`#242222` / `#141923`) using **Emerald Green** to highlight top efficiency and **Coral Red** to flag operational risks, the dashboard gives leadership immediate visibility from executive KPIs down to SKU reorder buffers and monthly freight spikes.

---

## At a Glance: Core Metrics

| Metric | Headline Value | Formula / Logic | Operational Focus |
| :--- | :--- | :--- | :--- |
| **Available Inventory** | **PKR 659.58M** | `AvailableStock × UnitCost` | Working capital locked in stock |
| **Hub Utilization** | **56.5% – 91.4%** | `ClosingStock ÷ StorageCapacity` | Warehouse space pressure |
| **Supplier OTD %** | **Vendor Timeliness** | `Actual ≤ ExpectedDeliveryDate` | On-time vendor SLA adherence |
| **Avg Supplier Lead** | **Replenishment Days** | `ActualDeliveryDate − OrderDate` | Inbound order fulfillment speed |
| **Total Freight Spend** | **PKR 6.34M** | `SUM(Logistics_raw.ShippingCost)` | Outbound 3PL shipping cost |
| **Delayed Shipments** | **Late Delivery %** | `Actual > ExpectedDeliveryDate` | Carrier late-delivery rate |
| **Avg Transit Days** | **3.0 – 3.85 Days** | `ActualDeliveryDate − DispatchDate` | Dispatch-to-delivery speed |

---

## Key Analytical Findings

* **Category Capital Concentration:** **Electronics (PKR 223.3M)** and **Fashion (PKR 151.8M)** account for **56.9%** of total available stock value (**PKR 659.58M**), making category-level forecasting and stock turnover critical.
* **Warehouse Capacity Imbalance:** **Lahore Regional** operates at **91.4%** utilization near capacity limits, whereas **Multan (56.5%)** and **Faisalabad (57.8%)** hold spare storage capacity for stock rebalancing[cite: 4, 5].
* **Supplier Reliability vs. Spend:** **Al-Karam Textiles** leads major vendors with **91.1% OTD** and a **4.8-day** lead time on **PKR 59.40M** PO spend, whereas **Starlight Electronics** (**5.3% OTD**, **20.1 days** lead time) and **Capital Tech Distributors** (**10.5% OTD**, **28.9 days** lead time) pose major fulfillment risks[cite: 4, 5].
* **3PL Courier Performance:** **TCS Express (12.0% delay)** and **Trax (12.7% delay)** outperform **Pakistan Post Express (36.0% delay)** by nearly **3×** on timeliness, while monthly `MONTH(DispatchDate)` trends expose seasonal freight spikes[cite: 4, 5].

---

## Top vs. Risk Executive Snapshot

<details open>
<summary><strong>Click to expand / collapse Best-in-Class vs. High-Risk Highlights</strong></summary>

<br />

| Dimension | Best / Top Performer (Green) | Highest Risk / Bottleneck (Red) |
| :--- | :--- | :--- |
| **Inventory Category** | Electronics — **PKR 223.3M** (Largest stock value) | High-value stock lock requiring tight buffer control |
| **Supplier SLA & Lead** | Al-Karam Textiles — **91.1% OTD** (**4.8 days**) | Starlight Electronics — **5.3% OTD** (**20.1 days**) |
| **Warehouse Hub Load** | Multan (**56.5%**) & Faisalabad (**57.8%**) spare space | Lahore Regional — **91.4%** hub utilization |
| **3PL Courier Partner** | TCS Express — **12.0% delay** | Pakistan Post Express — **36.0% delay**[cite: 4, 5] |

</details>

---

## Repository Contents

<details open>
<summary><strong>View Project Files & Structure</strong></summary>

```text
supply_chain_inventory/
├── README.md                                          # Project documentation & executive summary
├── Supply_Chain_Inventory.pbix                        # Interactive Power BI dashboard
├── Supply_Chain_Inventory_Analysis_Walkthrough-v2.pptx# 9-slide presentation walkthrough
├── 01_schema_and_tables.sql                           # Raw & relational table definitions
├── 02_kpi_views.sql                                   # Pre-aggregated SQL KPI views
├── 03_analytics_queries.sql                           # Category, hub, vendor & 3PL queries
├── 04_reorder_and_risk_checks.sql                     # Low buffer & high-risk alert queries
└── *.csv                                              # Source dataset files (products, hubs, vendors, POs, logistics)[cite: 4, 5, 6, 7]
