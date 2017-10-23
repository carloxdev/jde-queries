
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_INVENTARIO" ("PROYECTO_CVE", "PROYECTO_DESC", "ARTICULO_CVE", "ARTICULO_DESC", "IMGLPT", "UN_CVE", "UN_DESC", "FECHA_RECEPCION", "CANTIDAD_RECEP", "COSTOUNIMIN", "COSTOUNIAVG", "COSTOUNIMAX") AS 
  SELECT  TRIM(DRKY) AS PROYECTO_CVE, 
        mcdl01 AS PROYECTO_DESC, 
        ILLITM AS ARTICULO_CVE, 
        MERCANCIA AS ARTICULO_DESC, 
        IMGLPT, 
        ILMCU AS UN_CVE, 
        MCDC AS UN_DESC, 
        FECHA_RECEPCION, 
        CANTIDAD_RECEP, 
        COSTOUNIMIN,  
        COSTOUNIAVG,  
        COSTOUNIMAX  
FROM (    
       SELECT mcdl01, ILLITM, CONCAT(IMDSC1, IMDSC2) AS MERCANCIA,  
              IMGLPT,  
              DRKY, 
              DRDL01,  
              ILMCU,  
              MCDC,  
              MAX(CASE WHEN PRRCDJ <> 0 THEN TO_DATE(1900000 + PRRCDJ, 'YYYYDDD') END) AS FECHA_RECEPCION,   
              SUM(proddta.F4111.ILTRQT / 10000) AS CANTIDAD_RECEP,   
              MIN(CASE WHEN proddta.F4111.ILUNCS > 0 THEN proddta.F4111.ILUNCS / 10000  END) COSTOUNIMIN,  
              AVG(CASE WHEN proddta.F4111.ILUNCS > 0 THEN proddta.F4111.ILUNCS / 10000  END) COSTOUNIAVG,  
              MAX(CASE WHEN proddta.F4111.ILUNCS > 0 THEN proddta.F4111.ILUNCS / 10000  END) COSTOUNIMAX  
          from proddta.F4111   
          LEFT JOIN proddta.F4101 ON IMLITM = ILLITM   
          LEFT JOIN    
          (            
                SELECT prlitm, prmcu, MAX(PRRCDJ) AS PRRCDJ   
                 FROM   PRODDTA.F43121     
                 GROUP BY prlitm, prmcu    
          )  RECEP ON ILLITM = prlitm  AND  ILMCU = prmcu      
          LEFT JOIN PRODDTA.F0006 ON ILMCU = MCMCU  
          LEFT OUTER JOIN PRODCTL.F0005 PROYECTO                 
                ON PROYECTO.DRSY = '00'                     
                AND PROYECTO.DRRT = '01' 
                AND TRIM(PROYECTO.DRKY) = TRIM(F0006.MCRP01) 
          GROUP BY   mcdl01, ILLITM, CONCAT(IMDSC1, IMDSC2), IMGLPT, DRKY, DRDL01, ILMCU, MCDC, CASE WHEN PRRCDJ <> 0 THEN TO_DATE(1900000 + PRRCDJ, 'YYYYDDD') END   
          having SUM(proddta.F4111.ILTRQT / 10000) > 0    
       )     
WHERE 1=1 
;
