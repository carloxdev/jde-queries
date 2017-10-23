
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_EASIENTOS" ("DOC_COMPANIA", "DOC_TIPO", "DOC", "CUENTA_NUMERO", "CUENTA", "CUENTA_DESC", "CUENTA_UN", "CUENTA_CLASE", "CUENTA_CLASE_DESC", "CUENTA_TIPO", "CUENTA_TIPO_DESC", "CUENTA_FLUJO", "CUENTA_FLUJO_DESC", "CUENTA_CLASE_PORF", "CUENTA_CLASE_PORF_DESC", "MONTO", "PORCENTAJE") AS 
  SELECT
   DOC_COMPANIA
  ,DOC_TIPO
  ,DOC
  ,CUENTA_NUMERO
  ,CUENTA
  ,CUENTA_DESC
  ,CUENTA_UN
  ,CUENTA_CLASE  
  ,CUENTA_CLASE_DESC  
  ,CUENTA_TIPO  
  ,CUENTA_TIPO_DESC
  ,CUENTA_FLUJO
  ,CUENTA_FLUJO_DESC
    ,CUENTA_CLASE_PORF
    ,CUENTA_CLASE_PORF_DESC  
  ,MONTO
  ,ROUND((MONTO) * 100 / SUM(MONTO) OVER (PARTITION BY DOC_COMPANIA,DOC_TIPO,DOC ),2) AS PORCENTAJE
from (

        select 
           ASIENTO.GLKCO as DOC_COMPANIA
          ,ASIENTO.GLDCT AS DOC_TIPO
          ,ASIENTO.GLDOC as DOC
          ,TRIM(ASIENTO.GLANI) as CUENTA_NUMERO
          ,ASIENTO.GLAID as CUENTA
          ,TRIM(CUENTA.GMDL01) as CUENTA_DESC
          ,TRIM(ASIENTO.GLMCU) AS CUENTA_UN
          
          ,NVL(TRIM(CUENTA.GMR010),'-') as CUENTA_CLASE
          ,NVL(TRIM(CLASE.DRDL01),'SIN CLASIFICACION') as CUENTA_CLASE_DESC 
          
          ,NVL(TRIM(CUENTA.GMR011), '-') as CUENTA_TIPO
          ,NVL(TRIM(TIPO.DRDL01),'SIN TIPO') as CUENTA_TIPO_DESC
          
          ,NVL(TRIM(CUENTA.GMR009),'-') as CUENTA_FLUJO
          ,NVL(TRIM(FLUJO.DRDL01),'SIN FLUJO') as CUENTA_FLUJO_DESC
          
            ,NVL (TRIM (CUENTA.GMR008), '-') as CUENTA_CLASE_PORF
            ,NVL (TRIM (CLASE_PORF.DRDL01), 'SIN CLASIFICACION') as CUENTA_CLASE_PORF_DESC                                      
          
          ,SUM(GLAA/100) AS MONTO
          
        FROM PRODDTA.F0911 ASIENTO
        left outer join PRODDTA.F0901 CUENTA
                     ON CUENTA.GMAID = ASIENTO.GLAID 
                     
        left outer join PRODCTL.F0005 CLASE
                     on CLASE.DRSY = '09'    
                    and CLASE.DRRT = '10'    
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
        AND GLLT = 'AA'              --< Solo asientos en pesos
        AND GLICUT IN ('V','O')      --< Solo Batchs de tipo 'V' y 'O'  
        and GLDCT not in ('PV','AE') --< Quitamos los asientos automaticos y los asientos de cotejos

        group by
          ASIENTO.GLKCO
          ,ASIENTO.GLDCT
          ,ASIENTO.GLDOC
          ,TRIM(ASIENTO.GLANI)
          ,ASIENTO.GLAID
          ,TRIM(CUENTA.GMDL01)
          ,TRIM(ASIENTO.GLMCU)
          ,NVL(TRIM(CUENTA.GMR010),'-')
          ,NVL(TRIM(CLASE.DRDL01),'SIN CLASIFICACION')
          ,NVL(TRIM(CUENTA.GMR011), '-')
          ,NVL(TRIM(TIPO.DRDL01),'SIN TIPO')
          ,NVL(TRIM(CUENTA.GMR009),'-')
          ,NVL(TRIM(FLUJO.DRDL01),'SIN FLUJO')
          ,NVL(TRIM(CUENTA.GMR008),'-')
          ,NVL(TRIM(CLASE_PORF.DRDL01),'SIN CLASIFICACION')                  
     )
where 1=1 
and MONTO > 0;
