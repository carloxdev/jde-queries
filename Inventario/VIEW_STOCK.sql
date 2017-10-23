
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_STOCK" ("COMPANIA", "UN", "ITEM_CLAVE", "ITEM_NUMERO", "ITEM_NOPARTE", "ITEM_DESCRIPCION", "ITEM_MODELO", "ITEM_TEXTO_BUSQUEDA", "ALM_TIPO", "LINEA_TIPO", "GL_CODIGO", "UDM_PRIM", "UDM_SECU", "UDM_COMPRA", "PROVEEDOR", "PLANEADOR", "COMPRADOR", "MERCANCIA", "SUBMERCANCIA", "PROVEEDOR_PRIN", "MANTTO_CLASIF", "CODIGO_NORMA_ORDENES", "CD_PLANIF", "REGLA_LIMITE_PLANIF", "LIMITE_CONGELACION", "LIMITE_VISLZ_MENSAJE", "ELIM_MENSAJE_MRP", "CODIGO_TP_ENVIO", "NIVEL_PLAZO", "FIJO_FARIABLE", "MAXIMO", "MINIMO", "CANTIDAD_ORDEN_MULTIPLE", "CANTIDAD_PUNTO_ORDEN", "PUNTO_ORDEN", "STOCK_SEGURIDAD", "RECEPCION - OP (4310)", "RECEPCION - OP (4320)", "RECEPCION - OJ (4310)", "RECEPCION - OJ (4320)", "TRANSFERENCIA - IT (4122)", "TRANSFERENCIA - IT (4124)", "SALIDA NORMAL - II (4122)", "SALIDA NORMAL - II (4124)", "DESPACHO OT - IM (4122)", "DESPACHO OT - IM (4124)", "COSTO COMPRA (01)", "COSTO PROMEDIO (02)", "EXISTENCIAS") AS 
  select
ALM.COMPANIA
,ALM.UN
,ALM.ITEM_CLAVE
,ALM.ITEM_NUMERO
,ALM.ITEM_NOPARTE
,ALM.ITEM_DESCRIPCION
,ALM.ITEM_MODELO
,ALM.ITEM_TEXTO_BUSQUEDA
,ALM.ALM_TIPO
,ALM.LINEA_TIPO
,ALM.GL_CODIGO
,ALM.UDM_PRIM
,ALM.UDM_SECU
,ALM.UDM_COMPRA
,ALM.PROVEEDOR
,ALM.PLANEADOR
,ALM.COMPRADOR
,ALM.MERCANCIA
,ALM.SUBMERCANCIA
,ALM.PROVEEDOR_PRIN
,ALM.MANTTO_CLASIF
,ALM.CODIGO_NORMA_ORDENES
,ALM.CD_PLANIF
,ALM.REGLA_LIMITE_PLANIF
,ALM.LIMITE_CONGELACION
,ALM.LIMITE_VISLZ_MENSAJE
,ALM.ELIM_MENSAJE_MRP
,ALM.CODIGO_TP_ENVIO
,ALM.NIVEL_PLAZO
,ALM.FIJO_FARIABLE
,ALM.MAXIMO
,ALM.MINIMO
,ALM.CANTIDAD_ORDEN_MULTIPLE
,ALM.CANTIDAD_PUNTO_ORDEN
,ALM.PUNTO_ORDEN
,ALM.STOCK_SEGURIDAD
,RECEP_OP_4310.CUENTA_NUMERO || ' (' || RECEP_OP_4310.CUENTA_DESCRIPCION || ')' as "RECEPCION - OP (4310)"
,RECEP_OP_4320.CUENTA_NUMERO || ' (' || RECEP_OP_4320.CUENTA_DESCRIPCION || ')' as "RECEPCION - OP (4320)"

,RECEP_OJ_4310.CUENTA_NUMERO || ' (' || RECEP_OJ_4310.CUENTA_DESCRIPCION || ')' as "RECEPCION - OJ (4310)"
,RECEP_OJ_4320.CUENTA_NUMERO || ' (' || RECEP_OJ_4320.CUENTA_DESCRIPCION || ')' as "RECEPCION - OJ (4320)"

,TRANSF_IT_4122.CUENTA_NUMERO || ' (' || TRANSF_IT_4122.CUENTA_DESCRIPCION || ')' as "TRANSFERENCIA - IT (4122)"
,TRANSF_IT_4124.CUENTA_NUMERO || ' (' || TRANSF_IT_4124.CUENTA_DESCRIPCION || ')' as "TRANSFERENCIA - IT (4124)"

,SAL_II_4122.CUENTA_NUMERO || ' (' || SAL_II_4122.CUENTA_DESCRIPCION || ')' as "SALIDA NORMAL - II (4122)"
,SAL_II_4124.CUENTA_NUMERO || ' (' || SAL_II_4124.CUENTA_DESCRIPCION || ')' as "SALIDA NORMAL - II (4124)"

