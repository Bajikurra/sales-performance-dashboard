import pandas as pd

# Load the dataset
df = pd.read_csv("data/sales_data.csv")

print("=== Dataset Overview ===")
print(f"Total Orders  : {len(df)}")
print(f"Columns       : {list(df.columns)}")
print(f"Date Range    : {df['order_date'].min()} to {df['order_date'].max()}")
print()

# Check for missing values
print("=== Missing Values ===")
print(df.isnull().sum())
print()

# Fix data types
df["order_date"] = pd.to_datetime(df["order_date"])
df["month"]      = df["order_date"].dt.month
df["month_name"] = df["order_date"].dt.strftime("%b")

# Keep only delivered orders for revenue analysis
delivered = df[df["order_status"] == "Delivered"].copy()
print(f"Delivered Orders : {len(delivered)} out of {len(df)}")
print(f"Returned/Cancelled : {len(df) - len(delivered)}")
print()

# Revenue by Region
print("=== Revenue by Region ===")
region_rev = delivered.groupby("region")["revenue"].sum().sort_values(ascending=False)
for region, rev in region_rev.items():
    print(f"  {region}: ₹{rev:,.2f}")
print()

# Top products
print("=== Top Products by Revenue ===")
top = delivered.groupby("product_name")["revenue"].sum().sort_values(ascending=False).head(5)
for prod, rev in top.items():
    print(f"  {prod}: ₹{rev:,.2f}")
print()

# Monthly revenue
print("=== Monthly Revenue ===")
monthly = delivered.groupby(["month","month_name"])["revenue"].sum().reset_index().sort_values("month")
for _, row in monthly.iterrows():
    print(f"  {row['month_name']}: ₹{row['revenue']:,.2f}")
print()

# Payment method
print("=== Payment Methods ===")
pay = df["payment_method"].value_counts()
for method, count in pay.items():
    print(f"  {method}: {count} orders")
print()

# Save cleaned file
df.to_csv("data/sales_data_cleaned.csv", index=False)
print("Cleaned file saved to data/sales_data_cleaned.csv")
