SELECT * FROM Apple.dbo.AppleStore

SELECT * FROM Apple.dbo.appleStore_description

--EXPLORATORY DATA ANALYSIS--

--1. Number of unique apps
SELECT COUNT(Distinct id) 
FROM Apple.dbo.AppleStore

SELECT COUNT(Distinct id) 
FROM Apple.dbo.appleStore_description

--2. Check for missing values
SELECT COUNT(*) AS missing_values
FROM Apple.dbo.AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL OR size_bytes IS NULL OR rating_count_tot IS NULL OR sup_devices_num IS NULL 

SELECT COUNT(*) AS missing_values
FROM Apple.dbo.appleStore_description
WHERE app_desc IS NULL

--3. Number of apps per genre
SELECT prime_genre, COUNT(*) AS Num_apps
FROM Apple.dbo.AppleStore
GROUP BY prime_genre
ORDER BY Num_apps

--4. Rating overview of apps
SELECT MIN(user_rating) AS Min_rating,
       MAX(user_rating) AS Max_rating,
	   AVG(user_rating) AS Avg_rating
FROM Apple.dbo.AppleStore

--5. Content rating overview
SELECT MIN(cont_rating) AS Min_cont_rating,
       MAX(cont_rating) AS Max_cont_rating,
	   AVG(cont_rating) AS Avg_cont_rating
FROM Apple.dbo.AppleStore

SELECT Distinct cont_rating
FROM Apple.dbo.AppleStore

--6. Distinct number of supporting devices
SELECT Distinct sup_devices_num
FROM Apple.dbo.AppleStore
ORDER BY sup_devices_num


--DATA ANALYSIS--

--1. Determine the effect of price on user rating
SELECT CASE 
            WHEN price > 0 THEN 'Paid' 
	        ELSE 'Free'
       END AS AppType,
	   AVG(user_rating) AS Avg_rating
FROM Apple.dbo.AppleStore
GROUP BY CASE 
            WHEN price > 0 THEN 'Paid' 
	        ELSE 'Free'
       END

--2. Average rating of app according to number of language supporting 
SELECT CASE
            WHEN lang_num < 10 THEN '<10 Languages'
			WHEN lang_num BETWEEN 11 AND 30 THEN '11-30 Languages'
			ELSE '30 Languages'
	   END AS language_bucket,
	   AVG(user_rating) AS Avg_rating
FROM Apple.dbo.AppleStore
GROUP BY CASE
            WHEN lang_num < 10 THEN '<10 Languages'
			WHEN lang_num BETWEEN 11 AND 30 THEN '11-30 Languages'
			ELSE '30 Languages'
	   END

-- 3. Apps group by genre with high ratings
SELECT prime_genre,AVG(user_rating) AS Avg_rating
FROM Apple.dbo.AppleStore
GROUP BY prime_genre
ORDER BY Avg_rating DESC 

--4. Apps group by genre with low ratings
SELECT prime_genre,AVG(user_rating) AS Avg_rating
FROM Apple.dbo.AppleStore
GROUP BY prime_genre
ORDER BY Avg_rating ASC 

--5. Top rated apps for each genre
SELECT prime_genre, track_name, user_rating
FROM ( SELECT prime_genre, track_name, user_rating,
	   RANK() OVER(PARTITION by prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
	   FROM Apple.dbo.AppleStore) AS a
WHERE a.rank=1


--6. Dtermine the correlation between description length and the user rating
SELECT CASE
			WHEN LEN(b.app_desc)<500 THEN 'Short'
			WHEN LEN(b.app_desc) BETWEEN 501 AND 1000 THEN 'Medium'
			ELSE 'Long'
	   END AS Description_length,
	   AVG(user_rating) AS Avg_rating
FROM Apple.dbo.AppleStore AS a
JOIN Apple.dbo.appleStore_description AS b
ON a.id=b.id
GROUP BY CASE
			WHEN LEN(b.app_desc)<500 THEN 'Short'
			WHEN LEN(b.app_desc) BETWEEN 501 AND 1000 THEN 'Medium'
			ELSE 'Long'
	   END
ORDER BY Avg_rating DESC

--7. Correlation between content rating and user rating
SELECT cont_rating, AVG(user_rating) AS Avg_rating
FROM Apple.dbo.AppleStore
GROUP BY cont_rating
ORDER BY cont_rating

--8. Average rating of app according to number of supporting devices
SELECT CASE
			WHEN sup_devices_num < 15 THEN '<15 Supporting devices'
			WHEN sup_devices_num < 25 THEN '<25 Supporting devices'
			WHEN sup_devices_num < 35 THEN '<35 Supporting devices'
			ELSE '35+ Supporting devices'
			END AS Supporting_dev,
			AVG(user_rating) AS Avg_rating
FROM Apple.dbo.AppleStore
GROUP BY CASE
			WHEN sup_devices_num < 15 THEN '<15 Supporting devices'
			WHEN sup_devices_num < 25 THEN '<25 Supporting devices'
			WHEN sup_devices_num < 35 THEN '<35 Supporting devices'
			ELSE '35+ Supporting devices'
			END
ORDER BY Avg_rating DESC