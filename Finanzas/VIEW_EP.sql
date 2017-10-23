
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_EP" ("PROVEEDOR", "UN", "COMPANIA", "DOC_TIPO", "DOC", "FACTURA", "FECHA_LM", "CUENTA", "CUENTA_NUMERO", "CUENTA_DESC", "CUENTA_CLASE_DESC", "CUENTA_TIPO", "CUENTA_FLUJO", "MONTO_PENDIENTE_MX", "TOTAL") AS 
  select

  PROVEEDOR
  ,case 
    when DOC_TIPO = 'P5' and CUENTA is null then UN
    when DOC_TIPO = 'P5' and CUENTA is not null then UN
    when DOC_TIPO <> 'P5' and CUENTA is null then UN
    when DOC_TIPO <> 'P5' and CUENTA is not null then CUENTA_UN
  end UN
  
  ,DOC_COMPANIA as COMPANIA
  ,DOC_TIPO
  ,DOC
  ,FACTURA
  ,FECHA_LM
  ,NVL(CUENTA,'-') as CUENTA
  ,NVL(CUENTA_NUMERO,'-') as CUENTA_NUMERO
  
  ,CASE
    WHEN CUENTA IS NULL AND DOC_TIPO = 'PE' THEN CSCONVERT('PRESTAMOS','NCHAR_CS' )
    WHEN CUENTA IS NULL AND DOC_TIPO = 'P5' THEN CSCONVERT('VIATICOS SIN COMPROBAR','NCHAR_CS' )
    WHEN CUENTA IS NULL AND DOC_TIPO = 'DG' THEN CSCONVERT('DEPOSITOS EN GARANTIA','NCHAR_CS' )
    WHEN CUENTA IS NULL AND DOC_TIPO = 'PQ' THEN CSCONVERT('COMPRAS','NCHAR_CS' )
    WHEN CUENTA IS NULL AND DOC_TIPO NOT IN ('PE','P5','DG','PQ') THEN CSCONVERT('OTROS','NCHAR_CS' )
    ELSE CUENTA_DESC
  END CUENTA_DESC
  
  ,CASE 
    WHEN CUENTA IS NULL     AND CUENTA_CLASE_DESC IS NULL AND DOC_TIPO = 'PE' THEN CSCONVERT('NOMINA OUTSOURCING','NCHAR_CS' )
    WHEN CUENTA IS NULL     AND CUENTA_CLASE_DESC IS NULL AND DOC_TIPO <> 'PE' THEN CSCONVERT('ANTICIPOS SIN FACTURA','NCHAR_CS' )
    WHEN CUENTA IS NOT NULL AND CUENTA_CLASE_DESC IS NULL THEN CSCONVERT('SIN CLASIFICACION','NCHAR_CS' )
    ELSE CUENTA_CLASE_DESC
  END CUENTA_CLASE_DESC
  
  ,CASE
    WHEN CUENTA IS NULL THEN CSCONVERT('-','NCHAR_CS')
    ELSE CUENTA_TIPO
  END CUENTA_TIPO

  ,CASE
    when CUENTA is null then CSCONVERT('EGR','NCHAR_CS')
    ELSE CUENTA_FLUJO
  end CUENTA_FLUJO     
  
  ,MONTO_PENDIENTE_MX
  
  ,case
    when   NVL(ROUND(MONTO_PENDIENTE_MX * (PORCENTAJE/100),2),0) = 0 then MONTO_PENDIENTE_MX
    else   NVL(ROUND(MONTO_PENDIENTE_MX * (PORCENTAJE/100),2),0)
  END TOTAL
  
  
from (
          SELECT
            DOC_COMPANIA
            ,DOC_TIPO
            ,DOC
            ,PROVEEDOR
            ,UN
            ,FACTURA
            ,FECHA_LM
            ,CUENTA_NUMERO
            ,CUENTA
            ,CUENTA_DESC
            ,CUENTA_CLASE_DESC
            ,CUENTA_TIPO
            ,CUENTA_FLUJO
            ,CUENTA_UN
            ,MONTO_PENDIENTE_MX
            
            ,MONTO
            
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
                      
                      ,FACTURAS.MONTO_PENDIENTE_MX
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
                                and ASIENTOS.DOC = FACTURAS.RECEP_DOC
                    where 1=1
                    and FACTURAS.MONTO_PENDIENTE_MX > 0
                    
                    group by
                    
                      FACTURAS.DOC_COMPANIA
                      ,FACTURAS.DOC_TIPO
                      ,FACTURAS.DOC
                      ,FACTURAS.PROVEEDOR
                      ,FACTURAS.UN
                      ,FACTURAS.FACTURA
                      ,FACTURAS.FECHA_LM
                      ,FACTURAS.MONTO_PENDIENTE_MX
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
  )
where 1=1;
