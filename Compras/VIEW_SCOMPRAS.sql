
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_SCOMPRAS" ("REQ_COMPANIA", "REQ_COMPANIA_DESC", "REQ_UN", "REQ_UN_DESC", "REQ_UN_PROYECTO", "REQ_UN_PROYECTO_DESC", "REQ_TIPO", "REQ_TIPO_DESC", "REQ", "REQ_LINEA", "REQ_LINEA_TIPO", "REQ_GENERADOR", "REQ_GENERADOR_DESC", "REQ_FECHA_CREACION", "REQ_FECHA_NECESIDAD", "REQ_ESTADO_LAST", "REQ_ESTADO_LAST_DESC", "REQ_ESTADO_NEXT", "REQ_ITEM_NUMERO", "REQ_ITEM_DESC", "REQ_COMPRADOR", "REQ_COMPRADOR_DESC", "REQ_CANTIDAD_SOLICITADA", "REQ_UDM", "REQ_UDM_DESC", "REQ_GLCLASS", "REQ_GLCLASS_DESC", "COT_COMPANIA", "COT_TIPO", "COT", "COT_LINEA", "COT_GENERADOR", "COT_FECHA_CREACION", "COT_ESTADO_LAST", "COT_ESTADO_LAST_DESC", "COT_ESTADO_NEXT", "ORD_COMPANIA", "ORD_TIPO", "ORD_TIPO_DESC", "ORD", "ORD_FECHA_CREACION", "ORD_FECHA_ENTREGA", "ORD_GENERADOR", "ORD_GENERADOR_DESC", "ORD_LINEA", "ORD_PROVEEDOR", "ORD_PROVEEDOR_DESC", "ORD_ESTADO_LAST", "ORD_ESTADO_LAST_DESC", "ORD_ESTADO_NEXT", "ORD_CANTIDAD_SOLIC", "ORD_UDM", "ORD_UDM_DESC", "ORD_CANTIDAD_RECIB", "ORD_CANTIDAD_XRECIB", "ORD_RECEPCION", "ORD_PU_EX", "ORD_TOTAL_EX", "ORD_MONTO_RECIB_EX", "ORD_MONTO_XRECIB_EX", "ORD_MONEDA", "ORD_MONEDA_DESC", "ORD_TASA", "ORD_PU_MX", "ORD_TOTAL_MX", "ORD_MONTO_RECIB_MX", "ORD_MONTO_XRECIB_MX", "ORD_IMPUESTO", "ORD_IMPUESTO_DESC", "ORD_IMPUESTO_FLAG", "ORD_DESCUENTO", "ORD_TERMINO_PAGO", "ORD_TERMINO_PAGO_DESC", "ORD_UPDATED_BY", "ORD_UPDATED_BY_DESC") AS 
  SELECT
            SOLICITUD.PDKCOO as REQ_COMPANIA
            ,nvl(COMPANIA.CCNAME,'--') as REQ_COMPANIA_DESC
        
            ,TRIM(SOLICITUD.PDMCU) as  REQ_UN
            ,nvl(TRIM(SUCURSAL.MCDL01 || SUCURSAL.MCDL02), '--') as REQ_UN_DESC
            ,NVL(TRIM(SUCURSAL.MCRP01),'--') as REQ_UN_PROYECTO                
            ,NVL(TRIM(PROYECTO.DRDL01),'--') AS REQ_UN_PROYECTO_DESC    
            
            ,SOLICITUD.PDDCTO as REQ_TIPO
            ,nvl(TRIM(TIPO_REQ.DRDL01), '--') as REQ_TIPO_DESC
            ,SOLICITUD.PDDOCO as REQ
            ,SOLICITUD.PDLNID/1000 as REQ_LINEA
            ,TRIM(SOLICITUD.PDLNTY) as REQ_LINEA_TIPO

            ,SOLICITUD.PDTORG as REQ_GENERADOR
            ,NVL(TRIM(GENERADOR_REQ.DIR_DESC),'--') as REQ_GENERADOR_DESC

            ,case when SOLICITUD.PDTRDJ <> 0 then TO_DATE(1900000 + SOLICITUD.PDTRDJ,'yyyyddd') else TO_DATE('01/01/1000','DD/MM/YYYY') end as REQ_FECHA_CREACION                
            ,case when SOLICITUD.PDDRQJ <> 0 then TO_DATE(1900000 + SOLICITUD.PDDRQJ,'yyyyddd') else to_date('01/01/1000','DD/MM/YYYY') end as REQ_FECHA_NECESIDAD                

            ,SOLICITUD.PDLTTR as REQ_ESTADO_LAST
            ,nvl(TRIM(ESTADO_REQ.DRDL01),'--') as REQ_ESTADO_LAST_DESC
            ,SOLICITUD.PDNXTR AS REQ_ESTADO_NEXT

            ,NVL(TRIM(SOLICITUD.PDLITM),'--') as REQ_ITEM_NUMERO                
            ,NVL(TRIM(SOLICITUD.PDDSC1 || ' ' || SOLICITUD.PDDSC2),'--') AS REQ_ITEM_DESC            
            ,SOLICITUD.PDANBY as REQ_COMPRADOR                
            ,nvl(TRIM(COMPRADOR.ABALPH),'--') AS REQ_COMPRADOR_DESC                
            ,SOLICITUD.PDUORG/10000 AS REQ_CANTIDAD_SOLICITADA
            ,SOLICITUD.PDUOM as REQ_UDM
            ,nvl(trim(UDM_REQ.DRDL01),'--') AS REQ_UDM_DESC

            ,NVL(SOLICITUD.PDGLC,'--') as REQ_GLCLASS
            ,NVL(TRIM(GL_CLASS.DRDL01),'--') AS REQ_GLCLASS_DESC

            ,NVL(COTIZACION.PDKCOO,'--') AS COT_COMPANIA
            ,NVL(COTIZACION.PDDCTO,'--') as COT_TIPO
            ,NVL(COTIZACION.PDDOCO,0) as COT
            ,NVL(COTIZACION.PDLNID/1000, 0) as COT_LINEA
            ,NVL(COTIZACION.PDTORG,'-') as COT_GENERADOR
            ,case when COTIZACION.PDTRDJ <> 0 then TO_DATE(1900000 + COTIZACION.PDTRDJ,'yyyyddd') else to_date('01/01/1000','DD/MM/YYYY') end as COT_FECHA_CREACION
            ,NVL(COTIZACION.PDLTTR,'--') as COT_ESTADO_LAST
            ,NVL(TRIM(ESTADO_COT.DRDL01),'-') as COT_ESTADO_LAST_DESC
            ,NVL(COTIZACION.PDNXTR,'--') AS COT_ESTADO_NEXT

            ,NVL(ORDEN.PDKCOO,'--') AS ORD_COMPANIA
            ,NVL(ORDEN.PDDCTO, '--') as ORD_TIPO
            ,NVL(TRIM(TIPO_ORDEN.DRDL01),'--') as ORD_TIPO_DESC
            ,nvl(ORDEN.PDDOCO, 0) as ORD
            ,case when ORDEN.PDTRDJ <> 0 then TO_DATE(1900000 + ORDEN.PDTRDJ,'yyyyddd') else TO_DATE('01/01/1000','DD/MM/YYYY') end as ORD_FECHA_CREACION                
            ,case when ORDEN.PDOPDJ <> 0 then TO_DATE(1900000 + ORDEN.PDOPDJ,'yyyyddd') else TO_DATE('01/01/1000','DD/MM/YYYY') end as ORD_FECHA_ENTREGA                
            ,NVL(ORDEN.PDTORG,'--') as ORD_GENERADOR
            ,NVL(TRIM(GENERADOR_ORDEN.DIR_DESC),'--') as ORD_GENERADOR_DESC
            ,NVL(ORDEN.PDLNID/1000,0) as ORD_LINEA                
            ,NVL(ORDEN.PDAN8,0)  as ORD_PROVEEDOR                
            ,NVL(TRIM(PROVEEDOR.ABALPH),'--') as ORD_PROVEEDOR_DESC                 
            ,NVL(ORDEN.PDLTTR,'--') as ORD_ESTADO_LAST
            ,NVL(TRIM(ESTADO_OC.DRDL01),'--') as ORD_ESTADO_LAST_DESC    
            ,nvl(ORDEN.PDNXTR,'--') AS ORD_ESTADO_NEXT

            ,NVL(ORDEN.PDUORG/10000,0) as ORD_CANTIDAD_SOLIC      
            ,NVL(ORDEN.PDUOM,'--') as ORD_UDM                
            ,nvl(trim(UDM_ORDEN.DRDL01),'--') AS ORD_UDM_DESC

            ,NVL(ORDEN.PDUREC/10000,0) as ORD_CANTIDAD_RECIB
            ,nvl(ORDEN.PDUOPN/10000,0) AS ORD_CANTIDAD_XRECIB

             ,case                 
              WHEN (ORDEN.PDUOPN = 0 AND ORDEN.PDUREC > 0) THEN 'COMPLETA'
              WHEN (ORDEN.PDUREC = 0 AND ORDEN.PDUOPN > 0) THEN 'PENDIENTE'                  
              WHEN (ORDEN.PDUREC > 0 AND ORDEN.PDUOPN > 0) THEN 'PARCIAL'                  
              when (ORDEN.PDUREC = 0 and ORDEN.PDUOPN = 0) then 'CANCELADA'
              WHEN (ORDEN.PDUREC is NULL and ORDEN.PDUOPN is NULL) THEN 'PENDIENTE'
            END AS ORD_RECEPCION                         

            ,NVL(ORDEN.PDFRRC/10000,0) as ORD_PU_EX
            ,nvl(ORDEN.PDFEA/100,0) AS ORD_TOTAL_EX

            ,NVL(ORDEN.PDFREC/100,0) as ORD_MONTO_RECIB_EX                   
            ,nvl(ORDEN.PDFAP/100,0) AS ORD_MONTO_XRECIB_EX       

            ,NVL(ORDEN.PDCRCD,'--') as ORD_MONEDA
            ,NVL(MONEDA.CVDL01,'--') as ORD_MONEDA_DESC   

            ,nvl(ORDEN.PDCRR,0) AS ORD_TASA

            ,NVL(ORDEN.PDPRRC/10000,0) as ORD_PU_MX
            ,nvl(ORDEN.PDAEXP/100,0) as ORD_TOTAL_MX

            ,NVL(ORDEN.PDAREC/100,0) as ORD_MONTO_RECIB_MX                   
            ,nvl(ORDEN.PDAOPN/100,0) AS ORD_MONTO_XRECIB_MX      

            ,NVL(TRIM(ORDEN.PDTXA1),'--') as ORD_IMPUESTO
            ,NVL(TRIM(IMPUESTO.TATAXA),'--') as ORD_IMPUESTO_DESC
            ,nvl(ORDEN.PDTX,'--') AS ORD_IMPUESTO_FLAG

            ,nvl(ORDEN.PDDSPR,0) AS ord_DESCUENTO                    

            ,NVL(ORDEN.PDPTC,'--') as ORD_TERMINO_PAGO
            ,nvl(TRIM(CONDICION.PNPTD),'--') AS ord_TERMINO_PAGO_DESC

            ,NVL(TRIM(ORDEN.PDUSER),'--') as ORD_UPDATED_BY
            ,NVL(TRIM(UPDATER.DIR_DESC),'--') as ORD_UPDATED_BY_DESC

          FROM PRODDTA.F4311 SOLICITUD

          /*   COTIZACIONES                
          --------------------------------------------------------------------------------*/                   
          left outer join PRODDTA.F4311 COTIZACION on 1=1
                      AND COTIZACION.PDOKCO = SOLICITUD.PDKCOO
                      and TO_NUMBER(NVL(TRIM(COTIZACION.PDOORN),'0')) = SOLICITUD.PDDOCO
                      AND COTIZACION.PDOCTO = SOLICITUD.PDDCTO
                      and COTIZACION.PDOGNO = SOLICITUD.PDLNID
                      and COTIZACION.PDDCTO in ('QS','OQ','QX')
                      --AND COTIZACION.PDLTTR NOT IN ('980')

           /*  ORDENES DE COMPRA                 
          --------------------------------------------------------------------------------*/                                                  
          LEFT OUTER JOIN PRODDTA.F4311 ORDEN ON 1=1
                      and TO_NUMBER(NVL(trim(ORDEN.PDOORN),'0')) = COTIZACION.PDDOCO         
                      AND ORDEN.PDOCTO = COTIZACION.PDDCTO
                      AND ORDEN.PDOKCO = COTIZACION.PDKCOO                 
                      and ORDEN.PDOGNO = COTIZACION.PDLNID
                      and ORDEN.PDDCTO in ('OS','OP','OX')                 
                      --and ORDEN.PDLTTR not in ('980')

          /*  COMPANIA                    
          --------------------------------------------------------------------------------*/
          left outer join PRODDTA.F0010 COMPANIA
                       ON COMPANIA.CCCO = SOLICITUD.PDKCOO

          /*  UNIDADES DE NEGOCIO                 
          --------------------------------------------------------------------------------*/                 
          LEFT OUTER JOIN PRODDTA.F0006 SUCURSAL                
                       ON SUCURSAL.MCMCU = SOLICITUD.PDMCU                

          /*  PROYECTOS                 
          --------------------------------------------------------------------------------*/                                      
          LEFT OUTER JOIN PRODCTL.F0005 PROYECTO                
                       ON PROYECTO.DRSY = '00'                    
                      AND PROYECTO.DRRT = '01'
                      AND TRIM(PROYECTO.DRKY) = TRIM(SUCURSAL.MCRP01)                   

          /*   GENERADORES SOLICITUD
          --------------------------------------------------------------------------------*/   
          left outer join NUVPD.VIEW_USUARIOS GENERADOR_REQ on 1=1
                      AND trim(GENERADOR_REQ.CLAVE) = trim(SOLICITUD.PDTORG) 


          /*   GENERADORES ORDENES               
          --------------------------------------------------------------------------------*/ 
          left outer join NUVPD.VIEW_USUARIOS GENERADOR_ORDEN on 1=1
                      AND trim(GENERADOR_ORDEN.CLAVE) = trim(ORDEN.PDTORG)           


          /*   ACTUALIZADORES ORDENES                 
          --------------------------------------------------------------------------------*/    
          left outer join NUVPD.VIEW_USUARIOS UPDATER on 1=1
                      AND trim(UPDATER.CLAVE) = trim(ORDEN.PDUSER)            

          /*   COMPRADORES                
          --------------------------------------------------------------------------------*/
          LEFT OUTER JOIN PRODDTA.F0101 COMPRADOR                
                       ON COMPRADOR.ABAN8 = SOLICITUD.PDANBY                

          /*   PROVEEDORES                   
          --------------------------------------------------------------------------------*/
          LEFT OUTER JOIN PRODDTA.F0101 PROVEEDOR                  
                       ON PROVEEDOR.ABAN8 = ORDEN.PDAN8                        

          /*   UNIDADES DE MEDIDAS REQUISICION               
          --------------------------------------------------------------------------------*/
          LEFT OUTER JOIN PRODCTL.F0005D UDM_REQ
                       ON UDM_REQ.DRSY = '00'                
                      and UDM_REQ.DRRT = 'UM'                
                      AND TRIM(UDM_REQ.DRKY) = SOLICITUD.PDUOM

          /*   UNIDADES DE MEDIDAS ORDEN
          --------------------------------------------------------------------------------*/
          LEFT OUTER JOIN PRODCTL.F0005D UDM_ORDEN
                       ON UDM_ORDEN.DRSY = '00'                
                      and UDM_ORDEN.DRRT = 'UM'                
                      AND TRIM(UDM_ORDEN.DRKY) = ORDEN.PDUOM

           /*  IMPUESTOS                 
          --------------------------------------------------------------------------------*/
          LEFT OUTER JOIN PRODDTA.F4008 IMPUESTO                
                       on IMPUESTO.TATXA1 = ORDEN.PDTXA1

          /*   TIPOS DE REQUISICONES                      
          --------------------------------------------------------------------------------*/
          LEFT OUTER JOIN PRODCTL.F0005D TIPO_REQ                   
                       ON TIPO_REQ.DRSY = '00'                   
                      and TIPO_REQ.DRRT = 'DT'                   
                      AND TRIM(TIPO_REQ.DRKY) = SOLICITUD.PDDCTO

          /*   TIPOS DE ORDENES                      
          --------------------------------------------------------------------------------*/
          left outer join PRODCTL.F0005D TIPO_ORDEN                   
                       ON TIPO_ORDEN.DRSY = '00'                   
                      and TIPO_ORDEN.DRRT = 'DT'                   
                      AND TRIM(TIPO_ORDEN.DRKY) = ORDEN.PDDCTO

          /*   ESTADOS DE LA REQ                      
          --------------------------------------------------------------------------------*/
          LEFT OUTER JOIN PRODCTL.F0005D ESTADO_REQ                  
                       ON ESTADO_REQ.DRSY = '40'                   
                      and ESTADO_REQ.DRRT = 'AT'                   
                      AND TRIM(ESTADO_REQ.DRKY) = SOLICITUD.PDLTTR

          /*   ESTADOS DE LA COTIZACION                      
          --------------------------------------------------------------------------------*/
          LEFT OUTER JOIN PRODCTL.F0005D ESTADO_COT
                       on ESTADO_COT.DRSY = '40'                   
                      and ESTADO_COT.DRRT = 'AT'                   
                      AND TRIM(ESTADO_COT.DRKY) = COTIZACION.PDLTTR

          /*   ESTADOS DE LA ORDEN                      
          --------------------------------------------------------------------------------*/
          LEFT OUTER JOIN PRODCTL.F0005D ESTADO_OC                
                       on ESTADO_OC.DRSY = '40'                   
                      and ESTADO_OC.DRRT = 'AT'                   
                      AND TRIM(ESTADO_OC.DRKY) = ORDEN.PDLTTR

          /*  MONEDAS
          --------------------------------------------------------------------------------*/ 
          left outer join PRODDTA.F0013 MONEDA
                       ON MONEDA.CVCRCD = ORDEN.PDCRCD              

          /*  GL CLASS
          --------------------------------------------------------------------------------*/ 
          LEFT OUTER JOIN PRODCTL.F0005 GL_CLASS                
                       on GL_CLASS.DRSY = '41'                   
                      and GL_CLASS.DRRT = '9'                   
                      AND TRIM(GL_CLASS.DRKY) = TRIM(SOLICITUD.PDGLC)

          /*   CONDICIONES DE PAGO                    
          --------------------------------------------------------------------------------*/                     
          left outer join PRODDTA.F0014 CONDICION                   
                       ON CONDICION.PNPTC = ORDEN.PDPTC                  

          where 1=1                
          and SOLICITUD.PDDCTO in ('SR','OR','XR') 
          --and SOLICITUD.PDLTTR not in ('980') 

          order by
            SOLICITUD.PDKCOO --/ REQ_COMPANIA
            ,SOLICITUD.PDDCTO --/ REQ_TIPO
            ,SOLICITUD.PDDOCO --/ REQ
            ,SOLICITUD.PDLNID/1000 --/ REQ_LINEA
;
