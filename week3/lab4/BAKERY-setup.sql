DROP TABLE IF EXISTS receipts;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS goods;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  CId integer PRIMARY KEY,
  Lastname varchar(100),
  Firstname varchar(100)
);

CREATE TABLE goods (
  GId varchar(100) PRIMARY KEY,
  Flavor varchar(100),
  Food varchar(100),
  Price DECIMAL(7,2),
  UNIQUE(Flavor, Food)
);

CREATE TABLE items (
  Receipt integer,
  Ordinal integer,
  Item varchar(100),
  PRIMARY KEY(Receipt, Ordinal)
);

CREATE TABLE receipts (
  RNumber integer,
  Customer integer,
  SaleDate DATE
);