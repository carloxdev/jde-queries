
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_E" ("BENEFICIARIO", "PROVEEDOR", "ANIO", "PERIODO", "DOC_COMPANIA", "DOC_TIPO", "DOC", "MONTO_PAGO", "PASIVO_COMPANIA", "PASIVO_TIPO", "PASIVO", "PASIVO_MONTO", "FACTURA", "FECHA_LM", "UN", "CUENTA", "CUENTA_NUMERO", "CUENTA_CLASE_DESC", "CUENTA_TIPO", "CUENTA_FLUJO", "CUENTA_DESC", "MONTO_DSTB", "FPAGO", "MONEDA", "MONTO_PAGO_EX", "CUENTA_BANCO") AS 
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
  WHEN PASIVOS.CUENTA IS NOT NULL AND PASIVOS.CUENTA_CLASE_DESC IS NULL THEN CSCONVERT('OTROS','NCHAR_CS' )
  WHEN PASIVOS.CUENTA_DESC='SERV PROFES DE PERSONA MORALES' AND ((PAYMENTS.CREADOR = 'SFERREIRAH' OR PAYMENTS.CREADOR = 'MPALACIOSM' OR PAYMENTS.CREADOR = 'SORGANISTT' OR PAYMENTS.CREADOR = 'PLEALG'  ) AND (PAYMENTS.DOC_TIPO= 'PS' OR PAYMENTS.DOC_TIPO= 'PQ')) OR PAYMENTS.DOC_TIPO= 'P2'  THEN CSCONVERT('NOMINA OUTSOURCING','NCHAR_CS' ) 
  WHEN PASIVOS.CUENTA_DESC='SERV PROFES DE PERSONA MORALES' AND NOT ((PAYMENTS.CREADOR = 'SFERREIRAH' OR PAYMENTS.CREADOR = 'MPALACIOSM' OR PAYMENTS.CREADOR = 'SORGANISTT' OR PAYMENTS.CREADOR = 'PLEALG'  ) AND (PAYMENTS.DOC_TIPO= 'PS' OR PAYMENTS.DOC_TIPO= 'PQ')) OR PAYMENTS.DOC_TIPO= 'P2'  THEN CSCONVERT('SERVICIOS','NCHAR_CS' ) 
  WHEN PAYMENTS.DOC_TIPO = 'P5' THEN CSCONVERT('VIATICOS','NCHAR_CS' )
  WHEN INSTR(PASIVOS.CUENTA_NUMERO,'.2135.', 1, 1) > 0  THEN CSCONVERT('TARJETA CREDITO','NCHAR_CS' )
  WHEN PAYMENTS.DOC_TIPO = 'PJ' THEN CSCONVERT('IMPUESTOS','NCHAR_CS' )
   WHEN PAYMENTS.DOC_TIPO = 'PX' THEN CSCONVERT('NOMINA IMSS','NCHAR_CS' )
  WHEN (INSTR(PASIVOS.CUENTA_NUMERO,'.112', 1, 1) > 0 AND (PAYMENTS.BENEFICIARIO >=1 AND PAYMENTS.BENEFICIARIO <=99 ))  THEN CSCONVERT('COMPANIAS','NCHAR_CS' )
  WHEN (INSTR(PASIVOS.CUENTA_NUMERO,'.112', 1, 1) > 0 AND (PAYMENTS.BENEFICIARIO >=60000 AND PAYMENTS.BENEFICIARIO <=69999))  THEN CSCONVERT('ACREDORES','NCHAR_CS' )
 WHEN (INSTR(PASIVOS.CUENTA_NUMERO,'.112', 1, 1) > 0 AND (PAYMENTS.BENEFICIARIO >=70000 AND PAYMENTS.BENEFICIARIO <=79999))  THEN CSCONVERT('ACREDORES','NCHAR_CS' )
WHEN (INSTR(PASIVOS.CUENTA_NUMERO,'.112', 1, 1) > 0 AND (PAYMENTS.BENEFICIARIO >=200000 AND PAYMENTS.BENEFICIARIO <=299999))  THEN CSCONVERT('VIATICOS','NCHAR_CS' ) 
WHEN (INSTR(PASIVOS.CUENTA_NUMERO,'.112', 1, 1) > 0 AND (PAYMENTS.BENEFICIARIO >=200000 AND PAYMENTS.BENEFICIARIO <=299999))  THEN CSCONVERT('VIATICOS','NCHAR_CS' ) 
WHEN (INSTR(PASIVOS.CUENTA_NUMERO,'.1182.', 1, 1) > 0 )  THEN CSCONVERT('MATERIALES','NCHAR_CS' ) 
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

,CASE 
  WHEN PASIVOS.CUENTA IS NULL THEN  PAYMENTS.PASIVO_MONTO
  ELSE ROUND(PAYMENTS.PASIVO_MONTO * (PASIVOS.PORCENTAJE / 100),2) 
END MONTO_DSTB
  ,PAYMENTS.FPAGO
        ,PAYMENTS.MONEDA
        ,PAYMENTS.MONTO_PAGO_EX
        ,PAYMENTS.CUENTA_BANCO
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
        ,FACTURAS.CREADOR
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
        ,PAGOS.FPAGO
        ,PAGOS.MONEDA
        ,PAGOS.MONTO_PAGO_EX
        ,PAGOS.CUENTA AS CUENTA_BANCO
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
                              ,RPTORG as CREADOR
                            from PRODDTA.F0411  
                            where 1=1
                            AND RPSFX = '001'
                            GROUP BY
                               RPKCO
                              ,RPDCT
                              ,RPDOC
                              ,RPMCU
                              ,RPTORG
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
             ON PASIVOS.DOC_COMPANIA = PAYMENTS.PASIVO_COMPANIA
            AND PASIVOS.DOC_TIPO = PAYMENTS.PASIVO_TIPO
            AND PASIVOS.DOC = PAYMENTS.PASIVO 
order by PAYMENTS.PERIODO, PAYMENTS.DOC_COMPANIA, PAYMENTS.DOC_TIPO, PAYMENTS.DOC;
