"""
data_cleaning.py
Loads the raw sales dataset, cleans it, and produces summary statistics.
Run this before any SQL or BI analysis.
"""

import pandas as pd

# ── Load ──────────────────────────────────────────────────────────
df = pd.read_csv("data/sales_data.csv")
print(f"Raw dataset: {df.shape[0]} rows, {df.shape[1]} columns")

# ── 1. Check for nulls ───────────────────────────────────────────
print("\nNull values per column:")
print(df.isnull().sum())

# ── 2. Check for duplicates ──────────────────────────────────────
dupes = df.duplicated(subset="order_id").sum()
print(f"\nDuplicate order_ids: {dupes}")
df.drop_duplicates(subset="order_id", inplace=True)

# ── 3. Fix data types ─────────────────────────────────────────────
df["order_date"] = pd.to_datetime(df["order_date"])
df["year"]       = df["order_date"].dt.year
df["month"]      = df["order_date"].dt.month
df["month_name"] = df["order_date"].dt.strftime("%b")

# ── 4. Filter only delivered orders for revenue analysis ─────────
delivered = df[df["order_status"] == "Delivered"].copy()
print(f"\nDelivered orders: {len(delivered)} ({len(delivered)/len(df)*100:.1f}%)")

# ── 5. Summary Statistics ─────────────────────────────────────────
print("\n── Revenue by Region ──")
region_rev = delivered.groupby("region")["revenue"].sum().sort_values(ascending=False)
print(region_rev.apply(lambda x: f"₹{x:,.0f}"))

print("\n── Top 5 Products by Revenue ──")
top_products = (delivered.groupby("product_name")["revenue"]
                .sum().sort_values(ascending=False).head(5))
print(top_products.apply(lambda x: f"₹{x:,.0f}"))

print("\n── Monthly Revenue Trend (2024) ──")
monthly = (delivered[delivered["year"] == 2024]
           .groupby(["month", "month_name"])["revenue"]
           .sum().reset_index()
           .sort_values("month"))
for _, row in monthly.iterrows():
    print(f"  {row['month_name']}: ₹{row['revenue']:,.0f}")

print("\n── Payment Method Distribution ──")
payment_dist = df["payment_method"].value_counts(normalize=True) * 100
print(payment_dist.apply(lambda x: f"{x:.1f}%"))

print("\n── Customer Churn Signal (single-order customers) ──")
order_counts   = df.groupby("customer_id")["order_id"].count()
single_buyers  = (order_counts == 1).sum()
repeat_buyers  = (order_counts > 1).sum()
print(f"  Single-order customers : {single_buyers} ({single_buyers/len(order_counts)*100:.1f}%)")
print(f"  Repeat customers       : {repeat_buyers} ({repeat_buyers/len(order_counts)*100:.1f}%)")

# ── 6. Save cleaned file ──────────────────────────────────────────
df.to_csv("data/sales_data_cleaned.csv", index=False)
print(f"\nCleaned dataset saved → data/sales_data_cleaned.csv")
