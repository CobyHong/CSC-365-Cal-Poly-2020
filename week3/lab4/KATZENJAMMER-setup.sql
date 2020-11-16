DROP TABLE IF EXISTS Tracklists;
DROP TABLE IF EXISTS Vocals;
DROP TABLE IF EXISTS Instruments;
DROP TABLE IF EXISTS Performance;
DROP TABLE IF EXISTS Band;
DROP TABLE IF EXISTS Songs;
DROP TABLE IF EXISTS Albums;

CREATE TABLE Albums(
    AId integer PRIMARY KEY,
    Title varchar(100),
    Year integer,
    Label varchar(100),
    `Type` varchar(100)
);

CREATE TABLE Band(
    Id integer PRIMARY KEY,
    Firstname varchar(100),
    Lastname varchar(100)
);

CREATE TABLE Songs(
    SongId integer PRIMARY KEY, 
    Title varchar(100)
);


CREATE TABLE Instruments(
    SongId integer,
    BandmateId integer,
    Instrument varchar(100),
    PRIMARY KEY (SongId, BandmateId, Instrument),
    foreign key (SongId) references Songs (SongId),
    foreign key (BandmateId) references Band (Id)
);

CREATE TABLE Performance(
    SongId integer,
    Bandmate integer,
    StagePosition varchar(100),
    PRIMARY KEY (SongId, Bandmate),
    foreign key (SongId) references Songs (SongId),
    foreign key (Bandmate) references Band (Id)
);

CREATE TABLE Tracklists(
    AlbumId integer,
    Position integer,
    SongId integer,
    foreign key (AlbumId) references Albums (AId),
    foreign key (SongId) references Songs (SongId)
);

CREATE TABLE Vocals(
    SongId integer,
    Bandmate integer,
    `Type` varchar(100),
    foreign key (SongId) references Songs (SongId),
    foreign key (Bandmate) references Band (Id)
);