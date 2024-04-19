-- Creation of the art_gallery_CC database
create database art_gallery_CC;

-- Usage of the art_gallery_CC database
use art_gallery_cc;

-- Create the Artists table
CREATE TABLE Artists (
    ArtistID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Biography TEXT,
    Nationality VARCHAR(100)
);

-- Create the Categories table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);

-- Create the Artworks table
CREATE TABLE Artworks (
    ArtworkID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ArtistID INT,
    CategoryID INT,
    Year INT,
    Description TEXT,
    ImageURL VARCHAR(255),
    FOREIGN KEY (ArtistID)
        REFERENCES Artists (ArtistID),
    FOREIGN KEY (CategoryID)
        REFERENCES Categories (CategoryID)
);

-- Create the Exhibitions table
CREATE TABLE Exhibitions (
    ExhibitionID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    Description TEXT
);

-- Create a table to associate artworks with exhibitions
CREATE TABLE ExhibitionArtworks (
    ExhibitionID INT,
    ArtworkID INT,
    PRIMARY KEY (ExhibitionID , ArtworkID),
    FOREIGN KEY (ExhibitionID)
        REFERENCES Exhibitions (ExhibitionID),
    FOREIGN KEY (ArtworkID)
        REFERENCES Artworks (ArtworkID)
);

