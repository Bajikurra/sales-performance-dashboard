# Power BI Dashboard — Setup Guide

## Data Source
Connect Power BI to: `data/sales_data_cleaned.csv`

---

## Steps to Build the Dashboard

### 1. Load Data
- Open Power BI Desktop
- Click **Get Data → Text/CSV**
- Select `data/sales_data_cleaned.csv`
- Click **Transform Data**

### 2. Power Query Transformations
- Change `order_date` column type → **Date**
- Change `revenue`, `selling_price`, `unit_price` → **Decimal Number**
- Add custom column: `Month-Year` = `Date.ToText([order_date], "MMM yyyy")`
- Filter rows where `order_status = "Delivered"` for revenue visuals

### 3. DAX Measures (Create these in the Model view)

```dax
-- Total Revenue
Total Revenue = SUM(sales[revenue])

-- Total Orders
Total Orders = COUNTROWS(sales)

-- Average Order Value
Avg Order Value = DIVIDE([Total Revenue], [Total Orders])

-- Delivered Revenue
Delivered Revenue =
    CALCULATE(SUM(sales[revenue]), sales[order_status] = "Delivered")

-- Return Rate %
Return Rate % =
    DIVIDE(
        CALCULATE(COUNTROWS(sales), sales[order_status] = "Returned"),
        COUNTROWS(sales)
    ) * 100

-- MoM Revenue Change %
MoM Change % =
    VAR CurrentMonth = [Total Revenue]
    VAR PrevMonth =
        CALCULATE([Total Revenue], DATEADD(sales[order_date], -1, MONTH))
    RETURN DIVIDE(CurrentMonth - PrevMonth, PrevMonth) * 100
```

### 4. Dashboard Pages & Visuals

#### Page 1 — Executive Summary
| Visual | Fields |
|--------|--------|
| KPI Card | Total Revenue |
| KPI Card | Total Orders |
| KPI Card | Avg Order Value |
| KPI Card | Return Rate % |
| Bar Chart | Revenue by Region |
| Donut Chart | Order Status Breakdown |

#### Page 2 — Product & Category Analysis
| Visual | Fields |
|--------|--------|
| Clustered Bar | Revenue by Product Name (Top 10) |
| Treemap | Revenue by Category |
| Table | Product Name, Units Sold, Revenue, Return Rate |
| Slicer | Category |

#### Page 3 — Time Trend Analysis
| Visual | Fields |
|--------|--------|
| Line Chart | Monthly Revenue (2023 vs 2024) |
| Area Chart | Running Total Revenue |
| Bar Chart | Revenue by Month |
| Slicer | Year |

#### Page 4 — Customer Insights
| Visual | Fields |
|--------|--------|
| Bar Chart | Revenue by Payment Method |
| Map | Revenue by City |
| Table | Top 10 Customers by Lifetime Value |
| KPI Card | Unique Customers |

### 5. Formatting Tips
- Theme: **Executive** (built-in Power BI theme)
- Add slicers for: Region, Year, Category, Order Status
- Enable **drill-through** on product visuals to see order-level detail
- Add **tooltips** showing Avg Discount % on revenue visuals
