DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS airports;
DROP TABLE IF EXISTS airlines;


CREATE TABLE airlines (
  Id integer PRIMARY KEY,
  Airline varchar(100),
  Abbreviation varchar(50),
  Country varchar(50),
  UNIQUE(Abbreviation)
);

CREATE TABLE airports (
  City varchar(100),
  AirportCode varchar(3) PRIMARY KEY,
  AirportName varchar(100),
  Country varchar(50),
  CountryAbbrev varchar(50),
  UNIQUE(AirportCode)
);

CREATE TABLE flights (
  Airline integer,
  FlightNo integer,
  SourceAirport varchar(3) NOT NULL,
  DestAirport varchar(3) NOT NULL,
  PRIMARY KEY(Airline, FlightNo),
  foreign key (Airline) references airlines (Id),
  foreign key (SourceAirport) references airports (AirportCode),
  foreign key (DestAirport) references airports (AirportCode)
);