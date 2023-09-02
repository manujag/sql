# CROSSTAB sample query
```
SELECT * FROM sellers_item_qty;
```

The table looks something like below:
|sellersid|itemcode|qty|
|---------|--------|---|
|0A       |A2      |75 |
|0A       |A5      |98 |
|0A       |A7      |61 |
|0B       |B4      |70 |
|0B       |C1      |19 |
|0B       |C6      |51 |
|0C       |A3      |22 |
|0C       |D1      |35 |
|0C       |E7      |93 |
|0D       |A3      |45 |
|0D       |A6      |84 |
|0D       |B8      |80 |

After this we use the crosstab to get below:

|seller_id|a1_total|a2_total|a3_total|a4_total|a5_total|
|---------|--------|--------|--------|--------|--------|
|0A       |        |78      |        |        |98      |
|0B       |        |        |        |        |        |
|0C       |        |        |22      |        |        |
|0D       |        |        |45      |        |        |
|0E       |        |125     |        |        |        |
|0F       |70      |42      |        |87      |        |
|0G       |        |22      |        |        |        |
|0H       |        |        |19      |        |13      |
|0I       |38      |        |        |91      |        |
|0J       |        |        |        |        |        |
|0K       |        |        |        |        |        |
|0L       |        |        |        |65      |        |
|0M       |        |        |        |        |        |
|0N       |15      |        |        |        |        |
|0O       |        |        |        |        |        |

The results might differ based on data.
