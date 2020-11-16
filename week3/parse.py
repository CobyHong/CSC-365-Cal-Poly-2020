import csv

# with open('customers.csv') as csvfile:
#    reader = csv.reader(csvfile)
#    for row in reader:
#       print(f"INSERT INTO customers (CId, Lastname, Firstname) VALUES ({row[0]}, '{row[1].strip()}', '{row[2].strip()}');")


# with open('goods.csv') as csvfile:
#    reader = csv.reader(csvfile)
#    for row in reader:
#       print(f"INSERT INTO goods (GId, Flavor, Food, Price) VALUES ('{row[0].strip()}', '{row[1].strip()}', '{row[2].strip()}', {row[3]});")


# with open('items.csv') as csvfile:
#    reader = csv.reader(csvfile)
#    for row in reader:
#       print(f"INSERT INTO items (Receipt, Ordinal, Item) VALUES ({row[0]}, {row[1]}, '{row[2].strip()}');")
 
 
with open('vgsales2.csv') as csvfile:
   reader = csv.reader(csvfile)
   for row in reader:
      print(f"INSERT INTO games (Ranking, Name, Year) VALUES ({row[0]}, '{row[1].strip()}', {row[3]});")

print()
print()
print()

with open('vgsales2.csv') as csvfile:
   reader = csv.reader(csvfile)
   for row in reader:
      print(f"INSERT INTO publishers (Ranking, PName) VALUES ({row[0]}, '{row[5].strip()}');")

print()
print()
print()

with open('vgsales2.csv') as csvfile:
   reader = csv.reader(csvfile)
   for row in reader:
      print(f"INSERT INTO sales (Ranking, Name, PName, US_Sales, EU_Sales, JP_Sales, GL_sales) VALUES ({row[0]}, '{row[1].strip()}', '{row[5].strip()}', {row[6]}, {row[7]}, {row[8]}, {row[10]});")
 