/* ============================================================
   TV Series DB - Schema
   Notes:
   - InnoDB is required for foreign keys.
   - CHECK constraints are enforced in MySQL 8.0.16+.
   ============================================================ */

DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS series;
DROP TABLE IF EXISTS reviewers;

CREATE TABLE reviewers (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name  VARCHAR(50) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_reviewers_last_first (last_name, first_name)
) ENGINE=InnoDB;

CREATE TABLE series (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title         VARCHAR(100) NOT NULL,
  released_year YEAR,
  genre         VARCHAR(100) NOT NULL,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_series_title (title),
  INDEX idx_series_genre (genre)
) ENGINE=InnoDB;

CREATE TABLE reviews (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  rating DECIMAL(3,1) NOT NULL,         -- allows 10.0 (unlike DECIMAL(2,1))
  series_id   INT UNSIGNED NOT NULL,
  reviewer_id INT UNSIGNED NOT NULL,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_reviews_series
    FOREIGN KEY (series_id)
    REFERENCES series(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  CONSTRAINT fk_reviews_reviewer
    FOREIGN KEY (reviewer_id)
    REFERENCES reviewers(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  CONSTRAINT chk_rating_range
    CHECK (rating >= 0 AND rating <= 10),

  INDEX idx_reviews_series_id (series_id),
  INDEX idx_reviews_reviewer_id (reviewer_id),
  INDEX idx_reviews_rating (rating)
) ENGINE=InnoDB;