# Power BI: Global Electronic Retailer Performance Report

## 1. Business Problem
The "Global Electronics Retailer" was struggling to consolidate its worldwide sales data. Stakeholders lacked a unified view of key performance indicators (KPIs), making it difficult to identify regional trends, compare period-over-period performance, and make data-driven decisions regarding inventory and marketing. 

The goal of this project was to build an interactive, secure, and highly performant Power BI report that acts as a single source of truth for global sales performance.

## 2. My Solution & Technical Approach
I developed a comprehensive, interactive Power BI report that consolidates sales data, enabling stakeholders to run what-if scenarios and drill into regional details with just a few clicks. 

Key technical achievements include:
- **Data Transformation & Modeling:** Utilized Power Query for robust data cleaning and ETL. Built a star-schema data model to ensure optimal performance and scalability.
- **Advanced DAX Measures:** Engineered custom DAX measures for sales, profit, and quantity, ensuring accurate, context-aware calculations (e.g., YoY growth and active customer counts).
- **Geo-Visualization:** Integrated custom maps by converting a GeoJSON/Shapefile to TopoJSON via MapShaper, implementing it into Power BI's Shape Map for a crisp, custom regional view.
- **Interactive Storytelling:** Developed a Drill-through Tree Map that allows users to click a category and instantly see detailed customer-level insights on a dedicated page.
- **Data Governance & Security:** Implemented Role-Level Security (RLS) to ensure US personnel only have access to their specific regions. 
- **Performance Optimization:** Set up Incremental Refresh for the last 90 days of data, with the past 12 months archived, drastically reducing refresh times.

## 3. Business Impact
- **Actionable Insights:** The tailored visual storytelling turns complex numbers into intuitive, at-a-glance insights, helping leadership identify underperforming regions instantly.
- **Accessibility:** A responsive, clean layout ensures the report works flawlessly on both desktop and mobile, making insights accessible wherever the user is.
- **Efficiency:** The SQL Server connection and incremental refresh strategy ensure the report remains fast and reliable, even as the global dataset grows.
