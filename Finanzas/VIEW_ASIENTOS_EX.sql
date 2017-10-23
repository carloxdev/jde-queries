
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_IASIENTOS_EX" ("DOC_COMPANIA", "DOC_TIPO", "DOC", "CUENTA_NUMERO", "CUENTA", "CUENTA_DESC", "CUENTA_UN", "CUENTA_CLASE", "CUENTA_CLASE_DESC", "CUENTA_TIPO", "CUENTA_TIPO_DESC", "CUENTA_FLUJO", "CUENTA_FLUJO_DESC", "MONTO", "PORCENTAJE") AS 
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

          ,MONTO
          ,ROUND(  ( (MONTO * 100 )/ (SUM(MONTO) OVER (PARTITION BY DOC_COMPANIA,DOC_TIPO,DOC )) ) / 100 , 2 ) AS PORCENTAJE
        
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
                            
                
                WHERE ASIENTO.GLLT = 'CA'        --< Solo asientOos en pesos
                AND ASIENTO.GLICUT IN ('IB')     --< Solo Batchs de tipo 'IB'
                AND ASIENTO.GLDCT NOT IN ( 'AE') --< Quitamos los asientOos automaticos y los asientOos de factura

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
             )
        where 1=1
        AND MONTO <> 0;
