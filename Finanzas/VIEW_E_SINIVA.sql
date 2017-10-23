
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_E_SINIVA" ("BENEFICIARIO", "PROVEEDOR", "ANIO", "PERIODO", "DOC_COMPANIA", "DOC_TIPO", "DOC", "MONTO_PAGO", "PASIVO_COMPANIA", "PASIVO_TIPO", "PASIVO", "PASIVO_MONTO", "FACTURA", "FECHA_LM", "UN", "CUENTA", "CUENTA_NUMERO", "CUENTA_CLASE_DESC", "CUENTA_TIPO", "CUENTA_FLUJO", "CUENTA_DESC", "MONTO_DSTB") AS 
  SELECT
PAYMENTS.BENEFICIARIO
,PAYMENTS.PROVEEDOR
,PAYMENTS.ANIO
,PAYMENTS.PERIODO

,PAYMENTS.DOC_COMPANIA
,PAYMENTS.DOC_TIPO
,PAYMENTS.DOC
,PAYMENTS.MONTO_PAGO 

,PAYMENTS.PASIVO_COMPANIA
,PAYMENTS.PASIVO_TIPO
,PAYMENTS.PASIVO
,PAYMENTS.PASIVO_MONTO

,NVL(PASIVOS.FACTURA,'-') as FACTURA
,PASIVOS.FECHA_LM

,NVL(case 
  when PAYMENTS.DOC_TIPO = 'P5' THEN TRIM(PAYMENTS.UN)
  when PAYMENTS.DOC_TIPO <> 'P5' and PASIVOS.CUENTA is null then TRIM(PAYMENTS.UN)
  when PAYMENTS.DOC_TIPO <> 'P5' and PASIVOS.CUENTA is not null then TRIM(PASIVOS.CUENTA_UN)
end,'-') UN

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

,case 
  when PASIVOS.CUENTA is null then   PAYMENTS.PASIVO_MONTO / (1   + TASA /100)
  ELSE ROUND((PAYMENTS.PASIVO_MONTO / (1   + TASA /100) ) * (PASIVOS.PORCENTAJE / 100),2) 
  --ELSE PASIVOS.ASIENTO_MONTO
END MONTO_DSTB

FROM (
        select
        PAGOS.beneficiario
        ,PAGOS.proveedor
        ,PAGOS.anio
        ,PAGOS.periodo
        
        ,PAGOS.DOC_COMPANIA
        ,PAGOS.DOC_TIPO
        ,PAGOS.DOC
        
        ,FACTURAS.UN
        ,PAGOS.MONTO_TOTAL_MX as MONTO_PAGO
      
        ,case 
          WHEN APLICACIONES.ANTICIPO_COMPANIA IS NULL THEN PAGOS.DOC_COMPANIA
          ELSE APLICACIONES.FACTURA_COMPANIA
        END PASIVO_COMPANIA
        
        ,case 
          WHEN APLICACIONES.ANTICIPO_TIPO IS NULL THEN PAGOS.DOC_TIPO
          ELSE APLICACIONES.FACTURA_TIPO
        END PASIVO_TIPO
        
        ,case 
          WHEN APLICACIONES.ANTICIPO IS NULL THEN PAGOS.DOC
          ELSE APLICACIONES.FACTURA
        END PASIVO
        
        ,CASE 
          WHEN APLICACIONES.ANTICIPO IS NULL THEN PAGOS.MONTO_TOTAL_MX
          ELSE APLICACIONES.MONTO_APLICADO
        END PASIVO_MONTO
        
        from NUVPD.VIEW_EPAGOS PAGOS
        
        left outer join (
                            select
                            FACTURA_COMPANIA
                            ,FACTURA_TIPO
                            ,FACTURA
                            ,ANTICIPO_COMPANIA
                            ,ANTICIPO_TIPO
                            ,ANTICIPO
                            ,SUM(MONTO_APLICADO) AS MONTO_APLICADO
                            from nuvpd.VIEW_EAPLICANTICIPOS
                            GROUP BY
                            FACTURA_COMPANIA
                            ,FACTURA_TIPO
                            ,FACTURA
                            ,ANTICIPO_COMPANIA
                            ,ANTICIPO_TIPO
                            ,ANTICIPO
        
                        ) APLICACIONES
                     on APLICACIONES.ANTICIPO_COMPANIA = PAGOS.DOC_COMPANIA
                    AND APLICACIONES.ANTICIPO_TIPO = PAGOS.DOC_TIPO
                    and APLICACIONES.ANTICIPO = PAGOS.DOC
                    
        left outer join (
                            select
                               RPKCO as COMPANIA
                              ,RPDCT as TIPO
                              ,RPDOC as DOC
                              ,RPMCU as UN
                            from PRODDTA.F0411  
                            where 1=1
                            AND RPSFX = '001'
                            GROUP BY
                               RPKCO
                              ,RPDCT
                              ,RPDOC
                              ,RPMCU
                        ) FACTURAS
                     on FACTURAS.COMPANIA = PAGOS.DOC_COMPANIA
                    and FACTURAS.TIPO = PAGOS.DOC_TIPO
                    AND FACTURAS.DOC = PAGOS.DOC                    
                    
       WHERE 1=1
       AND PAGOS.DOC_TIPO NOT IN ('PE')
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
                        ,TASA
                        ,CUENTA_NUMERO
                        ,CUENTA
                        ,CUENTA_DESC
                        ,CUENTA_CLASE_DESC
                        ,CUENTA_TIPO
                        ,CUENTA_FLUJO
                        ,CUENTA_UN
                        ,MONTO AS ASIENTO_MONTO
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
                                  ,case 
                                    when FACTURAS.TASA < 0 then 0
                                    else FACTURAS.TASA
                                   END AS TASA                            
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
                                  
                                FROM NUVPD.VIEW_EFACTURARECEP_2 FACTURAS
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
                                  ,FACTURAS.TASA
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
             ON PASIVOS.DOC_COMPANIA = PAYMENTS.PASIVO_COMPANIA
            AND PASIVOS.DOC_TIPO = PAYMENTS.PASIVO_TIPO
            AND PASIVOS.DOC = PAYMENTS.PASIVO
            
WHERE 1=1

order by PAYMENTS.PERIODO, PAYMENTS.DOC_COMPANIA, PAYMENTS.DOC_TIPO, PAYMENTS.DOC;
