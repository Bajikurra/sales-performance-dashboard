import pandas as pd
import random
from datetime import date

random.seed(10)

products = [
    ("Wireless Earbuds",  "Electronics",  1299),
    ("Smartphone Case",   "Accessories",   299),
    ("Running Shoes",     "Footwear",     2499),
    ("Yoga Mat",          "Fitness",       799),
    ("Laptop Stand",      "Electronics",  1599),
    ("Water Bottle",      "Lifestyle",     399),
    ("Backpack",          "Bags",         1899),
    ("Bluetooth Speaker", "Electronics",  2199),
    ("Notebook Set",      "Stationery",    249),
    ("Desk Lamp",         "Home",         1099),
]

regions = {
    "North": ["Delhi",     "Chandigarh"],
    "South": ["Bangalore", "Chennai"],
    "East":  ["Kolkata",   "Patna"],
    "West":  ["Mumbai",    "Pune"],
}

customers = [
    ("C001","Ravi Kumar"),   ("C002","Sneha Patel"),  ("C003","Arjun Singh"),
    ("C004","Priya Reddy"),  ("C005","Amit Sharma"),  ("C006","Deepa Nair"),
    ("C007","Rahul Gupta"),  ("C008","Meera Iyer"),   ("C009","Vikram Shah"),
    ("C010","Anjali Mehta"), ("C011","Kiran Das"),    ("C012","Neha Rao"),
    ("C013","Gaurav Verma"), ("C014","Divya Joshi"),  ("C015","Sachin Pillai"),
]

payments = ["UPI", "Credit Card", "Debit Card", "COD", "Net Banking"]
statuses = ["Delivered", "Delivered", "Delivered", "Returned", "Cancelled"]

# Manually listed dates — spread across Jan-Dec 2024
dates = [
    date(2024,1,5),  date(2024,1,12), date(2024,1,20), date(2024,1,28),
    date(2024,2,3),  date(2024,2,11), date(2024,2,19), date(2024,2,25),
    date(2024,3,2),  date(2024,3,10), date(2024,3,18), date(2024,3,26),
    date(2024,4,4),  date(2024,4,13), date(2024,4,21), date(2024,4,29),
    date(2024,5,6),  date(2024,5,14), date(2024,5,22), date(2024,5,30),
    date(2024,6,7),  date(2024,6,15), date(2024,6,23), date(2024,6,30),
    date(2024,7,8),  date(2024,7,16), date(2024,7,24),
    date(2024,8,1),  date(2024,8,9),  date(2024,8,17), date(2024,8,25),
    date(2024,9,3),  date(2024,9,11), date(2024,9,19), date(2024,9,27),
    date(2024,10,5), date(2024,10,13),date(2024,10,21),date(2024,10,29),
    date(2024,11,6), date(2024,11,14),date(2024,11,22),date(2024,11,30),
    date(2024,12,8), date(2024,12,16),date(2024,12,24),
]

rows = []
for i, d in enumerate(dates):
    cid, cname        = random.choice(customers)
    reg               = random.choice(list(regions.keys()))
    city              = random.choice(regions[reg])
    pname, cat, price = random.choice(products)
    qty               = random.randint(1, 3)
    disc              = random.choice([0, 0, 5, 10, 15])
    sell              = round(price * (1 - disc / 100), 2)
    revenue           = round(sell * qty, 2)

    rows.append({
        "order_id":       f"ORD{i+1:03d}",
        "order_date":     d.strftime("%Y-%m-%d"),
        "customer_id":    cid,
        "customer_name":  cname,
        "region":         reg,
        "city":           city,
        "product_name":   pname,
        "category":       cat,
        "unit_price":     price,
        "discount_pct":   disc,
        "selling_price":  sell,
        "quantity":       qty,
        "revenue":        revenue,
        "payment_method": random.choice(payments),
        "order_status":   random.choice(statuses),
    })

df = pd.DataFrame(rows)
df.to_csv("data/sales_data.csv", index=False)
print(f"Saved {len(df)} orders to data/sales_data.csv")
