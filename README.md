# Zepto-SQL-DataAnalyst-Project
🛒 Zepto, startup E-commerce company in India, SQL Data Analyst Project.

---
## Project Overview
The goal is to simulate how data analysts work behind the scenes in e-commerce or retail environments to use SQL for setting up inventory databases, performing exploratory data analysis, cleaning messy records, and deriving actionable business insights.  

## 📁 Dataset Overview
The dataset was sourced from Kaggle and was originally scraped from Zepto’s official product listings. It mimics what you’d typically encounter in a real-world e-commerce inventory system.

Each row represents a unique SKU (Stock Keeping Unit) for a product. Duplicate product names exist because the same product may appear multiple times in different package sizes, weights, discounts, or categories to improve visibility – exactly how real catalog data looks.
Columns:
- sku_id: Unique identifier for each entry (Auto-increment primary key)  
- category: Product category  name: Product name
- mrp: Maximum Retail Price
- discountPercent: Percentage discount applied
- availableQuantity: Units available in stock
- discountedSellingPrice: Final price after discount
- weightInGms: Product weight in grams
- outOfStock: Boolean flag for availability
- quantity: Number of units per package

## 🔧 Project Workflow
1. Database & Table Creation
Initialized the MySQL database environment and structured the inventory table with matching data types:
```sql
CREATE DATABASE zepto_sql_project; 
USE zepto_sql_project;

CREATE TABLE zepto ( 
    sku_id INT AUTO_INCREMENT PRIMARY KEY, 
    category VARCHAR(120), 
    name VARCHAR(150) NOT NULL, 
    mrp NUMERIC(8,2), 
    discountPercent NUMERIC(4,2), 
    availableQuantity INT, 
    discountedSellingPrice NUMERIC(8,2), 
    weightInGms INT, 
    outOfStock BOOLEAN, 
    quantity INT 
);
```
## 2. 🔍 Data Exploration
Conducted foundational queries to inspect the data health and shape:
- Counted total rows and pulled sample views.
- Screened for null values across mandatory fields.
- Extracted distinct categories and analyzed stock distribution levels.
- Detected multi-SKU occurrences for duplicate product names.

## 3. 🧹 Data Cleaning
- Anomaly Removal: Identified and deleted records where the MRP or discounted selling price was mistakenly tagged as zero.
- Currency Normalization: Converted monetary attributes from Indian paisa to rupees using a baseline division by 100.

## 4. 📊 Business Insights & Queries
- Top 10 Best Value Products: Queried highest discount percentages to surface high-saving items.
  <img width="551" height="242" alt="image" src="https://github.com/user-attachments/assets/6c675f2b-6300-40ac-b1f6-8e964e2462fe" />

- Missed Revenue Opportunities: Filtered out-of-stock items possessing an MRP higher than the average catalog price.
  <img width="622" height="347" alt="image" src="https://github.com/user-attachments/assets/86e40198-b04f-4ce7-b40f-64f8add1cf52" />

- Category Revenue Estimation: Calculated potential revenue generation per category using selling price and available stock.
  <img width="287" height="337" alt="image" src="https://github.com/user-attachments/assets/49c2692b-06c7-48e2-b44d-878023c8ea62" />

- Premium Low-Discount Items: Isolated products priced over ₹500 carrying less than a 10% discount to evaluate organic demand.
  <img width="662" height="540" alt="image" src="https://github.com/user-attachments/assets/f6d34a39-d1a3-43bb-a6da-4e1bec8c603d" />

- Top Average Discount Categories: Ranked top 5 categories by average discount percentage.
  <img width="420" height="170" alt="image" src="https://github.com/user-attachments/assets/168236f2-1093-4c2b-b865-79053999ff11" />

- Price Per Gram Analysis: Computed value-for-money metrics for items weighing above 100 grams.
  <img width="615" height="592" alt="image" src="https://github.com/user-attachments/assets/0d794abd-692f-4618-ba40-92929cb88c0c" />

- Weight Segmentation: Grouped products into Light, Medium, and Bulky brackets via conditional case logic to assist delivery planning.
  <img width="682" height="572" alt="image" src="https://github.com/user-attachments/assets/b11c58f5-5ea4-46c3-8898-fa38898348a4" />

- Total Inventory Weight: Aggregated total stock weight per category for warehouse storage design.
  <img width="462" height="375" alt="image" src="https://github.com/user-attachments/assets/bc3975b0-9755-4295-b842-ad1608a8a0ef" />

