CREATE TABLE Items (
    ItemId INT PRIMARY KEY,
    Rank VARCHAR(255)
);

INSERT INTO Items (ItemId, Rank) VALUES (1, 'hZ');

DELIMITER //

CREATE FUNCTION GenerateRankBetween (rank1 VARCHAR(255), rank2 VARCHAR(255)) 
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255) DEFAULT '';
    DECLARE i INT DEFAULT 1;
    DECLARE len1 INT DEFAULT LENGTH(rank1);
    DECLARE len2 INT DEFAULT LENGTH(rank2);
    DECLARE char1 CHAR(1);
    DECLARE char2 CHAR(1);
    DECLARE idx1 INT;
    DECLARE idx2 INT;
    DECLARE midIdx INT;
    DECLARE BASE VARCHAR(255) DEFAULT '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

    WHILE i <= GREATEST(len1, len2) DO
        SET char1 = SUBSTRING(rank1, i, 1);
        SET char2 = SUBSTRING(rank2, i, 1);
        
        SET idx1 = LOCATE(char1, BASE) - 1;
        SET idx2 = LOCATE(char2, BASE) - 1;

        SET midIdx = FLOOR((IFNULL(idx1, 0) + IFNULL(idx2, 0)) / 2);
        SET result = CONCAT(result, SUBSTRING(BASE, midIdx + 1, 1));

        SET i = i + 1;
    END WHILE;

    RETURN result;
END //

DELIMITER ;


INSERT INTO Items (ItemId, Rank)
VALUES (2, GenerateRankBetween('hZ', 'hZa'));


SELECT * FROM Items ORDER BY Rank;


DELIMITER //

CREATE FUNCTION GenerateMinRank (minRank VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE BASE VARCHAR(255) DEFAULT '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    DECLARE result VARCHAR(255) DEFAULT '';
    DECLARE i INT DEFAULT 1;
    DECLARE lenMin INT DEFAULT LENGTH(minRank);
    DECLARE charMin CHAR(1);
    DECLARE idxMin INT;
    
    WHILE i <= lenMin DO
        SET charMin = SUBSTRING(minRank, i, 1);
        SET idxMin = LOCATE(charMin, BASE) - 1;
        SET result = CONCAT(result, SUBSTRING(BASE, GREATEST(idxMin - 1, 1), 1));
        SET i = i + 1;
    END WHILE;

    RETURN result;
END //

DELIMITER ;


-- Assume 'hZ' is currently the smallest rank
INSERT INTO Items (ItemId, Rank) 
VALUES (3, GenerateMinRank((SELECT MIN(Rank) FROM Items)));


INSERT INTO Items (ItemId, Rank) 
VALUES (3, GenerateMinRank((SELECT MIN(Rank) FROM Items)));


DELIMITER //

CREATE FUNCTION GenerateMaxRank (maxRank VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE BASE VARCHAR(255) DEFAULT '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    DECLARE result VARCHAR(255) DEFAULT '';
    DECLARE i INT DEFAULT 1;
    DECLARE lenMax INT DEFAULT LENGTH(maxRank);
    DECLARE charMax CHAR(1);
    DECLARE idxMax INT;

    WHILE i <= lenMax DO
        SET charMax = SUBSTRING(maxRank, i, 1);
        SET idxMax = LOCATE(charMax, BASE) - 1;
        SET result = CONCAT(result, SUBSTRING(BASE, LEAST(idxMax + 1, LENGTH(BASE)), 1));
        SET i = i + 1;
    END WHILE;

    RETURN result;
END //

DELIMITER ;


-- Assume 'hZa' is currently the highest rank
INSERT INTO Items (ItemId, Rank) 
VALUES (4, GenerateMaxRank((SELECT MAX(Rank) FROM Items)));


INSERT INTO Items (ItemId, Rank) 
VALUES (4, GenerateMaxRank((SELECT MAX(Rank) FROM Items)));


DELIMITER //

CREATE FUNCTION GenerateRankBetween (rank1 VARCHAR(255), rank2 VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255) DEFAULT '';
    DECLARE i INT DEFAULT 1;
    DECLARE len1 INT DEFAULT LENGTH(rank1);
    DECLARE len2 INT DEFAULT LENGTH(rank2);
    DECLARE char1 CHAR(1);
    DECLARE char2 CHAR(1);
    DECLARE idx1 INT;
    DECLARE idx2 INT;
    DECLARE midIdx INT;
    DECLARE BASE VARCHAR(255) DEFAULT '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

    WHILE i <= GREATEST(len1, len2) DO
        SET char1 = SUBSTRING(rank1, i, 1);
        SET char2 = SUBSTRING(rank2, i, 1);
        
        SET idx1 = LOCATE(char1, BASE) - 1;
        SET idx2 = LOCATE(char2, BASE) - 1;

        SET midIdx = FLOOR((IFNULL(idx1, 0) + IFNULL(idx2, 0)) / 2);
        SET result = CONCAT(result, SUBSTRING(BASE, midIdx + 1, 1));

        SET i = i + 1;
    END WHILE;

    RETURN result;
END //

DELIMITER ;


-- Assuming you want to insert between items with ranks 'hYY' and 'hZ'
INSERT INTO Items (ItemId, Rank) 
VALUES (5, GenerateRankBetween('hYY', 'hZ'));


INSERT INTO Items (ItemId, Rank) 
VALUES (5, GenerateRankBetween('hYY', 'hZ'));


DELIMITER //

CREATE FUNCTION GenerateMinRank (minRank VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE BASE VARCHAR(255) DEFAULT '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    DECLARE result VARCHAR(255) DEFAULT '';
    DECLARE i INT DEFAULT 1;
    DECLARE lenMin INT DEFAULT LENGTH(minRank);
    DECLARE charMin CHAR(1);
    DECLARE idxMin INT;

    WHILE i <= lenMin DO
        SET charMin = SUBSTRING(minRank, i, 1);
        SET idxMin = LOCATE(charMin, BASE) - 1;
        SET result = CONCAT(result, SUBSTRING(BASE, GREATEST(idxMin - 1, 1), 1));
        SET i = i + 1;
    END WHILE;

    RETURN result;
END //

DELIMITER ;


-- Find the current minimum rank in the table
SELECT MIN(Rank) INTO @minRank FROM Items;

-- Generate a new minimum rank if there are existing ranks, otherwise use an initial rank
SET @newMinRank = IF(@minRank IS NULL, 'hZ', GenerateMinRank(@minRank));

-- Insert the new item with the generated minimum rank
INSERT INTO Items (ItemId, Rank) 
VALUES (1, @newMinRank);


Explanation
Function to Generate Minimum Rank:

BASE: The string of characters used for ranking.

result: The new rank that will be generated.

minRank: The current smallest rank in the table.

The function iterates through each character of the minimum rank and generates a new rank that is smaller.

Insert Item:

Find the current minimum rank: Use SELECT MIN(Rank) to get the smallest existing rank.

Generate a new minimum rank: If there are existing ranks, use GenerateMinRank to generate a new minimum rank; otherwise, use an initial rank like 'hZ'.

Insert the new item: Use the generated rank to insert the new item with the smallest rank.



-- Find the current highest rank in the table
SELECT MAX(Rank) INTO @maxRank FROM Items;

-- Find the rank of the item after which the item should be moved
SELECT Rank INTO @afterRank FROM Items WHERE ItemId = 3;

-- Generate the new rank that comes after @afterRank but before @maxRank
SET @newRank = GenerateRankBetween(@afterRank, @maxRank);

-- Update the item's rank in the table
UPDATE Items 
SET Rank = @newRank 
WHERE ItemId = 2;

