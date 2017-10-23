
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_ORDENES" ("COMPANIA", "COMPANIA_DESC", "PROYECTO", "PROYECTO_DESC", "UN", "UN_DESC", "UN_TIPO", "UN_TIPO_DESC", "NUMERO", "TIPO", "TIPO_DESC", "SUFIX", "LINEA", "LINEA_TIPO", "LINEA_TIPO_DESC", "FECHA_CREACION", "FECHA_NECESIDAD", "FECHA_ENTREGA", "FECHA_CANCELACION", "ESTADO_ULTIMO", "ESTADO_ULTIMO_DESC", "ESTADO_SIGUIENTE", "COMPRADOR", "COMPRADOR_DESC", "ORIGINADOR", "ORIGINADOR_DESC", "PROVEEDOR", "PROVEEDOR_DESC", "ITEM", "ITEM_NUMERO", "ITEM_DESC1", "ITEM_DESC2", "ITEM_GLCLASS", "CANTIDAD_SOLIC", "UDM", "UDM_DESC", "CANTIDAD_RECIB", "CANTIDAD_XRECIB", "RECEPCION", "PU_EX", "TOTAL_EX", "MONTO_RECIB_EX", "MONTO_XRECIB_EX", "MONEDA", "TASA", "PU_MX", "TOTAL_MX", "MONTO_RECIB_MX", "MONTO_XRECIB_MX", "IMPUESTO", "IMPUESTO_FLAG", "IMPUESTO_DESC", "DESCUENTO", "TERMINOS_PAGO", "TERMINOS_PAGO_DESC", "UPDATER", "UPDATER_DESC", "PROGRAMA", "ORI_ORDEN_COMPANIA", "ORI_ORDEN_TIPO", "ORI_ORDEN", "ORI_ORDEN_LINEA") AS 
  select 
            ORDEN.PDKCOO as COMPANIA            -- PK
            ,nvl(trim(COMPANIA.CCNAME),'--') AS COMPANIA_DESC 
            ,NVL(TRIM(CENTRO.MCRP01),'--') AS PROYECTO
            ,NVL(TRIM(PROYECTO.DRDL01),'--') AS PROYECTO_DESC            
            ,TRIM(ORDEN.PDMCU) as UN 
            ,NVL(TRIM(CENTRO.MCDL01 || CENTRO.MCDL02),'--') as UN_DESC 
            ,NVL(CENTRO.MCSTYL,'--') as UN_TIPO
            ,nvl(TRIM(TIPO_CENTRO.DRDL01),'--') AS UN_TIPO_DESC 
            ,ORDEN.PDDOCO AS NUMERO             -- PK
            ,ORDEN.PDDCTO as TIPO               -- PK
            ,nvl(TRIM(TIPO_ORDEN.DRDL01),'--') AS TIPO_DESC 
            ,ORDEN.PDSFXO AS SUFIX            -- PK
         
            ,(ORDEN.PDLNID/1000) as LINEA       -- PK
            ,nvl(TRIM(ORDEN.PDLNTY),'--') AS LINEA_TIPO      
            ,trim(TIPO_LINEA.LFLNDS) AS LINEA_TIPO_DESC 
             
            ,CASE WHEN ORDEN.PDTRDJ <> 0 THEN TO_DATE(1900000 + ORDEN.PDTRDJ,'yyyyddd') END AS FECHA_CREACION
            ,CASE WHEN ORDEN.PDDRQJ <> 0 THEN TO_DATE(1900000 + ORDEN.PDDRQJ,'yyyyddd') END AS FECHA_NECESIDAD
            ,case when ORDEN.PDOPDJ <> 0 then TO_DATE(1900000 + ORDEN.PDOPDJ,'yyyyddd') end as FECHA_ENTREGA
            ,CASE WHEN ORDEN.PDCNDJ <> 0 THEN TO_DATE(1900000 + ORDEN.PDCNDJ,'yyyyddd') else TO_DATE('01/01/1000','DD/MM/YYYY') END AS FECHA_CANCELACION
         
            ,ORDEN.PDLTTR as ESTADO_ULTIMO
            ,nvl(TRIM(ESTADO.DRDL01),'--') AS ESTADO_ULTIMO_DESC 
            ,ORDEN.PDNXTR AS ESTADO_SIGUIENTE 
             
            ,ORDEN.PDANBY as COMPRADOR
            ,nvl(TRIM(COMPRADOR.ABALPH),'--') as COMPRADOR_DESC 
             
            ,TRIM(ORDEN.PDTORG) as CREATED_BY 
            ,nvl(TRIM(ORG.DIR_DESC),'--') as CREATED_BY_DESC
         
            ,ORDEN.PDAN8  as PROVEEDOR 
            ,nvl(trim(PROVEEDOR.ABALPH),'--') AS PROVEEDOR_DESC 
         
            ,ORDEN.PDITM as  ITEM 
            ,nvl(TRIM(ORDEN.PDLITM),'--') AS ITEM_NUMERO 
            ,NVL(TRIM(ORDEN.PDDSC1),'--') as ITEM_DESC1 
            ,NVL(TRIM(ORDEN.PDDSC2),'--') as ITEM_DESC2 
            ,NVL(TRIM(ORDEN.PDGLC),'--') as ITEM_GLCLASS
         
            ,(ORDEN.PDUORG/10000) AS CANTIDAD_SOLIC
            ,ORDEN.PDUOM AS UDM         
            ,trim(UDM.DRDL01) AS UDM_DESC 
             
            ,(ORDEN.PDUREC/10000) AS CANTIDAD_RECIB
            ,(ORDEN.PDUOPN/10000) AS CANTIDAD_XRECIB
         
            ,CASE 
              WHEN (ORDEN.PDUOPN = 0 AND ORDEN.PDUREC > 0) THEN 'COMPLETA'  
              when (ORDEN.PDUREC = 0 and ORDEN.PDUOPN > 0) then 'PENDIENTE'
              when (ORDEN.PDUREC > 0 and ORDEN.PDUOPN > 0) then 'PARCIAL'  
              when (ORDEN.PDUREC = 0 and ORDEN.PDUOPN = 0) then 'CANCELADA'  
              when (ORDEN.PDUREC is null and ORDEN.PDUOPN is null) then 'PENDIENTE'
            end as RECEPCION             
         
            ,(ORDEN.PDFRRC/10000) AS PU_EX
            ,(ORDEN.PDFEA/100) AS TOTAL_EX
            ,(ORDEN.PDFREC/100) AS MONTO_RECIB_EX
            ,(ORDEN.PDFAP/100) AS MONTO_XRECIB_EX          
             
            ,ORDEN.PDCRCD AS MONEDA
            ,ORDEN.PDCRR AS TASA              
         
            ,(ORDEN.PDPRRC/10000) AS PU_MX 
            ,(ORDEN.PDAEXP/100) AS TOTAL_MX
            ,(ORDEN.PDAREC/100) AS MONTO_RECIB_MX
            ,(ORDEN.PDAOPN/100) AS MONTO_XRECIB_MX 
         
            ,nvl(TRIM(ORDEN.PDTXA1),'--') as IMPUESTO
            ,ORDEN.PDTX as IMPUESTO_FLAG 
            ,nvl(trim(IMPUESTO.TATAXA),'--') AS IMPUESTO_DESC 
         
            ,ORDEN.PDDSPR AS DESCUENTO 
             
            ,ORDEN.PDPTC as TERMINOS_PAGO 
            ,NVL(TRIM(CONDICION.PNPTD),'--') AS TERMINOS_PAGO_DESC 
         
            ,TRIM(ORDEN.PDUSER) as UPDATED_BY
            ,nvl(TRIM(UPDATER.DIR_DESC), '--') AS UPDATED_BY_DESC 
            ,trim(ORDEN.PDPID) AS PROGRAMA 
            
            ,NVL(TRIM(ORDEN.PDOKCO),'--') as ORI_ORDEN_COMPANIA
            ,NVL(TRIM(ORDEN.PDOCTO),'--') as ORI_ORDEN_TIPO
            ,TO_NUMBER(NVL(TRIM(ORDEN.PDOORN),0)) as ORI_ORDEN
            ,ORDEN.PDOGNO/1000 as ORI_ORDEN_LINEA
            
        FROM PRODDTA.F4311 ORDEN 
         
        /*   GENERADORES
        --------------------------------------------------------------------------------*/                 
        left outer join NUVPD.VIEW_USUARIOS ORG on 1=1
                    and ORG.CLAVE = ORDEN.PDTORG
         
         
        /*   PROVEEDORES   
        --------------------------------------------------------------------------------*/ 
        LEFT OUTER JOIN PRODDTA.F0101 PROVEEDOR  
                     ON PROVEEDOR.ABAN8 = ORDEN.PDAN8  
                     
        /*   ACTUALIZADORES
        --------------------------------------------------------------------------------*/                 
        left outer join NUVPD.VIEW_USUARIOS UPDATER on 1=1
                    and UPDATER.CLAVE = ORDEN.PDUSER
                     

        /*   COMPRADORES
        --------------------------------------------------------------------------------*/   
        LEFT OUTER JOIN PRODDTA.F0101 COMPRADOR
                     ON COMPRADOR.ABAN8 = ORDEN.PDANBY

         
        /*   TIPOS DE ORDENES   
        --------------------------------------------------------------------------------*/   
        LEFT OUTER JOIN PRODCTL.F0005 TIPO_ORDEN
                     ON TIPO_ORDEN.DRSY = '00'
                    AND TIPO_ORDEN.DRRT = 'DT'
                    AND TRIM(TIPO_ORDEN.DRKY) = trim(ORDEN.PDDCTO)                        
         
        /*   TIPOS DE LINEAS DE ORDEN   
        --------------------------------------------------------------------------------*/         
        LEFT OUTER JOIN PRODDTA.F40205  TIPO_LINEA 
                     ON TIPO_LINEA.LFLNTY = ORDEN.PDLNTY 
         
         
        /*   ESTADOS DE LA ORDEN   
        --------------------------------------------------------------------------------*/   
        LEFT OUTER JOIN PRODCTL.F0005D ESTADO
                     ON ESTADO.DRSY = '40'
                    AND ESTADO.DRRT = 'AT'
                    AND TRIM(ESTADO.DRKY) = trim(ORDEN.PDLTTR)                     
                       
                      
        /*   UNIDADES DE MEDIDAS 
        --------------------------------------------------------------------------------*/                           
        LEFT OUTER JOIN PRODCTL.F0005D UDM
                     ON UDM.DRSY = '00'
                    AND UDM.DRRT = 'UM'
                    AND TRIM(UDM.DRKY) = trim(ORDEN.PDUOM)
         
         
        /*   CONDICIONES DE PAGO 
        --------------------------------------------------------------------------------*/  
        LEFT OUTER JOIN PRODDTA.F0014 CONDICION
                     ON CONDICION.PNPTC = ORDEN.PDPTC 
         
         /*  IMPUESTOS 
        --------------------------------------------------------------------------------*/           
        LEFT OUTER JOIN PRODDTA.F4008 IMPUESTO
                     ON IMPUESTO.TATXA1 = ORDEN.PDTXA1 
          
        /*  COMPANIA 
        --------------------------------------------------------------------------------*/ 
        LEFT OUTER JOIN PRODDTA.F0010 COMPANIA
                     ON COMPANIA.CCCO = ORDEN.PDKCOO  
         
        /*  UNIDADES DE NEGOCIO 
        --------------------------------------------------------------------------------*/ 
        LEFT OUTER JOIN PRODDTA.F0006 CENTRO
                     ON CENTRO.MCMCU = ORDEN.PDMCU 
                   
        /*  TIPOS DE UNIDADES DE NEGOCIO 
        --------------------------------------------------------------------------------*/ 
        LEFT OUTER JOIN PRODCTL.F0005 TIPO_CENTRO
                     ON TIPO_CENTRO.DRSY = '00'
                    AND TIPO_CENTRO.DRRT = 'MC'
                    AND TRIM(TIPO_CENTRO.DRKY) = trim(CENTRO.MCSTYL)                     
                     
        /*  PROYECTOS 
        --------------------------------------------------------------------------------*/                      
        LEFT OUTER JOIN PRODCTL.F0005 PROYECTO
                     ON PROYECTO.DRSY = '00'    
                    AND PROYECTO.DRRT = '01'    
                    and TRIM(PROYECTO.DRKY) = TRIM(CENTRO.MCRP01);
