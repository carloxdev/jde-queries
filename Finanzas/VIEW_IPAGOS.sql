
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_IPAGOS" ("BENEFICIARIO", "FCOBRO", "MONEDA_COBRO", "MONTO_COBRO_TOTAL", "CLIENTE", "DOC_COMPANIA", "DOC_TIPO", "DOC", "ANIO", "PERIODO", "MONTO_MX", "CUENTA") AS 
  SELECT CABECERA.RYPYR AS BENEFICIARIO,
            TO_DATE(1900000 + CABECERA.RYDGJ,'YYYYDDD')  AS FCOBRO,
            CABECERA.RYCRCD AS MONEDA_COBRO,
            CASE
          WHEN CABECERA.RYCRCD  = 'MXP' THEN CABECERA.RYCKAM/100
          ELSE CABECERA.RYFCAM/100
           END MONTO_COBRO_TOTAL,
            LINEA.RZAN8 AS CLIENTE,
            LINEA.RZKCO AS DOC_COMPANIA,
            LINEA.RZDCT AS DOC_TIPO,
            LINEA.RZDOC AS DOC,
            CABECERA.RYFY AS ANIO,
            CABECERA.RYPN AS PERIODO,
            SUM ( (LINEA.RZPAAP / 100) * -1) AS MONTO_MX,
           
            CUENTA.GMDL01 AS CUENTA
            
       FROM    PRODDTA.F03B13 CABECERA
            LEFT OUTER JOIN
               PRODDTA.F03B14 LINEA
            ON CABECERA.RYPYID = LINEA.RZPYID
            LEFT OUTER JOIN  
               (SELECT GMAID,GMDL01  FROM PRODDTA.F0901) CUENTA
             ON  CABECERA.RYGLBA = CUENTA.GMAID
      WHERE 1 = 1 AND LINEA.RZVDGJ = 0                   --< QUITAMOS ANULADOS
                                      AND LINEA.RZDCT IN ('RI','RM') --< SOLO REGISTRO DE FACTURAS
GROUP BY CABECERA.RYPYR,
            CABECERA.RYDGJ,
            CABECERA.RYCRCD,
            CASE
            WHEN CABECERA.RYCRCD  = 'MXP' THEN CABECERA.RYCKAM/100
            ELSE CABECERA.RYFCAM/100
           END ,
            LINEA.RZAN8,
            LINEA.RZKCO,
            LINEA.RZDCT,
            LINEA.RZDOC,
            CABECERA.RYFY,
            CABECERA.RYPN,
            LINEA.RZPN,
            CUENTA.GMDL01
ORDER BY CABECERA.RYDGJ;