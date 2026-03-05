/* ============================================================
   TV Series DB - Database bootstrap
   - Safe to re-run (drops and recreates the database)
   ============================================================ */

DROP DATABASE IF EXISTS tvseries;

CREATE DATABASE tvseries
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE tvseries;