-- Insert sample data into the Artists table
INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
(1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
(2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
(3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

-- Insert sample data into the Categories table
INSERT INTO Categories (CategoryID, Name) VALUES
(1, 'Painting'),
(2, 'Sculpture'),
(3, 'Photography');

-- Insert sample data into the Artworks table
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
(1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
(2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
(3, 'Guernica', 1, 1, 1937, 'Pablo Picasso\'s powerful anti-war mural.', 'guernica.jpg');

-- Insert sample data into the Exhibitions table
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
(1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
(2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

-- Insert artworks into exhibitions
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2);

-- QUERIES
-- 1. Retrieve the names of all artists along with the number of artworks they have in the gallery, and list them in descending order of the number of artworks.
SELECT 
    Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM
    Artists
        LEFT JOIN
    Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
ORDER BY ArtworkCount DESC;

-- 2. List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order them by the year in ascending order.
SELECT 
    Artists.Name,Artists.Nationality,Artworks.Title,Artworks.Year,Artworks.Description
FROM
    Artworks
        JOIN
    Artists ON Artworks.ArtistID = Artists.ArtistID
WHERE
    Artists.Nationality IN ('Spanish' , 'Dutch')
ORDER BY Artworks.Year ASC;

-- 3. Find the names of all artists who have artworks in the 'Painting' category, and the number of artworks they have in this category.
SELECT 
    Artists.Name,Categories.Name as Category, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM
    Artists
        JOIN
    Artworks ON Artists.ArtistID = Artworks.ArtistID
        JOIN
    Categories ON Artworks.CategoryID = Categories.CategoryID
WHERE
    Categories.Name = 'Painting'
GROUP BY Artists.Name;

-- 4. List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their artists and categories.
SELECT 
    Artworks.Title, Artists.Name, Categories.Name AS Category,Exhibitions.Title as Exhibition
FROM
    Artworks
        JOIN
    ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
        JOIN
    Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
        JOIN
    Artists ON Artworks.ArtistID = Artists.ArtistID
        JOIN
    Categories ON Artworks.CategoryID = Categories.CategoryID
WHERE
    Exhibitions.Title = 'Modern Art Masterpieces';

-- 5. Find the artists who have more than two artworks in the gallery
SELECT 
    Artists.Name
FROM
    Artists
        JOIN
    Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
HAVING COUNT(Artworks.ArtworkID) > 2;

-- 6. Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and 'Renaissance Art' exhibitions
SELECT 
    Artworks.Title,
    GROUP_CONCAT(Exhibitions.Title ORDER BY Exhibitions.Title) AS ExhibitionTitles
FROM
    Artworks
    JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
    JOIN Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
WHERE
    Exhibitions.Title IN ('Modern Art Masterpieces' , 'Renaissance Art')
GROUP BY
    Artworks.Title
HAVING
    COUNT(DISTINCT Exhibitions.Title) = 2;
    
-- 7. Find the total number of artworks in each category
SELECT 
    Categories.Name, COUNT(Artworks.ArtworkID) AS TotalArtworks
FROM
    Categories
        LEFT JOIN
    Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.Name;

-- 8. List artists who have more than 3 artworks in the gallery.
SELECT 
    Artists.Name
FROM
    Artists
        JOIN
    Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
HAVING COUNT(Artworks.ArtworkID) > 3;

-- 9. Find the artworks created by artists from a specific nationality (e.g., Spanish).
SELECT 
    Artworks.Title, Artists.Name, Artists.Nationality
FROM
    Artworks
        JOIN
    Artists ON Artworks.ArtistID = Artists.ArtistID
WHERE
    Artists.Nationality = 'Spanish';

-- 10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci.
SELECT 
    Exhibitions.Title
FROM
    Exhibitions
        JOIN
    ExhibitionArtworks AS ea ON Exhibitions.ExhibitionID = ea.ExhibitionID
        JOIN
    Artworks AS a ON ea.ArtworkID = a.ArtworkID
        JOIN
    Artists AS artist ON a.ArtistID = artist.ArtistID
WHERE
    artist.Name IN ('Vincent van Gogh' , 'Leonardo da Vinci')
GROUP BY Exhibitions.Title
HAVING COUNT(DISTINCT artist.Name) = 2;

-- 11. Find all the artworks that have not been included in any exhibition.
SELECT 
    Artworks.*
FROM
    Artworks
        LEFT JOIN
    ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
WHERE
    ExhibitionArtworks.ArtworkID IS NULL;

-- 12. List artists who have created artworks in all available categories.
SELECT 
    Artists.Name
FROM
    Artists
        JOIN
    Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
HAVING COUNT(DISTINCT Artworks.CategoryID) = (SELECT COUNT(*) FROM Categories);

-- 13. List the total number of artworks in each category
SELECT 
    Categories.Name, COUNT(Artworks.ArtworkID) AS TotalArtworks
FROM
    Categories
        LEFT JOIN
    Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.Name;

-- 14. Find the artists who have more than 2 artworks in the gallery.
SELECT 
    Artists.Name
FROM
    Artists
        JOIN
    Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
HAVING COUNT(Artworks.ArtworkID) > 2;

-- 15. List the categories with the average year of artworks they contain, only for categories with more than 1 artwork.
SELECT 
    Categories.Name, AVG(Artworks.Year) AS AverageYear
FROM
    Categories
        JOIN
    Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.Name
HAVING COUNT(Artworks.ArtworkID) > 1;

-- 16. Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition.
SELECT 
    Artworks.*,Exhibitions.Title as Exhibition
FROM
    Artworks
        INNER JOIN
    ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
        INNER JOIN
    Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
WHERE
    Exhibitions.Title = 'Modern Art Masterpieces';

-- 17. Find the categories where the average year of artworks is greater than the average year of all artworks.
SELECT 
    CategoryID,
    AVG(Year) AS AverageYearPerCategory,
    (SELECT AVG(Year) FROM Artworks) AS OverallAverageYear
FROM Artworks
GROUP BY CategoryID
HAVING AVG(Year) > (SELECT AVG(Year) FROM Artworks);

-- 18. List the artworks that were not exhibited in any exhibition.
SELECT 
    Artworks.*
FROM
    Artworks
        LEFT JOIN
    ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
WHERE
    ExhibitionArtworks.ArtworkID IS NULL;

-- 19. Show artists who have artworks in the same category as "Mona Lisa."
SELECT DISTINCT
    Artists.Name,
    Artworks.Title,
    Artworks.Description,
    Artworks.CategoryID
FROM
    Artworks
        INNER JOIN
    Artists ON Artists.ArtistID = Artworks.ArtistID
        INNER JOIN
    Artworks AS MonaLisaArt ON Artworks.CategoryID = MonaLisaArt.CategoryID
WHERE
    MonaLisaArt.Title = 'Mona Lisa';

-- 20. List the names of artists and the number of artworks they have in the gallery
SELECT 
    Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM
    Artists
        LEFT JOIN
    Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.ArtistID , Artists.Name;






