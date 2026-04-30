# Sales Performance Dashboard

A beginner-level data analysis project I built to practice SQL, Python (pandas), and Power BI.

The dataset covers 46 orders placed across 4 regions of India during 2024. I created the dataset manually using Python and analysed it using SQL queries and a Power BI dashboard.

---

## What I Did

- Created a small sales dataset using Python with realistic fields like region, product, discount, payment method, and order status
- Cleaned the data using pandas — checked for nulls, fixed date formats, filtered delivered orders
- Wrote 10 SQL queries to find revenue by region, top products, monthly trends, and repeat customers
- Built a Power BI dashboard with bar charts, a line chart for monthly trends, and slicers for region and category

---

## Tools Used

- Python (pandas) — data creation and cleaning
- SQL (MySQL) — analysis queries
- Power BI — dashboard and visualization
- Excel — quick cross-checks
- GitHub — version control

---

## Project Structure

```
sales-dashboard/
├── data/
│   ├── sales_data.csv            # Raw dataset (46 orders)
│   └── sales_data_cleaned.csv    # Cleaned dataset with month column added
├── python/
│   ├── generate_data.py          # Script to create the dataset
│   └── analysis.py               # Cleaning and summary stats
├── sql/
│   └── queries.sql               # 10 SQL queries for analysis
├── screenshots/
│   └── (Power BI dashboard screenshots)
└── README.md
```

---

## Dataset Fields

| Column | Description |
|--------|-------------|
| order_id | Unique order number (ORD001 to ORD046) |
| order_date | Date of order (Jan–Dec 2024) |
| customer_id | Customer ID (C001–C015) |
| customer_name | Customer name |
| region | North / South / East / West |
| city | City of delivery |
| product_name | Product ordered |
| category | Electronics, Footwear, Fitness, etc. |
| unit_price | Original price (₹) |
| discount_pct | Discount applied (0%, 5%, 10%, 15%) |
| selling_price | Price after discount |
| quantity | Units ordered |
| revenue | Total amount for the order |
| payment_method | UPI / COD / Credit Card / Debit Card / Net Banking |
| order_status | Delivered / Returned / Cancelled |

---

## Key Findings

- **West region** had the highest revenue among delivered orders
- **Desk Lamp** and **Backpack** were the top revenue-generating products
- **October** was the best performing month
- **Net Banking** was the most used payment method
- Around 43% of orders were either returned or cancelled — which shows room for improvement in product quality or delivery

---

## How to Run

**Step 1 — Generate dataset**
```bash
pip install pandas
python python/generate_data.py
```

**Step 2 — Clean and explore**
```bash
python python/analysis.py
```

**Step 3 — SQL analysis**

Load `data/sales_data_cleaned.csv` into MySQL, then run `sql/queries.sql`

**Step 4 — Power BI**

Open Power BI Desktop → Get Data → CSV → load `sales_data_cleaned.csv` → build charts

---

## What I Learned

- How to structure a dataset for analysis
- Writing GROUP BY, HAVING, and JOIN queries in SQL
- Cleaning data with pandas (handling types, filtering rows)
- Building basic dashboards in Power BI with slicers

---

## Author

Baji Venkata Satya Krishna Kurra  
📧 bajikurra281@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/kurra-baji-krishna-b052b5367)
