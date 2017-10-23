
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_ES" ("BENEFICIARIO", "PROVEEDOR", "ANIO", "PERIODO", "DOC_COMPANIA", "DOC_TIPO", "DOC", "MONTO_PAGO", "FACTURA", "FECHA_LM", "UN", "CUENTA", "CUENTA_NUMERO", "CUENTA_CLASE_DESC", "CUENTA_TIPO", "CUENTA_FLUJO", "CUENTA_DESC", "MONTO") AS 
  select
PAYMENTS.BENEFICIARIO
,PAYMENTS.PROVEEDOR
,PAYMENTS.ANIO
,PAYMENTS.PERIODO

,PAYMENTS.DOC_COMPANIA
,PAYMENTS.DOC_TIPO
,PAYMENTS.DOC
,PAYMENTS.MONTO_PAGO 

,NVL(PASIVOS.FACTURA,'-') as FACTURA
,PASIVOS.FECHA_LM

,TRIM(PASIVOS.UN) as UN

,NVL(PASIVOS.CUENTA,'-') as CUENTA
,NVL(PASIVOS.CUENTA_NUMERO,'-') AS CUENTA_NUMERO

,CASE 
  WHEN PASIVOS.CUENTA IS NULL     AND PASIVOS.CUENTA_CLASE_DESC IS NULL AND PAYMENTS.DOC_TIPO = 'PE' THEN CSCONVERT('NOMINA OUTSOURCING','NCHAR_CS' )
  WHEN PASIVOS.CUENTA IS NULL     AND PASIVOS.CUENTA_CLASE_DESC IS NULL AND PAYMENTS.DOC_TIPO <> 'PE' THEN CSCONVERT('ANTICIPOS SIN FACTURA','NCHAR_CS' )
  WHEN PASIVOS.CUENTA IS NOT NULL AND PASIVOS.CUENTA_CLASE_DESC IS NULL THEN CSCONVERT('SIN CLASIFICACION','NCHAR_CS' )
  ELSE PASIVOS.CUENTA_CLASE_DESC
END CUENTA_CLASE_DESC       

,case
  WHEN  PASIVOS.CUENTA IS NULL THEN CSCONVERT('-','NCHAR_CS' )
  ELSE  PASIVOS.CUENTA_TIPO
END CUENTA_TIPO

,case
  WHEN  PASIVOS.CUENTA IS NULL THEN CSCONVERT('EGR','NCHAR_CS' )
  ELSE  PASIVOS.CUENTA_FLUJO
END CUENTA_FLUJO

,CASE
  WHEN PASIVOS.CUENTA IS NULL AND PAYMENTS.DOC_TIPO = 'PE' THEN CSCONVERT('PRESTAMOS','NCHAR_CS' )
  WHEN PASIVOS.CUENTA IS NULL AND PAYMENTS.DOC_TIPO = 'P5' THEN CSCONVERT('VIATICOS SIN COMPROBAR','NCHAR_CS' )
  WHEN PASIVOS.CUENTA IS NULL AND PAYMENTS.DOC_TIPO = 'DG' THEN CSCONVERT('DEPOSITOS EN GARANTIA','NCHAR_CS' )
  WHEN PASIVOS.CUENTA IS NULL AND PAYMENTS.DOC_TIPO = 'PQ' THEN CSCONVERT('COMPRAS','NCHAR_CS' )
  WHEN PASIVOS.CUENTA IS NULL AND PAYMENTS.DOC_TIPO NOT IN ('PE','P5','DG','PQ') THEN CSCONVERT('OTROS','NCHAR_CS' )
  ELSE PASIVOS.CUENTA_DESC
END CUENTA_DESC

,PAYMENTS.MONTO_PENDIENTE AS MONTO

from (
        select
            PAGOS.beneficiario
            ,PAGOS.proveedor
            ,PAGOS.anio
            ,PAGOS.periodo
            
            ,PAGOS.DOC_COMPANIA
            ,PAGOS.DOC_TIPO
            ,PAGOS.DOC
          
            ,PAGOS.MONTO_TOTAL_MX as MONTO_PAGO
            
            ,APLICACIONES.MONTO_APLICADO
            
            ,(PAGOS.MONTO_TOTAL_MX - APLICACIONES.MONTO_APLICADO) AS MONTO_PENDIENTE
          
        from NUVPD.VIEW_EPAGOS PAGOS
        
        INNER JOIN (
                      select
                      ANTICIPO_COMPANIA
                      ,ANTICIPO_TIPO
                      ,ANTICIPO
                      ,SUM(MONTO_APLICADO) as MONTO_APLICADO
                      from NUVPD.VIEW_EAPLICANTICIPOS
                      GROUP BY
                      ANTICIPO_COMPANIA
                      ,ANTICIPO_TIPO
                      ,ANTICIPO  
                            
                   ) APLICACIONES
                  on APLICACIONES.ANTICIPO_COMPANIA = PAGOS.DOC_COMPANIA
                 and APLICACIONES.ANTICIPO_TIPO = PAGOS.DOC_TIPO
                 and APLICACIONES.ANTICIPO = PAGOS.DOC                
        where 1=1
        and PAGOS.MONTO_TOTAL_MX  > MONTO_APLICADO
        and PAGOS.DOC_TIPO not in ('PE')
    ) PAYMENTS
    
