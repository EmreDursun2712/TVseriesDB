/* ============================================================
   TV Series DB - Queries (reporting & exploration)
   Tip:
   - Prefer grouping by IDs, not names/titles (safer if duplicates exist).
   ============================================================ */


-- 1) All reviews with series title (sorted)
SELECT
  s.title,
  r.rating
FROM reviews r
JOIN series s
  ON s.id = r.series_id
ORDER BY s.title ASC, r.rating DESC;


-- 2) Average rating per series (includes unreviewed series as 0.00)
SELECT
  s.id,
  s.title,
  COUNT(r.id) AS review_count,
  ROUND(COALESCE(AVG(r.rating), 0), 2) AS avg_rating
FROM series s
LEFT JOIN reviews r
  ON r.series_id = s.id
GROUP BY s.id, s.title
ORDER BY avg_rating DESC, review_count DESC, s.title ASC;


-- 3) Review list with reviewer name (sorted)
SELECT
  rv.first_name,
  rv.last_name,
  s.title,
  r.rating
FROM reviews r
JOIN reviewers rv
  ON rv.id = r.reviewer_id
JOIN series s
  ON s.id = r.series_id
ORDER BY rv.last_name, rv.first_name, s.title;


-- 4) Unreviewed series (robust NULL check: r.id IS NULL)
SELECT
  s.title AS unreviewed_series
FROM series s
LEFT JOIN reviews r
  ON r.series_id = s.id
WHERE r.id IS NULL
ORDER BY s.title;


-- 5) Average rating per genre
SELECT
  s.genre,
  COUNT(r.id) AS review_count,
  ROUND(AVG(r.rating), 2) AS avg_rating
FROM series s
JOIN reviews r
  ON r.series_id = s.id
GROUP BY s.genre
ORDER BY avg_rating DESC, review_count DESC, s.genre ASC;


-- 6) Reviewer stats + status (ACTIVE / INACTIVE / POWERUSER)
SELECT
  rv.id,
  rv.first_name,
  rv.last_name,
  COUNT(r.id) AS review_count,
  COALESCE(MIN(r.rating), 0) AS min_rating,
  COALESCE(MAX(r.rating), 0) AS max_rating,
  ROUND(COALESCE(AVG(r.rating), 0), 2) AS avg_rating,
  CASE
    WHEN COUNT(r.id) >= 10 THEN 'POWERUSER'
    WHEN COUNT(r.id) > 0  THEN 'ACTIVE'
    ELSE 'INACTIVE'
  END AS status
FROM reviewers rv
LEFT JOIN reviews r
  ON r.reviewer_id = rv.id
GROUP BY rv.id, rv.first_name, rv.last_name
ORDER BY status DESC, avg_rating DESC, review_count DESC, rv.last_name, rv.first_name;


-- 7) Reviewers with zero reviews (quick list)
SELECT
  rv.id,
  rv.first_name,
  rv.last_name
FROM reviewers rv
LEFT JOIN reviews r
  ON r.reviewer_id = rv.id
WHERE r.id IS NULL
ORDER BY rv.last_name, rv.first_name;


-- 8) Top rated series (by average rating) - MySQL 8 window function
WITH series_avg AS (
  SELECT
    s.id,
    s.title,
    COUNT(r.id) AS review_count,
    ROUND(AVG(r.rating), 2) AS avg_rating
  FROM series s
  JOIN reviews r
    ON r.series_id = s.id
  GROUP BY s.id, s.title
)
SELECT
  id,
  title,
  review_count,
  avg_rating,
  DENSE_RANK() OVER (ORDER BY avg_rating DESC) AS rating_rank
FROM series_avg
ORDER BY rating_rank, review_count DESC, title;


-- 9) Detailed report: series + reviewer full name + rating
SELECT
  s.title,
  s.released_year,
  s.genre,
  r.rating,
  CONCAT(rv.first_name, ' ', rv.last_name) AS reviewer
FROM reviews r
JOIN series s
  ON s.id = r.series_id
JOIN reviewers rv
  ON rv.id = r.reviewer_id
ORDER BY s.title, reviewer;


-- 10) Optional: Create a reusable view for detailed reviews
-- (Run once; then SELECT * FROM v_reviews_detailed;)
CREATE OR REPLACE VIEW v_reviews_detailed AS
SELECT
  r.id AS review_id,
  s.id AS series_id,
  s.title,
  s.genre,
  s.released_year,
  rv.id AS reviewer_id,
  CONCAT(rv.first_name, ' ', rv.last_name) AS reviewer_name,
  r.rating,
  r.created_at
FROM reviews r
JOIN series s ON s.id = r.series_id
JOIN reviewers rv ON rv.id = r.reviewer_id;