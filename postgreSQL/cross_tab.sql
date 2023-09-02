SET SEARCH_PATH TO sales_report;

SELECT * FROM sellers_item_qty;


SELECT *
FROM crosstab(
  'select sellersid, itemcode, SUM(qty) as qty 
   from sellers_item_qty
GROUP BY sellersid, itemcode
   order by sellersid, itemcode',
   'SELECT DISTINCT itemcode FROM sellers_item_qty ORDER BY 1 LIMIT 5')
AS ct(seller_id text, a1_total INTEGER, a2_total INTEGER, a3_total INTEGER, a4_total INTEGER, a5_total INTEGER);