LEFT OUTER JOIN (
                      SELECT
                        DOC_COMPANIA
                        ,DOC_TIPO
                        ,DOC
                        ,PROVEEDOR
                        ,UN
                        ,FACTURA
                        ,FECHA_LM
                        ,MONTO_TOTAL_MX
                        ,CUENTA_NUMERO
                        ,CUENTA
                        ,CUENTA_DESC
                        ,CUENTA_CLASE_DESC
                        ,CUENTA_TIPO
                        ,CUENTA_FLUJO
                        ,CUENTA_UN
                        ,ROUND (     
                                  ( MONTO * 100) / SUM(MONTO) OVER (PARTITION BY DOC_COMPANIA, DOC_TIPO, DOC)
                               ,4) PORCENTAJE
                      FROM (
                                SELECT
                                  FACTURAS.DOC_COMPANIA
                                  ,FACTURAS.DOC_TIPO
                                  ,FACTURAS.DOC
                                  ,FACTURAS.PROVEEDOR
                                  ,FACTURAS.UN
                                  ,FACTURAS.FACTURA
                                  ,FACTURAS.FECHA_LM
                                  ,FACTURAS.MONTO_TOTAL_MX
                                  ,ASIENTOS.CUENTA_NUMERO
                                  ,ASIENTOS.CUENTA
                                  ,ASIENTOS.CUENTA_DESC
                                  ,ASIENTOS.CUENTA_CLASE
                                  ,ASIENTOS.CUENTA_CLASE_DESC
                                  ,ASIENTOS.CUENTA_TIPO
                                  ,ASIENTOS.CUENTA_TIPO_DESC
                                  ,ASIENTOS.CUENTA_FLUJO
                                  ,ASIENTOS.CUENTA_FLUJO_DESC
                                  ,ASIENTOS.CUENTA_UN
                                  ,SUM(ASIENTOS.MONTO) AS MONTO
                                  
                                FROM NUVPD.VIEW_EFACTURARECEP FACTURAS
                                LEFT OUTER JOIN NUVPD.VIEW_EASIENTOS ASIENTOS
                                             on ASIENTOS.DOC_COMPANIA = FACTURAS.RECEP_COMPANIA
                                            AND ASIENTOS.DOC_TIPO = FACTURAS.RECEP_TIPO
                                            AND ASIENTOS.DOC = FACTURAS.RECEP_doc
                                
                                group by
                                
                                  FACTURAS.DOC_COMPANIA
                                  ,FACTURAS.DOC_TIPO
                                  ,FACTURAS.DOC
                                  ,FACTURAS.PROVEEDOR
                                  ,FACTURAS.UN
                                  ,FACTURAS.FACTURA
                                  ,FACTURAS.FECHA_LM
                                  ,FACTURAS.MONTO_TOTAL_MX
                                  ,ASIENTOS.CUENTA_NUMERO
                                  ,ASIENTOS.CUENTA
                                  ,ASIENTOS.CUENTA_DESC
                                  ,ASIENTOS.CUENTA_CLASE
                                  ,ASIENTOS.CUENTA_CLASE_DESC
                                  ,ASIENTOS.CUENTA_TIPO
                                  ,ASIENTOS.CUENTA_TIPO_DESC
                                  ,ASIENTOS.CUENTA_FLUJO
                                  ,ASIENTOS.CUENTA_FLUJO_DESC
                                  ,ASIENTOS.CUENTA_UN
                           ) 

                ) PASIVOS
             ON PASIVOS.DOC_COMPANIA = PAYMENTS.DOC_COMPANIA
            AND PASIVOS.DOC_TIPO = PAYMENTS.DOC_TIPO
            AND PASIVOS.DOC = PAYMENTS.DOC
            
order by PAYMENTS.PERIODO, PAYMENTS.DOC_COMPANIA, PAYMENTS.DOC_TIPO, PAYMENTS.DOC;
