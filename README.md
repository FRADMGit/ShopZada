# ShopZada Data Warehouse Project

## 1. Overview

### **Project Context**

ShopZada is a global e-commerce platform experiencing rapid growth, processing over 500,000 orders and 2 million line items across diverse product categories. As the company expanded, data became fragmented across multiple departments including Business, Customer Management, Enterprise, Marketing, and Operations, making unified analysis challenging.

### **Tech Stack**
|  Task       | Technology | Purpose |
|-------------------|-----------|---------|
| **Data Storage**   | PostgreSQL | Centralized database for staging, warehouse, and presentation layers |
| **ETL / ELT Orchestration** | Kestra | Automates extraction, transformation, and loading workflows |
| **Data Processing** | Python (pandas) | Cleans, integrates, and transforms raw datasets |
| **Data Modeling**   | SQL (PostgreSQL) | Implements dimensional modeling (star schema) for fact and dimension tables |
| **Analytics / Reporting** | SQL Views / Tableau | Provides analytical-ready datasets for dashboards and reports |

### **Workflow Overview**
1.  **Data Extraction**
* Raw data files (CSV, JSON, Excel, etc.) are collected and flattened from source archives.
* Python scripts parse and standardize these files.

2. **Data Cleaning & Staging**
* Individual datasets are cleaned for missing or inconsistent values.
* Staging tables mirror raw data in a structured, queryable format.

3. **Data Warehouse Construction**
* Dimension tables (users, products, merchants, staff, campaigns) are created first.
* Fact tables (orders, line items) reference these dimensions to form a **star schema**.
* Unknown or missing references are handled with default fallback entries to maintain **referential integrity**.

4. **Presentation Layer & Analytics**
* Views and curated tables are created for analytics and reporting.
* Supports downstream visualization or business intelligence tools.

5. **Automation & Orchestration**
* Kestra flows schedule and execute the full pipeline: extract → clean → transform → load.
* Ensures consistent, reproducible, and timely updates to the Data Warehouse.

### **Key Features**
* Automated Pipelines: Python scripts and Kestra orchestration handle extraction, transformation, and loading of data.
* Dimensional Modeling: Star schema design with dimension tables (users, products, merchants, staff, campaigns) and fact tables (orders, line items).
* Data Quality: Unknown and missing values are handled consistently to maintain referential integrity.
* Analytics-Ready: Ready-to-use datasets for visualization, reporting, and advanced analytics.
By centralizing and standardizing ShopZada’s data, this project enables insightful analytics, improves operational efficiency, and supports strategic decision-making at scale.
---

## 2. Setup Guide

Follow these steps to run the full pipeline locally using Docker and Kestra.

### **a. Install Docker Desktop**

Download and install Docker Desktop for your system:

* Windows: [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
* Mac: [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
* Linux: [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)

Ensure Docker Desktop is running before continuing.

### **b. Clone the Repository**

```bash
git clone https://github.com/FRADMGit/dwh_finalproject_3DSA_group_6.git
cd dwh_finalproject_3DSA_group_6
```

### **c. Start the Services**

Run the entire data warehouse stack (PostgreSQL, Kestra, etc.):

```bash
docker compose up -d
```

Wait until all containers finish initializing.

### **d. Open Kestra UI**

Go to:

```
http://localhost:8080
```

Login using the provided credentials:

* **Email:** `admin@kestra.io`
* **Name:** `kestra`
* **Last Name:** `kestra`
* **Password:** `k3str4`

### **e. Run the Main ELT Flow**

Inside Kestra, find and run the flow named: `elt`

This triggers the pipeline:

1. Extract raw files
2. Clean and transform staging tables
3. Build dimension and fact tables
4. Load data into the presentation layer

---