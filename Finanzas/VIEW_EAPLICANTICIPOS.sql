
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_EAPLICANTICIPOS" ("PAGO_ID", "PAGO_NUMERO", "BENEFICIARIO", "FACTURA_COMPANIA", "FACTURA_TIPO", "FACTURA", "FACTURA_MONTO", "FACTURA_CANTIDAD", "ANTICIPO_COMPANIA", "ANTICIPO_TIPO", "ANTICIPO", "ANTICIPO_MONTO", "ANTICIPO_CANTIDAD", "MONTO_APLICADO") AS 
  SELECT
FACTURAS.PAGO_ID
,FACTURAS.PAGO_NUMERO
,FACTURAS.BENEFICIARIO
,FACTURAS.FACTURA_COMPANIA
,FACTURAS.FACTURA_TIPO
,FACTURAS.FACTURA
,FACTURAS.FACTURA_MONTO
,FACTURAS.FACTURA_CANTIDAD
,ANTICIPOS.ANTICIPO_COMPANIA
,ANTICIPOS.ANTICIPO_TIPO
,ANTICIPOS.ANTICIPO
,ANTICIPOS.ANTICIPO_MONTO
,ANTICIPOS.ANTICIPO_CANTIDAD
,CASE 
  WHEN  FACTURAS.FACTURA_MONTO > ANTICIPOS.ANTICIPO_MONTO THEN ANTICIPOS.ANTICIPO_MONTO
  WHEN  FACTURAS.FACTURA_MONTO < ANTICIPOS.ANTICIPO_MONTO THEN FACTURAS.FACTURA_MONTO
  ELSE  ANTICIPOS.ANTICIPO_MONTO
END AS MONTO_APLICADO
FROM (

        SELECT
          CPAG.RMPYID as PAGO_ID
          ,CPAG.RMDOCM as PAGO_NUMERO
          ,CPAG.RMPYE as BENEFICIARIO 
          ,LPAG.RNKCO  AS FACTURA_COMPANIA
          ,LPAG.RNDCT AS FACTURA_TIPO
          ,LPAG.RNDOC as FACTURA
          ,SUM((LPAG.RNPAAP/100) * -1) AS FACTURA_MONTO
          ,COUNT(*) OVER (PARTITION BY CPAG.RMPYID) AS FACTURA_CANTIDAD
          from PRODDTA.F0413 CPAG
          left outer join PRODDTA.F0414 LPAG
                       on LPAG.RNPYID = CPAG.RMPYID
          WHERE 1=1
          and CPAG.RMVDGJ = 0       --<- QUITAMOS LAS APLICACIONES ANULADAS
          and LPAG.RNDCTM in ('PN','PG') --<- Solo registros de aplicaciones y su perdida o ganancia cambiaria
          and CPAG.RMDCTM = 'PN'  --<- Solo registros de aplicaciones
          AND LPAG.RNPAAP < 0   --<- Solo registros de facturas
          
          GROUP BY
            CPAG.RMPYID
            ,CPAG.RMDOCM
            ,CPAG.RMPYE
            ,LPAG.RNKCO 
            ,LPAG.RNDCT
            ,LPAG.RNDOC
            
    ) FACTURAS
LEFT OUTER JOIN (

                  SELECT
                    CPAG.RMPYID as PAGO_ID
                    ,CPAG.RMDOCM as PAGO_NUMERO
                    ,CPAG.RMPYE as BENEFICIARIO 
                    ,LPAG.RNKCO  AS ANTICIPO_COMPANIA
                    ,LPAG.RNDCT AS ANTICIPO_TIPO
                    ,LPAG.RNDOC as ANTICIPO
                    ,SUM(LPAG.RNPAAP/100) AS ANTICIPO_MONTO
                    ,COUNT(*) OVER (PARTITION BY CPAG.RMPYID) AS ANTICIPO_CANTIDAD
                    from PRODDTA.F0413 CPAG
                    left outer join PRODDTA.F0414 LPAG
                                 on LPAG.RNPYID = CPAG.RMPYID
                    WHERE 1=1       
                    and CPAG.RMVDGJ = 0       --<- QUITAMOS LAS APLICACIONES ANULADAS
                    AND LPAG.RNDCTM = 'PN'   --<- Solo registros de aplicaciones
                    and CPAG.RMDCTM = 'PN'    --<- Solo registros de aplicaciones
                    AND LPAG.RNPAAP > 0   --<- Solo registros de anticipos      
                    
                    GROUP BY
                      CPAG.RMPYID
                      ,CPAG.RMDOCM
                      ,CPAG.RMPYE
                      ,LPAG.RNKCO 
                      ,LPAG.RNDCT
                      ,LPAG.RNDOC
                ) ANTICIPOS
            ON ANTICIPOS.PAGO_ID = FACTURAS.PAGO_ID
WHERE 1=1
AND (
        FACTURAS.FACTURA_CANTIDAD = 1 
        AND ANTICIPOS.ANTICIPO_CANTIDAD > 1
    )
OR  (    
        FACTURAS.FACTURA_CANTIDAD > 1 
        AND ANTICIPOS.ANTICIPO_CANTIDAD = 1
    )
OR  (
        FACTURAS.FACTURA_CANTIDAD = 1 
        AND ANTICIPOS.ANTICIPO_CANTIDAD = 1
    )

ORDER BY FACTURAS.PAGO_ID,FACTURAS.FACTURA;
