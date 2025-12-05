# ShopZada SQL Queries

This directory contains the SQL scripts used for the ETL (Extract, Transform, Load) process of the ShopZada application.

These queries serve as the backbone for the data pipeline defined in `shopzada.etl.yaml`, ensuring that data is correctly extracted, cleaned, and structured for analysis.

## File Overview

| Filename | Description |
| :--- | :--- |
| **`loading_tables.sql`** | Queries designed to extract raw data from the source database. These selects are typically used during the "Extract" phase. |
| **`schema_dims.sql`** | Defines the DDL (Data Definition Language) for **dimension tables**. Creates the necessary table structures to store descriptive attribute data. |
| **`schema_facts.sql`** | Defines the DDL for **fact tables**. Creates the structures for storing quantitative metrics and foreign keys. |
| **`clean_dims.sql`** | Transformation scripts for dimension data. Handles deduplication, null handling, and standardization of descriptive attributes. |
| **`clean_facts.sql`** | Transformation scripts for fact data. Ensures referential integrity, validates metrics, and cleans transactional records. |

## Usage

### 1. Automated Execution (ETL Pipeline)
These files are automatically referenced and executed by the `shopzada.etl.yaml` configuration during the standard ETL pipeline run. No manual intervention is required for normal operations.

### 2. Manual Execution (pgAdmin 4)
You can run these scripts independently for testing, debugging, or manual data patches using **pgAdmin 4** or any PostgreSQL client.

**Recommended Order of Execution:**
If rebuilding the data warehouse manually, execute the scripts in this specific order to respect dependencies:

1.  **`clean_dims.sql`** (Populate/Clean dimensions)
2.  **`clean_facts.sql`** (Populate/Clean facts)
3.  **`schema_dims.sql`** (Create dimension structures first)
4.  **`schema_facts.sql`** (Create fact structures that may reference dimensions)

**How to run in pgAdmin 4:**
1.  Open pgAdmin 4 and connect to your target database.
2.  Open the **Query Tool**.
3.  Open the desired `.sql` file from this directory.
4.  Select the specific query block you wish to run (if the file contains multiple statements) or run the entire script using the **Execute** button (Play icon / F5).

