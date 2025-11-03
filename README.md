# Sales Visits Data Pipeline (Bronze → Silver → Gold)

This project builds a small end-to-end analytics pipeline for sales visit data,
following a **multi-layered medallion architecture (Bronze → Silver → Gold)**.

The pipeline ingests raw CRM-like data, cleans and validates it, enriches it,
and models it into dimensional schema (facts & dimensions) to enable business
analytics such as customer visit behavior and product shortlisting patterns.

A conceptual star schema of the final **gold layer** can be found in:
`/Doc/data_model.png`.

---

## 📂 Project Structure

```
├── Doc/
│   ├── data_catalog.md          # Business-level description of the data model
│   ├── data_model.png           # Star schema of fact & dimensions
│
├── data/
│   ├── database_content.sql     # Raw source data used to populate the bronze layer
│   ├── database_structure.dbml  # DBML model describing schema relationships
│
├── scripts/
│   ├── bronze/
│   │   └── load_data.sql        # Loads raw data (Source → Bronze)
│   │
│   ├── silver/
│   │   ├── ddl_silver.sql       # DDL statements for silver tables
│   │   ├── proc_load_silver.sql # Cleansing + conforming transformation logic
│   │
│   ├── gold/
│   │   └── ddl_gold.sql         # Fact & Dimension star schema definitions
│   │
│   ├── init_db.sql          # Utility / initialization routines
│   ├── answer.sql           # Analytical queries on gold layer
│
├── tests/
│   ├── quality_checks_silver.sql # Data quality checks after cleansing
│   └── quality_checks_gold.sql   # Referential integrity & star schema checks
```

---

## 🔁 Medallion Pipeline Overview

| Layer  | Description                      | Goal                                |
| ------ | -------------------------------- | ----------------------------------- |
| Bronze | Raw ingestion from source tables | Preserve raw truth                  |
| Silver | Cleaned + standardized tables    | Ensure data quality and consistency |
| Gold   | Fact + Dimension model           | Enable business analytics           |

---

## 🧠 Business Questions Supported

This model allows answering questions like:

| Question                                                         | Insight                   |
| ---------------------------------------------------------------- | ------------------------- |
| What is the avg number of shortlisted products per client visit? | Product engagement        |
| Can we identify contacts who only visit their main company?      | Relationship strength     |
| Which watch family is most commonly shortlisted per company?     | Product preference trends |



---
