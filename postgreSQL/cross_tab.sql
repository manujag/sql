SET SEARCH_PATH TO sales_report;


-- check the table data
SELECT * FROM sellers_item_qty;



-- cross tab query
SELECT *
FROM crosstab(
  'SELECT sellersid, itemcode, SUM(qty) AS qty FROM sellers_item_qty
GROUP BY sellersid, itemcode ORDER BY sellersid, itemcode',
   'SELECT DISTINCT itemcode FROM sellers_item_qty ORDER BY 1 LIMIT 5')
AS ct(seller_id text, a1_total INTEGER, a2_total INTEGER, a3_total INTEGER, a4_total INTEGER, a5_total INTEGER);