,DESPOT_IM_4122.CUENTA_NUMERO || ' (' || DESPOT_IM_4122.CUENTA_DESCRIPCION || ')' as "DESPACHO OT - IM (4122)"
,DESPOT_IM_4124.CUENTA_NUMERO || ' (' || DESPOT_IM_4124.CUENTA_DESCRIPCION || ')' as "DESPACHO OT - IM (4124)"

,COSTO_01.COSTO as "COSTO COMPRA (01)"
,COSTO_02.COSTO as "COSTO PROMEDIO (02)"

,STOCK.EXISTENCIAS

from NUVPD.VIEW_ITEM_ALMACEN ALM

/* ICAS DE RECEPCION de TIPO DE OP
----------------------------------------------------------------------------*/
left outer join NUVPD.VIEW_ICASM RECEP_OP_4310 on 1=1
            and RECEP_OP_4310.ICA = 4310
            and RECEP_OP_4310.DOC_TIPO = 'OP' 
            and RECEP_OP_4310.COMPANIA = ALM.COMPANIA
            and RECEP_OP_4310.GL_CODIGO = ALM.GL_CODIGO              
            and RECEP_OP_4310.CUENTA_UN = ALM.UN
            AND RECEP_OP_4310.CUENTA_UN_TIPO  NOT IN ('-','*','MD')
                     
left outer join NUVPD.VIEW_ICASM RECEP_OP_4320 on 1=1
            and RECEP_OP_4320.ICA = 4320 
            and RECEP_OP_4320.DOC_TIPO = RECEP_OP_4310.DOC_TIPO            
            and RECEP_OP_4320.COMPANIA = ALM.COMPANIA
            and RECEP_OP_4320.GL_CODIGO = ALM.GL_CODIGO
            --and ICA_RECEP1_4320.CUENTA_UN
            AND RECEP_OP_4320.CUENTA_UN_TIPO  NOT IN ('-','*','MD')


/* ICAS DE RECEPCION de TIPO DE OJ
----------------------------------------------------------------------------*/
left outer join NUVPD.VIEW_ICASM RECEP_OJ_4310 on 1=1
            and RECEP_OJ_4310.ICA = 4310
            and RECEP_OJ_4310.DOC_TIPO = 'OJ' 
            and RECEP_OJ_4310.COMPANIA = ALM.COMPANIA
            and RECEP_OJ_4310.GL_CODIGO = ALM.GL_CODIGO              
            and RECEP_OJ_4310.CUENTA_UN = ALM.UN
            AND RECEP_OJ_4310.CUENTA_UN_TIPO  NOT IN ('-','*','MD')
                     
left outer join NUVPD.VIEW_ICASM RECEP_OJ_4320 on 1=1
            and RECEP_OJ_4320.ICA = 4320 
            and RECEP_OJ_4320.DOC_TIPO = RECEP_OJ_4310.DOC_TIPO            
            and RECEP_OJ_4320.COMPANIA = ALM.COMPANIA
            and RECEP_OJ_4320.GL_CODIGO = ALM.GL_CODIGO
            --and ICA_RECEP1_4320.CUENTA_UN
            AND RECEP_OJ_4320.CUENTA_UN_TIPO  NOT IN ('-','*','MD')


/* ICAS DE TRANFERENCIA (DOCUMENTO IT) 
----------------------------------------------------------------------------*/
left outer join NUVPD.VIEW_ICASM TRANSF_IT_4122 on 1=1
            and TRANSF_IT_4122.ICA = 4122
            and TRANSF_IT_4122.DOC_TIPO = 'IT' 
            and TRANSF_IT_4122.COMPANIA = ALM.COMPANIA
            and TRANSF_IT_4122.GL_CODIGO = ALM.GL_CODIGO              
            and TRANSF_IT_4122.CUENTA_UN = ALM.UN
            AND TRANSF_IT_4122.CUENTA_UN_TIPO  NOT IN ('-','*','MD')

left outer join NUVPD.VIEW_ICASM TRANSF_IT_4124 on 1=1
            and TRANSF_IT_4124.ICA = 4124 
            and TRANSF_IT_4124.DOC_TIPO = TRANSF_IT_4122.DOC_TIPO
            and TRANSF_IT_4124.COMPANIA = ALM.COMPANIA
            and TRANSF_IT_4124.GL_CODIGO = ALM.GL_CODIGO 
            and TRANSF_IT_4124.CUENTA_UN = ALM.UN
            AND TRANSF_IT_4124.CUENTA_UN_TIPO  NOT IN ('-','*','MD')
            
