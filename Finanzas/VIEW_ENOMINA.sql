
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_ENOMINA" ("DOC_TIPO", "DOC", "PROVEEDOR", "PERIODO", "ANIO", "DOC_COMPANIA", "CUENTA", "CUENTA_NUMERO", "CUENTA_DESC", "CUENTA_CLASE", "CUENTA_CLASE_DESC", "CUENTA_TIPO", "CUENTA_TIPO_DESC", "CUENTA_FLUJO", "CUENTA_FLUJO_DESC", "CUENTA_PORF_CLASE", "CUENTA_CLASE_PORF_DESC", "FACTURA", "FECHA_LM", "UN", "MONTO") AS 
  SELECT 
  ASIENTO.GLDCT AS DOC_TIPO
  ,ASIENTO.GLDOC AS DOC
  ,ASIENTO.GLAN8 AS PROVEEDOR
  ,ASIENTO.GLPN AS PERIODO
  ,ASIENTO.GLFY AS ANIO
  ,ASIENTO.GLKCO as DOC_COMPANIA
  ,ASIENTO.GLAID AS CUENTA
  ,TRIM(ASIENTO.GLANI) AS CUENTA_NUMERO          
  ,TRIM(CUENTA.GMDL01) as CUENTA_DESC
  ,NVL(TRIM(CUENTA.GMR010), '-') as CUENTA_CLASE  
  ,NVL(TRIM(CLASE.DRDL01),'SIN CLASIFICACION') as CUENTA_CLASE_DESC   
  
  ,NVL(TRIM(CUENTA.GMR011), '-') as CUENTA_TIPO
  ,NVL(TRIM(TIPO.DRDL01),'SIN TIPO') as CUENTA_TIPO_DESC
  ,NVL(TRIM(CUENTA.GMR009), '-') as CUENTA_FLUJO
  ,NVL(TRIM(FLUJO.DRDL01),'SIN FLUJO') as CUENTA_FLUJO_DESC
  ,NVL (TRIM (CUENTA.GMR008), '-') as CUENTA_PORF_CLASE
  ,NVL (TRIM (CLASE_PORF.DRDL01), 'SIN CLASIFICACION') as CUENTA_CLASE_PORF_DESC                            

  
  ,NVL(TRIM(ASIENTO.GLVINV),'-') AS FACTURA 
  ,CASE WHEN ASIENTO.GLDGJ <> 0 THEN TO_DATE(1900000 + ASIENTO.GLDGJ,'YYYYDDD') END AS FECHA_LM
  ,TRIM(ASIENTO.GLMCU) AS UN   
  ,SUM(ASIENTO.GLAA/100) as MONTO
        
FROM PRODDTA.F0911 ASIENTO

LEFT OUTER JOIN proddta.f0901 CUENTA
             ON CUENTA.GMAID = ASIENTO.GLAID
             
LEFT OUTER JOIN PRODCTL.F0005 CLASE
             ON CLASE.DRSY = '09'    
            AND CLASE.DRRT = '10'    
            and TRIM(CLASE.DRKY) = TRIM(CUENTA.GMR010)

left outer join PRODCTL.F0005 TIPO
             on TIPO.DRSY = '09'    
            and TIPO.DRRT = '11'    
            and TRIM(TIPO.DRKY) = TRIM(CUENTA.GMR011) 

LEFT OUTER JOIN PRODCTL.F0005 FLUJO
             ON FLUJO.DRSY = '09'    
            and FLUJO.DRRT = '09'    
            and TRIM(FLUJO.DRKY) = TRIM(CUENTA.GMR009)    
            
left outer join PRODCTL.F0005 CLASE_PORF
            on CLASE_PORF.DRSY = '09'
           and CLASE_PORF.DRRT = '08'
           AND TRIM (CLASE_PORF.DRKY) = TRIM (CUENTA.GMR008)  
                     
WHERE 1=1            
AND GLOBJ IN ('5513', '5553')
AND GLLT = 'AA'
AND GLPOST != 'M'
AND GLDCT != 'P2'     

group by
ASIENTO.GLDCT
  ,ASIENTO.GLDOC
  ,ASIENTO.GLAN8
  ,ASIENTO.GLPN
  ,ASIENTO.GLFY
  ,ASIENTO.GLKCO
  ,ASIENTO.GLAID
  ,TRIM(ASIENTO.GLANI)
  ,TRIM(CUENTA.GMDL01)
  ,NVL(TRIM(CUENTA.GMR010), '-')
  ,NVL(TRIM(CLASE.DRDL01),'SIN CLASIFICACION')
  ,NVL(TRIM(CUENTA.GMR011), '-')
  ,NVL(TRIM(TIPO.DRDL01),'SIN TIPO')
  ,NVL(TRIM(CUENTA.GMR009), '-')
  ,NVL(TRIM(FLUJO.DRDL01),'SIN FLUJO')
    ,NVL(TRIM(CUENTA.GMR008),'-')
    ,NVL(TRIM(CLASE_PORF.DRDL01),'SIN CLASIFICACION')      
  ,NVL(TRIM(ASIENTO.GLVINV),'-') 
  ,case when ASIENTO.GLDGJ <> 0 then TO_DATE(1900000 + ASIENTO.GLDGJ,'YYYYDDD') end
  ,TRIM(ASIENTO.GLMCU);
