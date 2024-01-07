CREATE SCHEMA sales_report;

SET SEARCH_PATH TO sales_report;

DROP TABLE IF EXISTS item_sales_raw;
CREATE TABLE item_sales_raw (
salesId CHAR(9) PRIMARY KEY,
sellersId	VARCHAR(7)	,
qty	INTEGER CONSTRAINT no_neg_qty CHECK (qty > 0),
salesDate DATE,
itemCode VARCHAR(2)
);

COPY item_sales_raw
FROM '/home/manu/Documents/postgreSQL/item_sales_v3.csv'
 CSV
DELIMITER ','
HEADER
;

EXPLAIN SELECT * FROM item_sales_raw;
SELECT * FROM item_sales_raw LIMIT 10;


-- trying to change primaary key column
BEGIN;
UPDATE item_sales_raw SET salesid = 'xhhi26742' WHERE salesid ='hzaf12582';

ROLLBACK;
--COMMIT;
SELECT * FROM item_sales_raw WHERE salesid ='xhhi26742';


-- checking system columns
SELECT DISTINCT tableoid FROM item_sales_raw;



SELECT FLOOR((20-1+1)*RANDOM())+1;

EXPLAIN SELECT sellersid, COUNT(*) AS cnt FROM item_sales_raw
GROUP BY sellersid HAVING COUNT(*) <> 1
ORDER BY cnt DESC;


SELECT sellersid, salesdate, COUNT(*) AS cnt FROM item_sales_raw
GROUP BY sellersid, salesdate HAVING COUNT(*) <> 1
ORDER BY cnt DESC;


----**************************************************************************************----
-- RANK () FUNCTION
DROP TABLE item_sales_raw_v2;
CREATE TABLE item_sales_raw_v2 AS (
WITH rnked AS (
SELECT *, RANK() OVER ( PARTITION BY sellersid ORDER BY qty DESC) AS rnk
FROM item_sales_raw
ORDER BY sellersid, qty DESC
) 
SELECT salesid, sellersid, qty, salesdate, itemcode FROM 
rnked WHERE rnk <= (FLOOR((4-2+1)*RANDOM())+2)
);



ALTER TABLE item_sales_raw_v2 RENAME TO sales_data_raw;

SELECT * FROM sales_data_raw ORDER BY salesid;


SELECT *, RANK() OVER ( PARTITION BY sellersid ORDER BY qty DESC) AS sales_qty_rnk FROM sales_data_raw
ORDER BY sellersid;


SELECT *, RANK() OVER ( PARTITION BY sellersid ORDER BY qty DESC) AS qty_rnk,
DENSE_RANK() OVER ( PARTITION BY sellersid ORDER BY qty DESC) AS qty_dense_rnk FROM item_sales_raw_v2
ORDER BY sellersid;


SELECT *, DENSE_RANK() OVER ( PARTITION BY sellersid ORDER BY qty DESC) AS qty_drnk FROM item_sales_raw_v2
ORDER BY sellersid;


EXPLAIN WITH prev_sales AS (
SELECT *, LAG(qty, 1, 0) OVER (PARTITION BY sellersid ORDER BY salesdate ASC) AS prev_sales_qty FROM item_sales_raw)
SELECT *, (qty - prev_sales_qty) AS sales_delta FROM prev_sales
ORDER BY sellersid, salesdate ASC;

update item_sales_raw SET salesid ='dumb' WHERE salesid ='svrt77065';

EXPLAIN SELECT * FROM item_sales_raw  LIMIT 10;
SELECT * FROM item_sales_raw  WHERE salesid ='dumb';

UPDATE item_sales_raw SET qty = NULL WHERE sellersid ='0A' AND salesdate ='2020-07-14';

WITH next_sales AS (
SELECT *, LEAD(coalesce(qty, 0), 1, 0) OVER (PARTITION BY sellersid ORDER BY salesdate ASC) AS next_sales_qty FROM item_sales_raw)
SELECT *, ( next_sales_qty - qty) AS sales_delta FROM next_sales
ORDER BY sellersid, salesdate ASC;


SELECT *, SUM(qty) OVER (PARTITION BY sellersid ORDER BY salesdate ASC) AS next_sales_qty FROM item_sales_raw;


BEGIN;
EXPLAIN (ANALYZE) SELECT DISTINCT sellersid FROM item_sales_raw;
ROLLBACK;


BEGIN;
EXPLAIN TRUNCATE item_sales_raw;
ROLLBACK;


TRUNCATE item_sales_raw;

SELECT * FROM information_schema.tables WHERE table_schema = 'pg_catalog';


SELECT * FROM information_schema.user_mappings;
SELECT * FROM pg_catalog.pg_class;
SELECT * FROM pg_catalog.nsp ;

SELECT * FROM pg_catalog.user_mappings;


SELECT salesid FROM item_sales_raw WHERE salesid ILIKE 'A%';


CREATE OR REPLACE PROCEDURE copy_schema(source_schema VARCHAR(100), target_schema VARCHAR(100))
LANGUAGE plpgsql
 AS $$
 BEGIN
EXECUTE 'CREATE SCHEMA IF NOT EXISTS trgd' USING $2;
--EXECUTE format('CREATE SCHEMA IF NOT EXISTS $1', $2);
END $$;

CALL copy_schema('my_schema', 'target_schema');

SET SEARCH_PATH TO target_schema;
--DROP SCHEMA target_schema CASCADE;


