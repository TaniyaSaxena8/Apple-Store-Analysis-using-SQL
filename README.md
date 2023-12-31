# Apple-Store-Analysis-using-SQL
**OBJECTIVE**
---
The Apple Store is like a huge digital marketplace where you can find lots of mobile apps for various purposes. It's essential for our digital lives, offering us ways to work, chat with friends, and have fun on our devices. Think of it as a mirror that shows us how technology is changing, what people like, and all the new and creative mobile apps that people are making.

The goal of this analysis was to deep dive into the vast reservoir of data generated by the Apple Store, leveraging the power of Structured Query Language (SQL) to reveal invaluable insights.

**DATA DESCRIPTION**
---
**Data Source:**  The data used for this analysis was obtained from Kaggle.

**Dataset Link:** https://www.kaggle.com/datasets/ramamet4/app-store-apple-data-set-10k-apps

**Content**: In the dataset, there is a total of 7197 apps’ data. And there are 2 files appleStore_description.csv and AppleStore.csv.

**Dataset1: AppleStore.csv**
1.	"id": App ID
2.	"track_name": App Name
3.	"size_bytes": Size (in Bytes)
4.	"currency": Currency Type
5.	"price": Price amount
6.	"rating_count_tot": User Rating counts (for all versions)
7.	"rating_count_ver": User Rating counts (for current version)
8.	"user_rating": Average User Rating value (for all versions)
9.	"user_rating_ver": Average User Rating value (for current version)
10.	"ver": Latest version code
11.	"cont_rating": Content Rating
12.	"prime_genre": Primary Genre
13.	"sup_devices.num": Number of supported devices
14.	"ipadSc_urls.num": Number of screenshots shown for display
15.	"lang.num": Number of supported languages
16.	"vpp_lic": Vpp Device-Based Licensing Enabled

**Dataset2: appleStore_description.csv**
1.	id: App ID
2.	track_name: Application name
3.	size_bytes: Memory size (in Bytes)
4.	app_desc: Application description

**EXPLORATORY DATA ANALYSIS**
---
**1. Number of unique apps**
```js
SELECT COUNT(Distinct id) 
FROM Apple.dbo.AppleStore

SELECT COUNT(Distinct id) 
FROM Apple.dbo.appleStore_description
```
Both the files show 7197 apps.

**2. Check for missing values**
```js
SELECT COUNT(*) AS missing_values
FROM Apple.dbo.AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL OR size_bytes IS NULL OR rating_count_tot IS NULL OR sup_devices_num IS NULL 

SELECT COUNT(*) AS missing_values
FROM Apple.dbo.appleStore_description
WHERE app_desc IS NULL
```
There are '0' missing values in both the files.

**3. Number of apps per genre**
```js
SELECT prime_genre, COUNT(*) AS Num_apps
FROM Apple.dbo.AppleStore
GROUP BY prime_genre
ORDER BY Num_apps
```
![image](https://github.com/TaniyaSaxena8/Apple-Store-Analysis-using-SQL/assets/135128191/9dfd0630-e2eb-4fa2-876a-2dc206fe6399)

**4. Rating overview of apps**
```js
SELECT MIN(user_rating) AS Min_rating,
       MAX(user_rating) AS Max_rating,
	   AVG(user_rating) AS Avg_rating
FROM Apple.dbo.AppleStore
```
![image](https://github.com/TaniyaSaxena8/Apple-Store-Analysis-using-SQL/assets/135128191/c56a19be-a9cd-4ac5-8d6e-9da0fde39b15)

**5. Content rating overview**
```js
SELECT MIN(cont_rating) AS Min_cont_rating,
       MAX(cont_rating) AS Max_cont_rating,
	   AVG(cont_rating) AS Avg_cont_rating
FROM Apple.dbo.AppleStore

SELECT Distinct cont_rating
FROM Apple.dbo.AppleStore
```
![image](https://github.com/TaniyaSaxena8/Apple-Store-Analysis-using-SQL/assets/135128191/2d8a5d8b-f5e5-4fec-af97-8194d5fa69eb)

**6. Distinct number of supporting devices**
```js
SELECT Distinct sup_devices_num
FROM Apple.dbo.AppleStore
ORDER BY sup_devices_num
```
![image](https://github.com/TaniyaSaxena8/Apple-Store-Analysis-using-SQL/assets/135128191/3a8b82a8-d819-4a64-b09b-0fd293ab8761)

**DATA ANALYSIS**
---
**1. Determine the effect of price on user rating**
```js
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
```
![image](https://github.com/TaniyaSaxena8/Apple-Store-Analysis-using-SQL/assets/135128191/6b331420-6d1d-4da2-8808-a2f980b876e7)

**2. Average rating of the app according to number of languages supporting**
```js
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
```
![image](https://github.com/TaniyaSaxena8/Apple-Store-Analysis-using-SQL/assets/135128191/bd0c0b2d-ad4d-48ec-8b4b-13b542eab637)

**3. Apps group by genre with high ratings**
```js
SELECT prime_genre,AVG(user_rating) AS Avg_rating
FROM Apple.dbo.AppleStore
GROUP BY prime_genre
ORDER BY Avg_rating DESC 
```
![image](https://github.com/TaniyaSaxena8/Apple-Store-Analysis-using-SQL/assets/135128191/cc7ce334-988b-468d-90b2-1b74035d1ec5)

**4. Apps group by genre with low ratings**
```js
SELECT prime_genre,AVG(user_rating) AS Avg_rating
FROM Apple.dbo.AppleStore
GROUP BY prime_genre
ORDER BY Avg_rating ASC
```
![image](https://github.com/TaniyaSaxena8/Apple-Store-Analysis-using-SQL/assets/135128191/e876ec18-d675-4011-95eb-dc610cc43d96)

**5. Top rated apps for each genre**
```js
SELECT prime_genre, track_name, user_rating
FROM ( SELECT prime_genre, track_name, user_rating,
	   RANK() OVER(PARTITION by prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
	   FROM Apple.dbo.AppleStore) AS a
WHERE a.rank=1
```
![image](https://github.com/TaniyaSaxena8/Apple-Store-Analysis-using-SQL/assets/135128191/9bfd2c37-04da-4869-a7f1-749d51e1d480)

**6. Dtermine the correlation between description length and the user rating**
```js
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
```
![image](https://github.com/TaniyaSaxena8/Apple-Store-Analysis-using-SQL/assets/135128191/71332eac-bef5-4466-a35b-d943c5499cdb)

**7. Correlation between content rating and user rating**
```js
SELECT cont_rating, AVG(user_rating) AS Avg_rating
FROM Apple.dbo.AppleStore
GROUP BY cont_rating
ORDER BY cont_rating
```
![image](https://github.com/TaniyaSaxena8/Apple-Store-Analysis-using-SQL/assets/135128191/38e8a5cb-d9d2-4cc0-91af-3f8576ac06cf)

**8. Average rating of app according to number of supporting devices**
```js
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
```
![image](https://github.com/TaniyaSaxena8/Apple-Store-Analysis-using-SQL/assets/135128191/4648b999-8117-4fc8-a05c-ee379996d3d2)









