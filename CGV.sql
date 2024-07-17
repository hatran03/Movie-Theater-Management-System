CREATE DATABASE CGV;
USE CGV;

--  Genres
CREATE TABLE Genres (
    GenreID INT PRIMARY KEY,
    GenreName VARCHAR(255) NOT NULL,
    Description TEXT
);

--  Directors
CREATE TABLE Directors (
    DirectorID INT PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    BirthDate DATE,
    Nationality VARCHAR(100)
);

--  Actors
CREATE TABLE Actors (
    ActorID INT PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    BirthDate DATE,
    Nationality VARCHAR(100)
);

--  Languages
CREATE TABLE Languages (
    LanguageID INT PRIMARY KEY,
    LanguageName VARCHAR(100)
);

--  MovieFormats
CREATE TABLE MovieFormats (
    FormatID INT PRIMARY KEY,
    FormatName VARCHAR(100),
    Description TEXT
);

--  Theaters
CREATE TABLE Theaters (
    TheaterID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    ZipCode VARCHAR(10),
    Phone VARCHAR(15)
);

--  Concessions
CREATE TABLE Concessions (
    ConcessionID INT PRIMARY KEY,
    TheaterID INT,
    Name VARCHAR(255) NOT NULL,
    Price DECIMAL(10, 2),
    FOREIGN KEY (TheaterID) REFERENCES Theaters(TheaterID)
);

--  SeatTypes
CREATE TABLE SeatTypes (
    SeatTypeID INT PRIMARY KEY,
    SeatTypeName VARCHAR(255),
    Description TEXT
);

--  Memberships
CREATE TABLE Memberships (
    MembershipID INT PRIMARY KEY,
    MembershipType VARCHAR(100),
    DiscountRate DECIMAL(5, 2),
    Description TEXT
);

--  Movies
CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ReleaseDate DATE,
    Duration INT,
    GenreID INT,
    DirectorID INT,
    LanguageID INT,
    FormatID INT,
    FOREIGN KEY (GenreID) REFERENCES Genres(GenreID),
    FOREIGN KEY (DirectorID) REFERENCES Directors(DirectorID),
    FOREIGN KEY (LanguageID) REFERENCES Languages(LanguageID),
    FOREIGN KEY (FormatID) REFERENCES MovieFormats(FormatID)
);

--  Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Phone VARCHAR(15),
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    ZipCode VARCHAR(10),
    MembershipID INT,
    FOREIGN KEY (MembershipID) REFERENCES Memberships(MembershipID)
);

--  Screens
CREATE TABLE Screens (
    ScreenID INT PRIMARY KEY,
    TheaterID INT,
    ScreenNumber INT,
    Capacity INT,
    ScreenType VARCHAR(50),
    FOREIGN KEY (TheaterID) REFERENCES Theaters(TheaterID)
);

--  Staff
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Phone VARCHAR(15),
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    ZipCode VARCHAR(10),
    Role VARCHAR(100),
    Salary DECIMAL(10, 2),
    TheaterID INT,
    FOREIGN KEY (TheaterID) REFERENCES Theaters(TheaterID)
);

--  Subtitles
CREATE TABLE Subtitles (
    SubtitleID INT PRIMARY KEY,
    LanguageID INT,
    SubtitleText TEXT,
    FOREIGN KEY (LanguageID) REFERENCES Languages(LanguageID)
);

--  Showtimes
CREATE TABLE Showtimes (
    ShowtimeID INT PRIMARY KEY,
    MovieID INT,
    ScreenID INT,
    ShowDate DATE,
    ShowTime TIME,
    SubtitleID INT,
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (ScreenID) REFERENCES Screens(ScreenID),
    FOREIGN KEY (SubtitleID) REFERENCES Subtitles(SubtitleID)
);

