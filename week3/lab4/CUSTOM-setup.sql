DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS publishers;
DROP TABLE IF EXISTS games;

CREATE TABLE games (
    Ranking integer,
    Name varchar(100),
    Year integer,
    primary key(Ranking)
);

CREATE TABLE publishers (
    Ranking integer,
    PName varchar(100),
    UNIQUE(PName),
    foreign key (Ranking) references games (Ranking),
    primary key(Pname)
);

CREATE TABLE sales (
    Ranking integer,
    Name varchar(100),
    PName varchar(100),
    US_Sales decimal(7,2),
    EU_Sales decimal(7,2),
    JP_Sales decimal(7,2),
    GL_Sales decimal(7,2),
    foreign key (Ranking) references games (Ranking),
    foreign key (PName) references publishers (PName)
);