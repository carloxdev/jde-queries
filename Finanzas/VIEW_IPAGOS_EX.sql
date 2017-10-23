
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_IPAGOS_EX" ("BENEFICIARIO", "CLIENTE", "DOC_COMPANIA", "DOC_TIPO", "DOC", "ANIO", "PERIODO", "MONTO_MX", "MONTO_EX") AS 
  SELECT CABECERA.RYPYR AS BENEFICIARIO,
            LINEA.RZAN8 AS CLIENTE,
            LINEA.RZKCO AS DOC_COMPANIA,
            LINEA.RZDCT AS DOC_TIPO,
            LINEA.RZDOC AS DOC_NUMERO,
            LINEA.RZFY AS ANIO,
            LINEA.RZPN AS PERIODO,
            SUM ( (LINEA.RZPAAP / 100) * -1) AS MONTO_TOTAL_MX,
            SUM ( (LINEA.RZPFAP / 100) * -1) AS MONTO_TOTAL_EX
       FROM    PRODDTA.F03B13 CABECERA
            LEFT OUTER JOIN
               PRODDTA.F03B14 LINEA
            ON CABECERA.RYPYID = LINEA.RZPYID
      WHERE     1 = 1
            AND LINEA.RZVDGJ = 0                         --< QUITAMOS ANULADOS
            AND LINEA.RZDCT IN ('RI', 'RM')            --< SOLO REGISTRO DE FACTURAS
            AND LINEA.RZPFAP <> 0                --< SOLO REGISTROS DE DOLARES
   GROUP BY CABECERA.RYPYR,
            LINEA.RZAN8,
            LINEA.RZKCO,
            LINEA.RZDCT,
            LINEA.RZDOC,
            LINEA.RZCTRY,
            LINEA.RZFY,
            LINEA.RZPN;
