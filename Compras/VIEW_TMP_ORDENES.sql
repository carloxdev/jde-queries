
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_TMP_ORDENES" ("OC_COMPANIA", "OC_RFC_CIA", "OC_COMPANIA_DESC", "OC_UN", "OC_UN_DESC", "OC_UN_TIPO", "OC_UN_TIPO_DESC", "OC_ID", "OC_TIPO", "OC_TIPO_DESC", "OC_SUFIX", "OC_LINEA", "OC_LINEA_TIPO", "OC_LINEA_TIPO_DESC", "OC_FECHA_CREACION", "OC_FECHA_NECESIDAD", "OC_FECHA_ENTREGA", "OC_FECHA_CANCELACION", "OC_ULTIMO_ESTADO", "OC_ULTIMO_ESTADO_DESC", "OC_SIGUIENTE_ESTADO", "OC_GENERADOR", "OC_GENERADOR_DESC", "OC_PROVEEDOR", "OC_PROVEEDOR_RFC", "OC_PROVEEDOR_DESC", "OC_ITEM", "OC_ITEM_NUMERO", "OC_ITEM_DESCRIPCION1", "OC_ITEM_DESCRIPCION2", "OC_CANTIDAD_ORDENADA", "OC_UDM", "OC_UDM_DESC", "OC_CANTIDAD_RECIBIDA", "OC_CANTIDAD_XRECIBIR", "OC_RECEPCION", "OC_COSTO_UNITARIO_EXT", "OC_COSTO_TOTAL_EXT", "OC_MONTO_RECIBIDO_EX", "OC_MONTO_XRECIBIR_EX", "OC_MONEDA", "OC_TASA", "OC_COSTO_UNITARIO_MXP", "OC_COSTO_TOTAL_MXP", "OC_MONTO_RECIBIDO_MXP", "OC_MONTO_XRECIBIR_MXP", "OC_FLAG_IMPUESTO", "OC_IMPUESTO", "OC_IMPUESTO_DESC", "OC_FACTOR_DESCUENTO", "OC_TERMINOS_PAGO", "OC_TERMINOS_PAGO_DESC", "OC_ACTUALIZADOR", "OC_ACTUALIZADOR_DESC", "OC_PROGRAMA") AS 
  SELECT                
            SOLICITUD.PDKCOO AS REQ_COMPANIA                
            ,NVL(TRIM(CENTRO.MCRP01),' ') as PROYECTO                
            ,NVL(TRIM(PROYECTO.DRDL01 ),' ') AS PROYECTO_DESC                      
            ,TRIM(SOLICITUD.PDMCU) AS  REQ_UN                            
            ,SOLICITUD.PDDCTO AS REQ_TIPO                
            ,SOLICITUD.PDDOCO AS REQ                
            ,SOLICITUD.PDTORG AS REQ_GENERADOR                
            ,trim(GENERADOR.USR_DIRECCION_DESC) AS REQ_GENERADOR_DESC                   
            ,(SOLICITUD.PDLNID/1000) AS REQ_LINEA                
            ,TRIM(SOLICITUD.PDLNTY) AS REQ_LINEA_TIPO                
            ,CASE WHEN SOLICITUD.PDTRDJ <> 0 THEN TO_DATE(1900000 + SOLICITUD.PDTRDJ,'yyyyddd') END AS REQ_FECHA_CREACION                  
            ,CASE WHEN SOLICITUD.PDDRQJ <> 0 THEN TO_DATE(1900000 + SOLICITUD.PDDRQJ,'yyyyddd') END AS REQ_FECHA_NECESIDAD                
            ,SOLICITUD.PDLTTR AS REQ_LAST_ESTADO                
            ,SOLICITUD.PDNXTR AS REQ_NEXT_ESTADO                
            ,NVL(TRIM(SOLICITUD.PDLITM),' ') AS REQ_ITEM_NUMERO                
            ,NVL(TRIM(SOLICITUD.PDDSC1),' ') AS REQ_ITEM_DESC1                
            ,NVL(TRIM(SOLICITUD.PDDSC2),' ') AS REQ_ITEM_DESC2                
            ,SOLICITUD.PDANBY AS REQ_COMPRADOR                
            ,TRIM(COMPRADOR.ABALPH) AS REQ_COMPRADOR_DESC                
            ,(SOLICITUD.PDUORG/10000) AS REQ_CANTIDAD_SOLICITADA                
            ,SOLICITUD.PDUOM AS REQ_UDM                
                            
            ,COTIZACION.PDDCTO AS COT_TIPO                
            ,COTIZACION.PDDOCO AS COT                
            ,COTIZACION.PDTORG AS COT_GENERADOR                
            ,(COTIZACION.PDLNID/1000) AS COT_LINEA                
            ,CASE WHEN COTIZACION.PDTRDJ <> 0 THEN TO_DATE(1900000 + COTIZACION.PDTRDJ,'yyyyddd') END AS COT_FECHA_CREACION                
            ,COTIZACION.PDLTTR AS COT_LAST_ESTADO                
            ,COTIZACION.PDNXTR AS COT_NEXT_ESTADO                
                            
            ,ORDEN.PDDCTO AS OC_TIPO                
            ,ORDEN.PDDOCO AS OC                
                            
            ,CASE WHEN ORDEN.PDTRDJ <> 0 THEN TO_DATE(1900000 + ORDEN.PDTRDJ,'yyyyddd') END AS OC_FECHA_CREACION                
            ,CASE WHEN ORDEN.PDOPDJ <> 0 THEN TO_DATE(1900000 + ORDEN.PDOPDJ,'yyyyddd') END AS OC_FECHA_ENTREGA                
                            
            ,ORDEN.PDTORG AS OC_GENERADOR                
            ,(ORDEN.PDLNID/1000) AS OC_LINEA                
                            
            ,ORDEN.PDAN8  AS OC_PROVEEDOR                
            ,trim(PROVEEDOR.ABALPH) AS OC_PROVEEDOR_DESC                 
                            
            ,ORDEN.PDLTTR AS OC_LAST_ESTADO                
            ,ORDEN.PDNXTR AS OC_NEXT_XAXa                
                            
            ,(ORDEN.PDUORG/10000) AS OC_CANTIDAD_SOLIC                
            ,ORDEN.PDUOM AS OC_UDM                
            ,trim(UDM.DRDL01) AS UDM_DESC                 
                            
            ,(ORDEN.PDFRRC/10000) AS OC_PU                
            ,ORDEN.PDCRCD AS OC_MONEDA                
            ,(ORDEN.PDFEA/100) AS OC_TOTAL                
                            
            ,ORDEN.PDCRR AS OC_TASA                
            ,(ORDEN.PDPRRC/10000) AS OC_PU_MX                
            ,(ORDEN.PDAEXP/100) AS OC_TOTAL_MX                
                            
            ,ORDEN.PDTX AS OC_FLAG_IMPUESTO                 
                                         
            ,TRIM(ORDEN.PDTXA1) AS OC_IMPUESTO                 
            ,trim(IMPUESTO.TATAXA) AS OC_IMPUESTO_DESC                 
                            
            ,(ORDEN.PDUREC/10000) AS OC_CANTIDAD_RECIB                
            ,(ORDEN.PDUOPN/10000) AS OC_CANTIDAD_XRECIB                
                                     
            ,CASE                 
              WHEN (ORDEN.PDUOPN = 0 AND ORDEN.PDUREC > 0) THEN 'Recepcion COMPLETA'                  
              WHEN (ORDEN.PDUREC = 0 AND ORDEN.PDUOPN > 0) THEN 'SIN Recepcion'                  
              WHEN (ORDEN.PDUREC > 0 AND ORDEN.PDUOPN > 0) THEN 'Recepcion PARCIAL'                  
              WHEN (ORDEN.PDUREC = 0 AND ORDEN.PDUOPN = 0) THEN 'Orden CANCELADA'                  
            END AS OC_RECEPCION                 
                                        
          FROM PRODDTA.F4311 SOLICITUD                
                          
          /*  UNIDADES DE NEGOCIO                 
          --------------------------------------------------------------------------------*/                 
          LEFT OUTER JOIN PRODDTA.F0006 CENTRO                
                       ON CENTRO.MCMCU = SOLICITUD.PDMCU                
                                       
          /*  PROYECTOS                 
          --------------------------------------------------------------------------------*/                                      
          LEFT OUTER JOIN PRODCTL.F0005 PROYECTO                
                       ON PROYECTO.DRSY = '00'                    
                      AND PROYECTO.DRRT = '01'                    
                      AND TRIM(PROYECTO.DRKY) = TRIM(CENTRO.MCRP01)                   
                                    
          /*   GENERADORES                   
          --------------------------------------------------------------------------------*/                 
          LEFT OUTER JOIN (                 
                            SELECT                 
                            USERS.ULUSER AS USR_ID                    
                            ,USERS.ULAN8 AS USR_DIRECCION                 
                            ,ADDRESS.ABAT1 AS USR_TIPO                 
                            ,ADDRESS.ABALPH AS USR_DIRECCION_DESC                 
                                       
                            FROM SY910.F0092 USERS                 
                            LEFT OUTER JOIN PRODDTA.F0101 ADDRESS                   
                                         ON ADDRESS.ABAN8 = USERS.ULAN8                  
                          ) GENERADOR                 
                       ON GENERADOR.USR_ID = SOLICITUD.PDTORG                
                          
                          
          /*   COMPRADORES                
          --------------------------------------------------------------------------------*/                   
          LEFT OUTER JOIN PRODDTA.F0101 COMPRADOR                
                       ON COMPRADOR.ABAN8 = SOLICITUD.PDANBY                
                          
                          
          /*   COTIZACIONES                
          --------------------------------------------------------------------------------*/                   
          LEFT OUTER JOIN PRODDTA.F4311 COTIZACION                
                       ON COTIZACION.PDOKCO = SOLICITUD.PDKCOO                 
                      AND COTIZACION.PDOCTO = SOLICITUD.PDDCTO                       
                      AND TO_NUMBER(REPLACE(COTIZACION.PDOORN,'        ',0)) = TO_NUMBER(SOLICITUD.PDDOCO)                 
                      AND COTIZACION.PDOGNO = SOLICITUD.PDLNID                       
                      AND COTIZACION.PDDCTO IN ('QS','OQ','QX')                 
                      AND COTIZACION.PDLTTR NOT IN ('980')                 
                                      
                
           /*  ORDENES DE COMPRA                 
          --------------------------------------------------------------------------------*/                                                  
          LEFT OUTER JOIN PRODDTA.F4311 ORDEN                 
                       ON ORDEN.PDOKCO = COTIZACION.PDKCOO                 
                      AND ORDEN.PDOCTO = COTIZACION.PDDCTO                 
                      AND TO_NUMBER(REPLACE(ORDEN.PDOORN,' ',0)) =  COTIZACION.PDDOCO                 
                      AND ORDEN.PDOGNO = COTIZACION.PDLNID                 
                      AND ORDEN.PDDCTO IN ('OS','OP','OX')                 
                      AND ORDEN.PDLTTR not in ('980')                                
                                                         
                                      
          /*   PROVEEDORES                   
          --------------------------------------------------------------------------------*/                 
          LEFT OUTER JOIN PRODDTA.F0101 PROVEEDOR                  
                       ON PROVEEDOR.ABAN8 = ORDEN.PDAN8                        
                                       
                                      
          /*   UNIDADES DE MEDIDAS                 
          --------------------------------------------------------------------------------*/                                           
          LEFT OUTER JOIN PRODCTL.F0005D UDM                
                       ON UDM.DRSY = '00'                
                      AND UDM.DRRT = 'UM'                
                      AND TRIM(UDM.DRKY) = TRIM(ORDEN.PDUOM)                     
                                      
                                      
           /*  IMPUESTOS                 
          --------------------------------------------------------------------------------*/                           
          LEFT OUTER JOIN PRODDTA.F4008 IMPUESTO                
                       ON IMPUESTO.TATXA1 = ORDEN.PDTXA1                 
                
                                         
                                                
                                      
          WHERE 1=1                
          AND solicitud.PDDCTO IN ('SR','OR','XR')                 
          AND solicitud.PDLTTR not in ('980');
