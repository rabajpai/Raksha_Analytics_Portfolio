# GCP Migration: SQL Performance Tuning & Automated Data Validation

## 1. Business Problem

In enterprise data warehouse migrations (e.g., from legacy systems like Teradata or Oracle to Google Cloud BigQuery), two of the most critical challenges are:

1.  **Performance Degradation:** Queries that performed well in the legacy system can become slow and expensive in the new cloud environment if not properly rewritten to leverage BigQuery's architecture (e.g., columnar storage, distributed processing).
2.  **Data Integrity:** Ensuring that data migrated to the new system is 100% accurate is non-negotiable, especially in regulated industries like finance. Manual checks are error-prone and do not scale.

This project simulates the type of work I perform daily, focusing on **translating, optimizing, and validating** SQL workloads for a large-scale cloud migration.

## 2. My Approach & Project Overview

To showcase a realistic migration workflow, I designed a three-part case study using a simulated e-commerce sales dataset.

-   **Part A: SQL Query Optimization:** I took a common business question ("What are the top-selling product categories per region, month-over-month?") and wrote it in a traditional, "legacy" Oracle SQL style. I then rewrote the query using BigQuery best practices, documenting the performance improvements.
-   **Part B: Data Validation Scripting:** I created a robust SQL script that uses a `FULL OUTER JOIN` to perform a full reconciliation between a "source" dataset and a "target" dataset, identifying any mismatches in aggregates like `SUM` and `COUNT`.
-   **Part C: Python Automation:** To automate this validation process, I developed a Python script that connects to a source (CSV) and a target (simulated database), runs the reconciliation logic, and generates a clean summary report. This reflects the automation work I lead to improve turnaround time for remediation deliverables.

## 3. Key Skills Demonstrated

| Skill Category                 | Specific Technologies & Techniques                                                              |
| ------------------------------ | ----------------------------------------------------------------------------------------------- |
| **Query Languages**            | Advanced SQL, Oracle SQL (simulated), Google BigQuery Standard SQL                               |
| **Query Optimization**         | Sargable predicates, CTE-driven logic, avoiding `SELECT *`, understanding columnar storage      |
| **Data Integrity & Validation**| `FULL OUTER JOIN`, aggregation reconciliation, hash-based comparison (conceptual)              |
| **Programming & Automation**   | Python, Pandas for data manipulation, SQLAlchemy for database connectivity                    |
| **Cloud & Database Platforms** | Google BigQuery concepts, SQL Server, Oracle (as source systems)                                |

## 4. How to Navigate This Project

1.  **Start with the SQL:** Review [`01_legacy_query_oracle.sql`](./01_legacy_query_oracle.sql) and then the optimized version in [`02_optimized_query_bigquery.sql`](./02_optimized_query_bigquery.sql). The comments in the files explain the "why" behind the changes.
2.  **Review the Validation Logic:** Open [`03_data_validation_query.sql`](./03_data_validation_query.sql) to see the core logic for reconciling datasets.
3.  **Run the Automation:** The Python script [`04_validation_automation.py`](./04_validation_automation.py) demonstrates how this process can be automated. See the script's docstring for run instructions.