--  Tickets
CREATE TABLE Tickets (
    TicketID INT PRIMARY KEY,
    ShowtimeID INT,
    SeatNumber VARCHAR(10),
    SeatTypeID INT,
    Price DECIMAL(10, 2),
    PurchaseDate DATE,
    CustomerID INT,
    FOREIGN KEY (ShowtimeID) REFERENCES Showtimes(ShowtimeID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (SeatTypeID) REFERENCES SeatTypes(SeatTypeID)
);

--  MovieActors
CREATE TABLE MovieActors (
    MovieID INT,
    ActorID INT,
    RoleName VARCHAR(255),
    PRIMARY KEY (MovieID, ActorID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (ActorID) REFERENCES Actors(ActorID)
);

--  Payments
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    CustomerID INT,
    Amount DECIMAL(10, 2),
    PaymentDate DATE,
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

--  CustomerConcessions
CREATE TABLE CustomerConcessions (
    CustomerID INT,
    ConcessionID INT,
    Quantity INT,
    PurchaseDate DATE,
    PRIMARY KEY (CustomerID, ConcessionID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ConcessionID) REFERENCES Concessions(ConcessionID)
);

--  Reviews
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY,
    MovieID INT,
    CustomerID INT,
    ReviewText TEXT,
    ReviewDate DATE,
    Rating INT,
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

--  Ratings
CREATE TABLE Ratings (
    RatingID INT PRIMARY KEY,
    MovieID INT,
    CustomerID INT,
    Rating INT,
    RatingDate DATE,
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

--  Promotions
CREATE TABLE Promotions (
    PromotionID INT PRIMARY KEY,
    PromotionName VARCHAR(255),
    DiscountRate DECIMAL(5, 2),
    StartDate DATE,
    EndDate DATE,
    Description TEXT,
    MovieID INT,
    TheaterID INT,
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (TheaterID) REFERENCES Theaters(TheaterID)
);

--  PromotionCustomers
CREATE TABLE PromotionCustomers (
    PromotionID INT,
    CustomerID INT,
    PRIMARY KEY (PromotionID, CustomerID),
    FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

--  PromotionTickets
CREATE TABLE PromotionTickets (
    PromotionID INT,
    TicketID INT,
    PRIMARY KEY (PromotionID, TicketID),
    FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID),
    FOREIGN KEY (TicketID) REFERENCES Tickets(TicketID)
);

--  Reservations
CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY,
    CustomerID INT,
    ShowtimeID INT,
    SeatNumber VARCHAR(10),
    ReservationDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ShowtimeID) REFERENCES Showtimes(ShowtimeID)
);

--  Feedback
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY,
    CustomerID INT,
    FeedbackText TEXT,
    FeedbackDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

--  GiftCards
CREATE TABLE GiftCards (
    GiftCardID INT PRIMARY KEY,
    CustomerID INT,
    CardNumber VARCHAR(50) UNIQUE,
    Balance DECIMAL(10, 2),
    ExpiryDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert data into Genres
INSERT INTO Genres (GenreID, GenreName, Description)
VALUES
    (101, 'Action', 'Movies involving intense action scenes and thrilling plots.'),
    (102, 'Drama', 'Movies focused on emotional and relational themes.'),
    (103, 'Crime', 'Movies centered around criminal activities and investigations.'),
    (104, 'Adventure', 'Movies featuring adventurous journeys and explorations.'),
    (105, 'Animation', 'Movies created using animation techniques.'),
    (106, 'Sci-Fi', 'Movies exploring speculative science and futuristic themes.'),
    (107, 'Fantasy', 'Movies set in fantastical worlds and featuring magical elements.'),
    (108, 'Horror', 'Movies designed to evoke fear and suspense.'),
    (109, 'Romance', 'Movies primarily focusing on romantic relationships.'),
    (110, 'Thriller', 'Movies characterized by tension and excitement.');

-- Insert data into Directors
INSERT INTO Directors (DirectorID, FirstName, LastName, BirthDate, Nationality)
VALUES
    (101, 'Christopher', 'Nolan', '1970-07-30', 'British'),
    (102, 'James', 'Cameron', '1954-08-16', 'Canadian'),
    (103, 'Francis Ford', 'Coppola', '1939-04-07', 'American'),
    (104, 'Quentin', 'Tarantino', '1963-03-27', 'American'),
    (105, 'Hayao', 'Miyazaki', '1941-01-05', 'Japanese');

-- Insert data into Actors
INSERT INTO Actors (ActorID, FirstName, LastName, BirthDate, Nationality)
VALUES
    (101, 'Leonardo', 'DiCaprio', '1974-11-11', 'American'),
    (102, 'Kate', 'Winslet', '1975-10-05', 'British'),
    (103, 'Al Pacino', 'Pacino', '1940-04-25', 'American'),
    (104, 'John', 'Travolta', '1954-02-18', 'American'),
    (105, 'Miyu', 'Irino', '1988-02-19', 'Japanese');

-- Insert data into Languages
INSERT INTO Languages (LanguageID, LanguageName)
VALUES
    (101, 'English'),
    (102, 'French'),
    (103, 'Spanish'),
    (104, 'Japanese'),
    (105, 'Chinese');

-- Insert data into MovieFormats
INSERT INTO MovieFormats (FormatID, FormatName, Description)
VALUES
    (101, '2D', 'Standard two-dimensional format.'),
    (102, '3D', 'Three-dimensional format for immersive viewing.'),
    (103, 'IMAX', 'Large-format cinematic experience.'),
    (104, '4DX', 'Enhanced 3D experience with motion seats and environmental effects.'),
    (105, 'Dolby Atmos', 'Advanced audio format for immersive sound.');

-- Insert data into Theaters
INSERT INTO Theaters (TheaterID, Name, Address, City, State, ZipCode, Phone)
VALUES
    (101, 'CGV Aeon Mall', '123 ABC Street', 'Ho Chi Minh City', 'Sài Gòn', '700000', '+84 123 456 789'),
    (102, 'CGV Vincom Center', '456 XYZ Street', 'Hanoi', 'Hà Nội', '100000', '+84 987 654 321'),
    (103, 'CGV Lotte Cinema', '789 QRS Street', 'Da Nang', 'Đà Nẵng', '500000', '+84 111 222 333');

-- Insert data into Concessions
INSERT INTO Concessions (ConcessionID, TheaterID, Name, Price)
VALUES
    (101, 101, 'Popcorn', 5.00),
    (102, 101, 'Soda', 3.00),
    (103, 102, 'Nachos', 6.50),
    (104, 102, 'Hot Dog', 4.50),
    (105, 103, 'Ice Cream', 4.00);

-- Insert data into SeatTypes
INSERT INTO SeatTypes (SeatTypeID, SeatTypeName, Description)
VALUES
    (101, 'Standard', 'Regular seating with average comfort.'),
    (102, 'Premium', 'Enhanced seating with extra comfort and amenities.'),
    (103, 'VIP', 'Luxurious seating with personalized service.'),
    (104, 'Accessible', 'Seating designed for accessibility needs.'),
    (105, 'Couple', 'Seating for two with added privacy.');

-- Insert data into Memberships
INSERT INTO Memberships (MembershipID, MembershipType, DiscountRate, Description)
VALUES
    (101, 'Basic', 0.00, 'Standard membership with no discounts.'),
    (102, 'Silver', 5.00, 'Membership with 5% discount on tickets and concessions.'),
    (103, 'Gold', 10.00, 'Premium membership with 10% discount on tickets, concessions, and special events.');

-- Insert data into Movies
INSERT INTO Movies (MovieID, Title, ReleaseDate, Duration, GenreID, DirectorID, LanguageID, FormatID)
VALUES
    (101, 'Inception', '2010-07-16', 148, 101, 101, 101, 102),
    (102, 'Titanic', '1997-12-19', 195, 102, 102, 101, 103),
    (103, 'The Godfather', '1972-03-24', 175, 103, 103, 101, 101),
    (104, 'Pulp Fiction', '1994-10-14', 154, 104, 104, 101, 101),
    (105, 'Spirited Away', '2001-07-20', 125, 105, 105, 105, 101),
    (106, 'Avatar', '2009-12-18', 162, 101, 101, 101, 104),
    (107, 'The Lord of the Rings: The Fellowship of the Ring', '2001-12-19', 178, 106, 102, 101, 101),
    (108, 'Alien', '1979-05-25', 117, 103, 103, 101, 102),
    (109, 'Edward Scissorhands', '1990-12-07', 105, 107, 104, 101, 101),
    (110, 'Fight Club', '1999-10-15', 139, 109, 104, 101, 101);

-- Insert data into Customers
INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Phone, Address, City, State, ZipCode, MembershipID)
VALUES
    (101, 'John', 'Doe', 'johndoe@example.com', '+1 123 456 7890', '456 Main St', 'Anytown', 'CA', '90001', 102),
    (102, 'Jane', 'Smith', 'janesmith@example.com', '+1 987 654 3210', '789 Elm St', 'Othertown', 'NY', '10001', 101),
    (103, 'Michael', 'Johnson', 'michaeljohnson@example.com', '+1 111 222 3333', '123 Maple Ave', 'Smalltown', 'TX', '75001', 103),
    (104, 'Emily', 'Brown', 'emilybrown@example.com', '+1 555 666 7777', '789 Oak St', 'Hometown', 'FL', '33001', 102),
    (105, 'Sophia', 'Lee', 'sophialee@example.com', '+1 999 888 7777', '101 Pine St', 'Yourtown', 'WA', '98001', 101);

-- Insert data into Screens
INSERT INTO Screens (ScreenID, TheaterID, ScreenNumber, Capacity, ScreenType)
VALUES
    (101, 101, 1, 100, 'Standard'),
    (102, 102, 2, 120, 'Premium'),
    (103, 103, 3, 80, 'VIP'),
    (104, 101, 4, 150, 'Standard'),
    (105, 102, 5, 110, 'Premium');

-- Insert data into Staff
INSERT INTO Staff (StaffID, FirstName, LastName, Email, Phone, Address, City, State, ZipCode, Role, Salary, TheaterID)
VALUES
    (101, 'David', 'Anderson', 'david.anderson@example.com', '+1 222 333 4444', '111 Oak St', 'Somewhere', 'CA', '90002', 'Manager', 50000.00, 101),
    (102, 'Sarah', 'Wilson', 'sarah.wilson@example.com', '+1 444 555 6666', '222 Elm St', 'Nowhere', 'NY', '10002', 'Ticket Seller', 30000.00, 102),
    (103, 'James', 'Miller', 'james.miller@example.com', '+1 666 777 8888', '333 Maple Ave', 'Anyplace', 'TX', '75002', 'Concessions Staff', 28000.00, 103),
    (104, 'Linda', 'Moore', 'linda.moore@example.com', '+1 888 999 0000', '444 Pine St', 'Elsewhere', 'WA', '98002', 'Cleaning Crew', 25000.00, 101),
    (105, 'Ryan', 'Taylor', 'ryan.taylor@example.com', '+1 111 000 9999', '555 Oak St', 'Everywhere', 'FL', '33002', 'Security', 32000.00, 102);

-- Insert data into Subtitles
INSERT INTO Subtitles (SubtitleID, LanguageID, SubtitleText)
VALUES
    (101, 101, 'English Subtitles'),
    (102, 102, 'French Subtitles'),
    (103, 103, 'Spanish Subtitles'),
    (104, 104, 'Japanese Subtitles'),
    (105, 105, 'Chinese Subtitles');

-- Insert data into Showtimes
INSERT INTO Showtimes (ShowtimeID, MovieID, ScreenID, ShowDate, ShowTime, SubtitleID)
VALUES
    (101, 101, 101, '2024-07-20', '14:00:00', 101),
    (102, 102, 102, '2024-07-20', '17:30:00', 102),
    (103, 103, 103, '2024-07-20', '20:00:00', 103),
    (104, 104, 104, '2024-07-21', '13:30:00', 104),
    (105, 105, 105, '2024-07-21', '16:00:00', 105);

-- Insert data into Tickets
INSERT INTO Tickets (TicketID, ShowtimeID, SeatNumber, SeatTypeID, Price, PurchaseDate, CustomerID)
VALUES
    (101, 101, 'A1', 101, 10.00, '2024-07-19', 101),
    (102, 102, 'B2', 102, 15.00, '2024-07-19', 102),
    (103, 103, 'C3', 103, 20.00, '2024-07-20', 103),
    (104, 104, 'D4', 104, 12.00, '2024-07-20', 104),
    (105, 105, 'E5', 105, 18.00, '2024-07-21', 105);

-- Insert data into MovieActors
INSERT INTO MovieActors (MovieID, ActorID, RoleName)
VALUES
    (101, 101, 'Dom Cobb'),
    (101, 102, 'Mal'),
    (102, 101, 'Jack Dawson'),
    (102, 102, 'Rose DeWitt Bukater'),
    (103, 103, 'Michael Corleone'),
    (103, 104, 'Kay Adams'),
    (104, 103, 'Vincent Vega'),
    (104, 104, 'Mia Wallace'),
    (105, 105, 'Chihiro'),
    (105, 104, 'Haku');

-- Insert data into Payments
INSERT INTO Payments (PaymentID, CustomerID, Amount, PaymentDate, PaymentMethod)
VALUES
    (101, 101, 30.00, '2024-07-20', 'Credit Card'),
    (102, 102, 25.00, '2024-07-20', 'Debit Card'),
    (103, 103, 40.00, '2024-07-21', 'PayPal'),
    (104, 104, 20.00, '2024-07-21', 'Cash'),
    (105, 105, 35.00, '2024-07-22', 'Credit Card');

-- Insert data into CustomerConcessions
INSERT INTO CustomerConcessions (CustomerID, ConcessionID, Quantity, PurchaseDate)
VALUES
    (101, 101, 2, '2024-07-20'),
    (102, 102, 1, '2024-07-21'),
    (103, 103, 3, '2024-07-22'),
    (104, 104, 1, '2024-07-23'),
    (105, 105, 2, '2024-07-24');

-- Insert data into Reviews
INSERT INTO Reviews (ReviewID, MovieID, CustomerID, ReviewText, ReviewDate, Rating)
VALUES
    (101, 101, 101, 'A mind-bending thriller with stunning visuals.', '2024-07-21', 5),
    (102, 102, 102, 'An epic romance that tugs at the heartstrings.', '2024-07-22', 4),
    (103, 103, 103, 'A masterpiece of storytelling and filmmaking.', '2024-07-23', 5),
    (104, 104, 104, 'Quentin Tarantino''s best work with memorable characters.', '2024-07-24', 4),
    (105, 105, 105, 'A magical journey with beautiful animation and deep themes.', '2024-07-25', 5);

-- Insert data into Ratings
INSERT INTO Ratings (RatingID, MovieID, CustomerID, Rating, RatingDate)
VALUES
    (101, 101, 101, 4, '2024-07-21'),
    (102, 102, 102, 3, '2024-07-22'),
    (103, 103, 103, 5, '2024-07-23'),
    (104, 104, 104, 4, '2024-07-24'),
    (105, 105, 105, 5, '2024-07-25');

-- Insert data into Promotions
INSERT INTO Promotions (PromotionID, PromotionName, DiscountRate, StartDate, EndDate, Description, MovieID, TheaterID)
VALUES
    (101, 'Summer Special', 10.00, '2024-07-20', '2024-08-31', 'Enjoy 10% off on all tickets and concessions!', 101, 101),
    (102, 'Family Fun', 15.00, '2024-07-20', '2024-09-30', 'Get 15% off for families of four or more.', 102, 102),
    (103, 'Student Discount', 20.00, '2024-07-20', '2024-12-31', 'Students get 20% off on tickets with valid ID.', 103, 103),
    (104, 'Senior Day', 25.00, '2024-07-20', '2024-10-31', 'Seniors enjoy 25% off every Wednesday!', 104, 101),
    (105, 'Date Night', 10.00, '2024-07-20', '2024-11-30', 'Couples receive 10% off on tickets and concessions.', 105, 102);

-- Insert data into PromotionCustomers
INSERT INTO PromotionCustomers (PromotionID, CustomerID)
VALUES
    (101, 101),
    (102, 102),
    (103, 103),
    (104, 104),
    (105, 105);

-- Insert data into PromotionTickets
INSERT INTO PromotionTickets (PromotionID, TicketID)
VALUES
    (101, 101),
    (102, 102),
    (103, 103),
    (104, 104),
    (105, 105);

-- Insert data into Reservations
INSERT INTO Reservations (ReservationID, CustomerID, ShowtimeID, SeatNumber, ReservationDate)
VALUES
    (101, 101, 101, 'A1', '2024-07-20'),
    (102, 102, 102, 'B2', '2024-07-21'),
    (103, 103, 103, 'C3', '2024-07-22'),
    (104, 104, 104, 'D4', '2024-07-23'),
    (105, 105, 105, 'E5', '2024-07-24');

-- Insert data into Feedback
INSERT INTO Feedback (FeedbackID, CustomerID, FeedbackText, FeedbackDate)
VALUES
    (101, 101, 'Great service and comfortable seats.', '2024-07-21'),
    (102, 102, 'The movie was amazing, but the popcorn was stale.', '2024-07-22'),
    (103, 103, 'Staff was friendly, and the theater was clean.', '2024-07-23'),
    (104, 104, 'Good selection of movies, but ticket prices are high.', '2024-07-24'),
    (105, 105, 'Overall enjoyable experience.', '2024-07-25');

-- Insert data into GiftCards
INSERT INTO GiftCards (GiftCardID, CustomerID, CardNumber, Balance, ExpiryDate)
VALUES
    (101, 101, '1234567890123456', 50.00, '2025-07-31'),
    (102, 102, '9876543210987654', 25.00, '2025-12-31'),
    (103, 103, '1111222233334444', 100.00, '2024-12-31'),
    (104, 104, '5555666677778888', 75.00, '2025-06-30'),
    (105, 105, '9999000011112222', 30.00, '2025-09-30');


select * from Movies

-- Trigger

-- 1. Update Screen After Ticket Sale
CREATE TRIGGER UpdateScreenAfterTicketSale
ON Tickets
AFTER INSERT
AS
BEGIN
    DECLARE @ScreenID INT;
    DECLARE @ShowtimeID INT;

    SELECT @ShowtimeID = ShowtimeID FROM inserted;

    SELECT @ScreenID = ScreenID FROM Showtimes WHERE ShowtimeID = @ShowtimeID;

    UPDATE Screens
    SET Capacity = Capacity - 1
    WHERE ScreenID = @ScreenID;
END;



-- 2. Updae Customer Total Spent After Payment
ALTER TABLE Customers ADD TotalSpent DECIMAL(10, 2) DEFAULT 0;

CREATE TRIGGER UpdateCustomerTotalSpentAfterPayment
ON Payments
AFTER INSERT
AS
BEGIN
    DECLARE @CustomerID INT;
    DECLARE @Amount DECIMAL(10, 2);

    SELECT @CustomerID = CustomerID, @Amount = Amount FROM inserted;

    UPDATE Customers
    SET TotalSpent = ISNULL(TotalSpent, 0) + @Amount
    WHERE CustomerID = @CustomerID;
END;

-- 3. Update Total Tickets Sold After Ticket Sale
ALTER TABLE Customers ADD TotalTicketsSold INT DEFAULT 0;

CREATE TRIGGER UpdateTotalTicketsSoldAfterTicketSale
ON Tickets
AFTER INSERT
AS
BEGIN
    DECLARE @CustomerID INT;

    SELECT @CustomerID = CustomerID FROM inserted;

    UPDATE Customers
    SET TotalTicketsSold = (SELECT COUNT(*) FROM Tickets WHERE CustomerID = @CustomerID)
    WHERE CustomerID = @CustomerID;
END;

-- 4. Update Screen And Customer After Ticket Delete
CREATE TRIGGER UpdateScreenAndCustomerAfterTicketDelete
ON Tickets
AFTER DELETE
AS
BEGIN
    DECLARE @ScreenID INT;
    DECLARE @ShowtimeID INT;
    DECLARE @CustomerID INT;

    SELECT @ShowtimeID = ShowtimeID, @CustomerID = CustomerID FROM deleted;

    SELECT @ScreenID = ScreenID FROM Showtimes WHERE ShowtimeID = @ShowtimeID;

    UPDATE Screens
    SET Capacity = Capacity + 1
    WHERE ScreenID = @ScreenID;

    UPDATE Customers
    SET TotalTicketsSold = (SELECT COUNT(*) FROM Tickets WHERE CustomerID = @CustomerID)
    WHERE CustomerID = @CustomerID;
END;

-- 5. Update Customer Totals After Ticket Delete
CREATE TRIGGER UpdateCustomerTotalsAfterTicketDelete
ON Tickets
AFTER DELETE
AS
BEGIN
    DECLARE @CustomerID INT;
    DECLARE @Price DECIMAL(10, 2);

    SELECT @CustomerID = CustomerID, @Price = Price FROM deleted;

    UPDATE Customers
    SET 
        TotalSpent = ISNULL(TotalSpent, 0) - @Price,
        TotalTicketsSold = (SELECT COUNT(*) FROM Tickets WHERE CustomerID = @CustomerID)
    WHERE CustomerID = @CustomerID;
END;

-- Store Procedures

-- Procedure 1: Get movie details, including genre, director, language and format

CREATE PROCEDURE GetMovieDetails
    @MovieID INT
AS
BEGIN
    SELECT 
        M.Title,
        M.ReleaseDate,
        M.Duration,
        G.GenreName,
        CONCAT(D.FirstName, ' ', D.LastName) AS Director,
        L.LanguageName,
        F.FormatName
    FROM 
        Movies M
        INNER JOIN Genres G ON M.GenreID = G.GenreID
        INNER JOIN Directors D ON M.DirectorID = D.DirectorID
        INNER JOIN Languages L ON M.LanguageID = L.LanguageID
        INNER JOIN MovieFormats F ON M.FormatID = F.FormatID
    WHERE 
        M.MovieID = @MovieID;
END;

-- Procedure 2: Add a new customer and return the ID of the newly added customer

CREATE PROCEDURE AddNewCustomer
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @Email VARCHAR(255),
    @Phone VARCHAR(15),
    @Address VARCHAR(255),
    @City VARCHAR(100),
    @State VARCHAR(100),
    @ZipCode VARCHAR(10),
    @MembershipID INT
AS
BEGIN
    INSERT INTO Customers (FirstName, LastName, Email, Phone, Address, City, State, ZipCode, MembershipID)
    VALUES (@FirstName, @LastName, @Email, @Phone, @Address, @City, @State, @ZipCode, @MembershipID);

    SELECT SCOPE_IDENTITY() AS NewCustomerID;
END;

-- Procedure 3: Update customer information and return newly updated information

CREATE PROCEDURE UpdateCustomerInfo
    @CustomerID INT,
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @Email VARCHAR(255),
    @Phone VARCHAR(15),
    @Address VARCHAR(255),
    @City VARCHAR(100),
    @State VARCHAR(100),
    @ZipCode VARCHAR(10),
    @MembershipID INT
AS
BEGIN
    UPDATE Customers
    SET 
        FirstName = @FirstName,
        LastName = @LastName,
        Email = @Email,
        Phone = @Phone,
        Address = @Address,
        City = @City,
        State = @State,
        ZipCode = @ZipCode,
        MembershipID = @MembershipID
    WHERE CustomerID = @CustomerID;

    SELECT * FROM Customers WHERE CustomerID = @CustomerID;
END;

-- Procedure 4: Get information on all screenings of a movie in a period of time
CREATE PROCEDURE GetShowtimesForMovie
    @MovieID INT,
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        S.ShowtimeID,
        S.ShowDate,
        S.ShowTime,
        T.Name AS TheaterName,
        T.City,
        T.State,
        T.Address
    FROM 
        Showtimes S
        INNER JOIN Screens SC ON S.ScreenID = SC.ScreenID
        INNER JOIN Theaters T ON SC.TheaterID = T.TheaterID
    WHERE 
        S.MovieID = @MovieID AND 
        S.ShowDate BETWEEN @StartDate AND @EndDate
    ORDER BY 
        S.ShowDate, S.ShowTime;
END;

-- Procedure 5: Delete customer and all related data (tickets, payments, reviews)

CREATE PROCEDURE DeleteCustomerAndRelatedData
    @CustomerID INT
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DELETE FROM Reviews WHERE CustomerID = @CustomerID;
        DELETE FROM Payments WHERE CustomerID = @CustomerID;
        DELETE FROM Tickets WHERE CustomerID = @CustomerID;
        DELETE FROM Reservations WHERE CustomerID = @CustomerID;
        DELETE FROM CustomerConcessions WHERE CustomerID = @CustomerID;
        DELETE FROM PromotionCustomers WHERE CustomerID = @CustomerID;
        DELETE FROM GiftCards WHERE CustomerID = @CustomerID;
        DELETE FROM Feedback WHERE CustomerID = @CustomerID;
        DELETE FROM Customers WHERE CustomerID = @CustomerID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

-- Queries
-- 1. Calculate the number of tickets sold for each movie
WITH TicketCounts AS (
    SELECT 
        M.MovieID,
        M.Title,
        COUNT(T.TicketID) AS TicketsSold
    FROM 
        Movies M
        LEFT JOIN Showtimes S ON M.MovieID = S.MovieID
        LEFT JOIN Tickets T ON S.ShowtimeID = T.ShowtimeID
    GROUP BY 
        M.MovieID, M.Title
)
SELECT 
    MovieID,
    Title,
    TicketsSold
FROM 
    TicketCounts
ORDER BY 
    TicketsSold DESC;

-- 2. Get a list of movies that have more tickets sold than average
SELECT 
    M.MovieID,
    M.Title,
    MovieTicketCounts.TotalTickets
FROM 
    Movies M
    JOIN (
        SELECT 
            S.MovieID,
            COUNT(T.TicketID) AS TotalTickets
        FROM 
            Showtimes S
            JOIN Tickets T ON S.ShowtimeID = T.ShowtimeID
        GROUP BY 
            S.MovieID
    ) MovieTicketCounts ON M.MovieID = MovieTicketCounts.MovieID
WHERE 
    MovieTicketCounts.TotalTickets > (
        SELECT AVG(TotalTickets)
        FROM (
            SELECT 
                S.MovieID,
                COUNT(T.TicketID) AS TotalTickets
            FROM 
                Showtimes S
                JOIN Tickets T ON S.ShowtimeID = T.ShowtimeID
            GROUP BY 
                S.MovieID
        ) MovieAverages
    );

-- 3. Get a list of customers who spent the most
WITH CustomerSpending AS (
    SELECT 
        C.CustomerID,
        CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
        SUM(P.Amount) AS TotalSpent
    FROM 
        Customers C
        JOIN Payments P ON C.CustomerID = P.CustomerID
    GROUP BY 
        C.CustomerID, C.FirstName, C.LastName
)
SELECT 
    CustomerID,
    CustomerName,
    TotalSpent
FROM 
    CustomerSpending
ORDER BY 
    TotalSpent DESC;

-- 4. Get a list of movies with showings in different theaters
SELECT 
    MovieID,
    Title
FROM 
    Movies M
WHERE 
    NOT EXISTS (
        SELECT T1.TheaterID
        FROM Theaters T1
        WHERE NOT EXISTS (
            SELECT 1
            FROM Showtimes S
            JOIN Screens SC ON S.ScreenID = SC.ScreenID
            WHERE SC.TheaterID = T1.TheaterID AND S.MovieID = M.MovieID
        )
    );

-- 5 Get the list of theaters with the most performances
WITH TheaterShowCounts AS (
    SELECT 
        T.TheaterID,
        T.Name,
        COUNT(S.ShowtimeID) AS TotalShowtimes
    FROM 
        Theaters T
        JOIN Screens SC ON T.TheaterID = SC.TheaterID
        JOIN Showtimes S ON SC.ScreenID = S.ScreenID
    GROUP BY 
        T.TheaterID, T.Name
)
SELECT 
    TheaterID,
    Name,
    TotalShowtimes
FROM 
    TheaterShowCounts
ORDER BY 
    TotalShowtimes DESC;