/* ICAS DE SALIDAS NORMALES (DOCUMENTO II) 
----------------------------------------------------------------------------*/
left outer join NUVPD.VIEW_ICASM SAL_II_4122 on 1=1
            and SAL_II_4122.ICA = 4122
            and SAL_II_4122.DOC_TIPO = 'II' 
            and SAL_II_4122.COMPANIA = ALM.COMPANIA
            and SAL_II_4122.GL_CODIGO = ALM.GL_CODIGO              
            and SAL_II_4122.CUENTA_UN = ALM.UN
            AND SAL_II_4122.CUENTA_UN_TIPO  NOT IN ('-','*','MD')

left outer join NUVPD.VIEW_ICASM SAL_II_4124 on 1=1
            and SAL_II_4124.ICA = 4124 
            and SAL_II_4124.DOC_TIPO = SAL_II_4122.DOC_TIPO
            and SAL_II_4124.COMPANIA = ALM.COMPANIA
            and SAL_II_4124.GL_CODIGO = ALM.GL_CODIGO 
            and SAL_II_4124.CUENTA_UN = ALM.UN
            AND SAL_II_4124.CUENTA_UN_TIPO  NOT IN ('-','*','MD')            


/* ICAS DE DESPACHO A OT (DOCUMENTO IM) 
----------------------------------------------------------------------------*/
left outer join NUVPD.VIEW_ICASM DESPOT_IM_4122 on 1=1
            and DESPOT_IM_4122.ICA = 4122
            and DESPOT_IM_4122.DOC_TIPO = 'IM' 
            and DESPOT_IM_4122.COMPANIA = ALM.COMPANIA
            and DESPOT_IM_4122.GL_CODIGO = ALM.GL_CODIGO              
            and DESPOT_IM_4122.CUENTA_UN = ALM.UN
            AND DESPOT_IM_4122.CUENTA_UN_TIPO  NOT IN ('-','*','MD')

left outer join NUVPD.VIEW_ICASM DESPOT_IM_4124 on 1=1
            and DESPOT_IM_4124.ICA = 4124 
            and DESPOT_IM_4124.DOC_TIPO = DESPOT_IM_4122.DOC_TIPO
            and DESPOT_IM_4124.COMPANIA = ALM.COMPANIA
            and DESPOT_IM_4124.GL_CODIGO = ALM.GL_CODIGO 
            and DESPOT_IM_4124.CUENTA_UN = ALM.UN
            AND DESPOT_IM_4124.CUENTA_UN_TIPO  NOT IN ('-','*','MD')
            

/* COSTO DE COMPRA (01) 
----------------------------------------------------------------------------*/
left outer join (
                    select
                    TRIM(COMCU) as UN
                    ,COITM as ITEM_CLAVE
                    ,TRIM(COLITM) as ITEM_NUMERO
                    ,TRIM(COAITM) as ITEM_NOPART
                    ,COLEDG as METODO
                    ,COUNCS/10000 as COSTO
                    from PRODDTA.F4105
                    where 1=1
                ) COSTO_01 on 1=1
                and COSTO_01.UN = ALM.UN
                and COSTO_01.ITEM_CLAVE = ALM.ITEM_CLAVE
                AND COSTO_01.METODO = 01
            
/* COSTO PROMEDIO (02) 
----------------------------------------------------------------------------*/
left outer join (
                    select
                    TRIM(COMCU) as UN
                    ,COITM as ITEM_CLAVE
                    ,TRIM(COLITM) as ITEM_NUMERO
                    ,TRIM(COAITM) as ITEM_NOPART
                    ,COLEDG as METODO
                    ,COUNCS/10000 as COSTO
                    from PRODDTA.F4105
                    where 1=1

            ) COSTO_02 on 1=1
            and COSTO_02.UN = ALM.UN
            and COSTO_02.ITEM_CLAVE = ALM.ITEM_CLAVE
            AND COSTO_02.METODO = 02   
            
            
/* EXISTENCIAS
----------------------------------------------------------------------------*/            
LEFT OUTER JOIN (
                    select
                    LIITM  as ITEM_CLAVE
                    ,trim(LIMCU)  as UN
                    ,SUM(LIPQOH)/10000 as EXISTENCIAS
                    ,SUM(LIPREQ)/10000 as OC_PENDIENTE
                    ,sum(LIQOWO)/10000 as OT_COMPROMETIDO
                    from PRODDTA.F41021  
                    where 1=1
                    group by
                    LIITM
                    ,LIMCU
                ) STOCK on 1=1
           and STOCK.UN = ALM.UN
           AND STOCK.ITEM_CLAVE = ALM.ITEM_CLAVE
            
where 1=1

order by 
  ALM.UN
  ,ALM.ITEM_CLAVE;
