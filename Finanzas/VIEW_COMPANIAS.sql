
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_COMPANIAS" ("COMP_CODE", "COMP_DESC", "COMP_BOOK_CODE", "BOOK_DESC") AS 
  SELECT
  CCCO as COMP_CODE,
  trim(CCNAME) AS COMP_DESC,
  CCAN8 as COMP_BOOK_CODE,
  trim(ABALPH || ALADD1) AS BOOK_DESC
FROM PRODDTA.F0010
LEFT OUTER JOIN PRODDTA.F0101 ON ABAN8 = CCAN8
LEFT OUTER JOIN PRODDTA.F0116 ON CCAN8 = ALAN8 AND ALEFTB = 0
WHERE 1=1
and CCAN8 not in (0,5)
order by CCCO;