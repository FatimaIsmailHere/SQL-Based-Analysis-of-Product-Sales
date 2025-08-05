Chinook Music Store — Database Schema

--  Artists Table
CREATE TABLE Artist (
    ArtistId INTEGER PRIMARY KEY,
    Name VARCHAR(120)
);

--  Albums Table
CREATE TABLE Album (
    AlbumId INTEGER PRIMARY KEY,
    Title VARCHAR(160),
    ArtistId INTEGER REFERENCES Artist(ArtistId)
);

--  Customers Table
CREATE TABLE Customer (
    CustomerId INTEGER PRIMARY KEY,
    FirstName VARCHAR(40),
    LastName VARCHAR(40),
    Company VARCHAR(80),
    Address VARCHAR(70),
    City VARCHAR(40),
    State VARCHAR(40),
    Country VARCHAR(40),
    PostalCode VARCHAR(10),
    Phone VARCHAR(24),
    Fax VARCHAR(24),
    Email VARCHAR(60),
    SupportRepId INTEGER REFERENCES Employee(EmployeeId)  
);

-- Employees Table
CREATE TABLE Employee (
    EmployeeId INTEGER PRIMARY KEY,
    LastName VARCHAR(20),
    FirstName VARCHAR(20),
    Title VARCHAR(30),
    ReportsTo INTEGER,
    Address VARCHAR(70),
    City VARCHAR(40),
    State VARCHAR(40),
    Country VARCHAR(40),
    PostalCode VARCHAR(10),
    Phone VARCHAR(24),
    Fax VARCHAR(24),
    Email VARCHAR(60)
);

--  Genre Table
CREATE TABLE Genre (
    GenreId INTEGER PRIMARY KEY,
    Name VARCHAR(120)
);

-- MediaType Table
CREATE TABLE MediaType (
    MediaTypeId INTEGER PRIMARY KEY,
    Name VARCHAR(120)
);

--  Track Table (Main product catalog)
CREATE TABLE Track (
    TrackId INTEGER PRIMARY KEY,
    Name VARCHAR(200),
    AlbumId INTEGER REFERENCES Album(AlbumId),
    MediaTypeId INTEGER REFERENCES MediaType(MediaTypeId),
    GenreId INTEGER REFERENCES Genre(GenreId),
    Composer VARCHAR(220),
    Milliseconds INTEGER,
    Bytes INTEGER,
    UnitPrice NUMERIC(10, 2)
);

--  Invoice Table
CREATE TABLE Invoice (
    InvoiceId INTEGER PRIMARY KEY,
    CustomerId INTEGER REFERENCES Customer(CustomerId),
    BillingAddress VARCHAR(70),
    BillingCity VARCHAR(40),
    BillingState VARCHAR(40),
    BillingCountry VARCHAR(40),
    BillingPostalCode VARCHAR(10),
    Total NUMERIC(10, 2)
);

-- InvoiceLine Table (Line items)
CREATE TABLE InvoiceLine (
    InvoiceLineId INTEGER PRIMARY KEY,
    InvoiceId INTEGER REFERENCES Invoice(InvoiceId),
    TrackId INTEGER REFERENCES Track(TrackId),
    UnitPrice NUMERIC(10, 2),
    Quantity INTEGER
);

--  Playlist Table
CREATE TABLE Playlist (
    PlaylistId INTEGER PRIMARY KEY,
    Name VARCHAR(120)
);

--  PlaylistTrack Table (Many-to-Many: Playlists <-> Tracks)
CREATE TABLE PlaylistTrack (
    PlaylistId INTEGER REFERENCES Playlist(PlaylistId),
    TrackId INTEGER REFERENCES Track(TrackId),
    PRIMARY KEY (PlaylistId, TrackId)
);


--  Business Intelligence Queries


-- 1. Total Revenue from All Invoices
SELECT SUM(Invoice.Total) AS TotalRevenue
FROM Invoice;

-- 2. Revenue by Country
SELECT Invoice.BillingCountry, SUM(Invoice.Total) AS Revenue
FROM Invoice
GROUP BY Invoice.BillingCountry
ORDER BY Revenue DESC;

-- 3. Top 5 Customers by Revenue
SELECT 
    Customer.FirstName || ' ' || Customer.LastName AS CustomerName, 
    SUM(Invoice.Total) AS Revenue
FROM Customer
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY CustomerName
ORDER BY Revenue DESC
LIMIT 5;

-- 4.  Top 10 Tracks by Revenue
SELECT 
    Track.Name AS TrackName,
    SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS TotalRevenue
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Track.Name
ORDER BY TotalRevenue DESC
LIMIT 10;

-- 5.  Albums with the Most Units Sold
SELECT 
    Album.Title AS AlbumTitle,
    COUNT(InvoiceLine.InvoiceLineId) AS UnitsSold
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
JOIN Album ON Track.AlbumId = Album.AlbumId
GROUP BY Album.Title
ORDER BY UnitsSold DESC
LIMIT 10;

-- 6.  Top-Selling Track per Genre using RANK()
SELECT *
FROM (
    SELECT 
        Genre.Name AS GenreName,
        Track.Name AS TrackName,
        SUM(InvoiceLine.Quantity) AS UnitsSold,
        RANK() OVER (
            PARTITION BY Genre.Name 
            ORDER BY SUM(InvoiceLine.Quantity) DESC
        ) AS Rank
    FROM InvoiceLine
    JOIN Track ON InvoiceLine.TrackId = Track.TrackId
    JOIN Genre ON Track.GenreId = Genre.GenreId
    GROUP BY Genre.Name, Track.Name
) AS ranked_tracks
WHERE Rank = 1;
