# Retail-Sales-Analysis-SQL-Project

## 📌 Project Overview

#### Project Title: Retail Sales Analysis

This project focuses on performing an end-to-end exploratory data analysis (EDA) and business intelligence reporting on a retail sales dataset. The dataset consists of **2,000** transaction records spanning two years **(2022 – 2023)**, including detailed information about customers (age, gender), products (categories, quantities, price per unit), and financials (COGS, total sales).Transformed raw sales data into strategic recommendations for inventory, staffing, and marketing optimization using PostgreSQL for data manipulation and querying. It covers the essential stages of the data lifecycle: **Data Cleaning, Exploratory Data Analysis (EDA), and Business Question Solving.**

### 🎯 Objectives
The primary goal is to demonstrate the ability to transform raw data into business intelligence. Specific objectives include:
1. **Data Integrity & Cleaning:** Identify and handle missing (null) values and ensure data types are correctly formatted for high-accuracy calculations.
2. **Trend Identification:** Analyze sales patterns over time (monthly, daily, and hourly) to pinpoint peak performance periods and seasonal surges.
3. **Customer Segmentation:** Understand the demographic makeup of the customer base (age and gender) and determine how different groups contribute to total revenue.
4. **Product Performance Analysis:** Evaluate the three core categories **Clothing, Beauty, and Electronics** to see which drives the most volume versus which drives the most profit.
5. **Profitability Assessment:** Calculate the **Cost of Goods Sold (COGS) against Total Sales** to determine the net profit and gross margin for the business.
6. **Actionable Reporting:** Answer specific business questions (e.g., "What is the peak sales time?") to help management optimize staffing, marketing spend, and inventory levels.

### Dataset Structure
To achieve these objectives, the following data points are utilized:
1. **Transaction Details:** transactions_id, sale_date, sale_time.
2. **Customer Demographics:** customer_id, gender, age.
3. **Product Information:** category, quantity, price_per_unit.
4. **Financials:** cogs (Cost of Goods Sold), total_sale.

### 🛠️ Technologies Used
- **Database:** PostgreSQL
- **Tools:** pgAdmin / SQL Editor
- **Techniques:** Data Cleaning, EDA, Aggregations, Window Functions, CASE statements

📊 Key Insights & Findings
1. **Sales Performance & Trends**
* **Total Revenue & Profitability**: Over the 24-month period (Jan 2022 – Dec 2023), the business processed 1,987 valid transactions, generating a total revenue of $908,230.00 and a net profit of $719,302.20. This indicates a high-margin operation (approx. 79% gross margin).
* **The "September Surge":**  Analysis reveals a massive seasonal anomaly in September. Sales remain relatively stagnant through August (~$49k) before skyrocketing to $129,180 in September a 162% month-over-month increase. This suggests a strong correlation with "Back-to-School" shopping or a major seasonal product launch.
* **Seasonal Peaks:** December is the top-performing month ($141,025), likely driven by holiday gifting. Conversely, February is the slowest month ($41,280), identifying a clear window for clearance sales or loyalty promotions to bridge the revenue gap.
* **Daily & Hourly Traffic:** Sundays are the peak revenue days ($152,800), while Tuesdays represent the weekly low ($102,845).
* Evening (After 5 PM) is the most critical time-block, accounting for 1, 062 transactions (64% of total volume), followed by a sharp drop-off in the Afternoon (only 377 transactions).
* **Efficiency Metric (ATV):** The Average Transaction Value (ATV) is $457.09. This is a high benchmark for retail, suggesting that customers are either buying premium units or multiple items per visit.

2. **Product & Category Performance**
* **Revenue vs. Profit Leaders:** While Electronics generated the highest total revenue ($311,445), Clothing proved to be the more valuable category for the bottom line, yielding the highest total profit ($245,945.25).
* **Buying Patterns by Category:**
  *Clothing:* High-volume category with an average of 2.55 items per basket. Customers tend to purchase multiple garments in a single trip.
  *Electronics:* Low-frequency but high-value. Most items are bought singularly (Avg 2.48), indicating a "destination" purchase style rather than impulse buying.
* **Premium Price Resilience:** The Data refutes the assumption that lower prices drive more volume. While $50 items sold the most units (1,067), the $300 price point significantly outperformed the $30 price point (1,036 units vs 876 units). This suggests the brand has strong "Premium Authority" customers are willing to pay more for higher-tier products in this catalog.

3. **Customer Demographics**
* **Gender Spend Dynamics:** Females are the primary drivers of revenue, spending $463,110 compared to $445,120 for Males.
    *Females:* Heavily favor Clothing ($162k) and Beauty ($149k).
    *Males:* Dominant in the Electronics category ($160k).
* **Age-Group Segmentation:**
    *Under 30:* Highly focused on Clothing. This is the "Trend-Driven" segment.
    *30–50 (The "Power" Segment):* This group shows the most balanced spending across all categories, with a particular focus on Beauty and Clothing.
    *Over 50:* Shows a high preference for Electronics and premium items, representing the highest individual purchasing power.
* **Retention & Loyalty:** A small core of "Power Users" (Customer IDs 3 and 1) visited the store 76 times each over two years. These customers are vital for the brand's stability and should be the focus of tiered loyalty rewards.

💡 Strategic Recommendations
1. Operational Staffing & Efficiency
* The "Evening Shift" Focus: Since 64% of sales happen in the evening, staffing should be increased between 5:00 PM and closing to ensure customer satisfaction and prevent long checkout queues.
* The "Afternoon Pivot": With the lowest transaction counts occurring in the afternoon (12 PM – 5 PM), this time-block should be strictly dedicated to Inventory Management, Shelf Restocking, and Store Audits to prepare for the evening rush.
2. Marketing & Category Growth
* Under-30 Electronics Push: Electronics is currently the lowest-purchased category for customers under 30. A targeted social media campaign (e.g., student tech essentials) could tap into this underserved market.
* Bundling Strategy: Since Beauty is the lowest-performing category for both genders, implement a "Lifestyle Bundling" strategy. Market Beauty products as "add-ons" to Clothing purchases for women and Grooming essentials with Electronics for men.
3. Inventory Management (Stocking Plan)
To prepare for the documented "September Surge," the following phased ordering is recommended:
* July/August: Aggressively scale inventory levels for Electronics and Clothing.
* September: Peak inventory availability; eliminate any out-of-stock scenarios.
* November: Shift focus to Beauty Gifting Sets and Premium Electronics for the December holiday peak.
* January: Aggressive markdown on slow-moving inventory to clear space for Q1 arrivals.

#### Why This Matters
By identifying the September Surge and the Evening Peak, the business can effectively reduce labor waste in the mornings and avoid missed revenue opportunities during high-traffic windows. The data proves that profitability is driven by the Clothing category and Female shoppers, providing a clear roadmap for future ad spend.

#### 💻 Sample Queries
Here are a few "teaser" queries used to achieve the data above.
Query 1: Finding the Peak Sales Shift
I categorized the sale_time into three shifts to identify when the store is busiest.

```sql
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY shift
ORDER BY total_orders DESC;
```
Query 2: Calculating which category actually makes the most money after costs.

```sql
SELECT 
    category,
    SUM(total_sale) AS total_revenue,
    SUM(total_sale - cogs) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;
```

📂 **Full Analysis**
For complete data cleaning steps, trend analysis, and customer segmentation queries:
👉 [View Complete SQL File](retail_sales_analysis.sql)

#### 🏁 Conclusion
This project successfully demonstrates how data-driven decisions can optimize a retail business. By identifying the September sales surge and evening peak hours, the business can better allocate resources and inventory to maximize profitability.

## 👤 About Me
I'm a data analyst passionate about turning data into actionable insights. Connect with me:
- 💼 [LinkedIn](https://www.linkedin.com/in/mwangi-teresia/)

*This project is part of my portfolio showcasing SQL, data analysis, and business intelligence skills.*
