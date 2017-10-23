
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_CXPVSMXL" ("FAC_COMPANIA", "FAC_TIPO", "FAC", "FACTURA", "PROVEEDOR", "PROVEEDOR_DESC", "BENEFICIARIO", "BENEFICIARIO_DESC", "FECHA_FACTURA", "FECHA_LM", "ANIO", "PERIODO", "UN", "BATCH", "BATCH_TIPO", "BATCH_FECHA", "POSTEO", "MONTO_TOTAL_MX", "MONTO_PENDIENTE_MX", "MONTO_IMPONIBLE_MX", "MONTO_NOIMPONIBLE_MX", "MONTO_IMPUESTO_MX", "IMPUESTO", "MONEDA", "TASA", "MONTO_TOTAL_EX", "MONTO_PENDIENTE_EX", "MONTO_IMPONIBLE_EX", "MONTO_NOIMPONIBLE_EX", "MONTO_IMPUESTO_EX", "MONTO_XDIST_MX", "MONTO_XDIST_EX", "OC_COMPANIA", "OC_TIPO", "OC", "CREATED_BY", "CREATED_BY_DESC", "XML_UUID", "XML_PROVEEDOR", "XML_PROVEEDOR_RFC", "XML_COMPANIA_RFC", "XML_FACTURA_TIPO", "XML_IMPORTE", "XML_FECHA", "XML_MONEDA", "XML_ASOCIACION") AS 
  SELECT
FACTU.FAC_COMPANIA
,FACTU.FAC_TIPO
,FACTU.FAC
,FACTU.FACTURA
,FACTU.PROVEEDOR
,nvl(trim(PROVEEDOR.ABALPH),'--') AS PROVEEDOR_DESC 
,FACTU.BENEFICIARIO
,nvl(trim(BENEF.ABALPH),'--') AS BENEFICIARIO_DESC 
,FACTU.FECHA_FACTURA
,FACTU.FECHA_LM
,FACTU.ANIO
,FACTU.PERIODO
,FACTU.UN
,FACTU.BATCH
,FACTU.BATCH_TIPO
,FACTU.BATCH_FECHA
,FACTU.POSTEO
,FACTU.MONTO_TOTAL_MX
,FACTU.MONTO_PENDIENTE_MX
,FACTU.MONTO_IMPONIBLE_MX
,FACTU.MONTO_NOIMPONIBLE_MX
,FACTU.MONTO_IMPUESTO_MX
,FACTU.IMPUESTO
,FACTU.MONEDA
,FACTU.TASA
,FACTU.MONTO_TOTAL_EX
,FACTU.MONTO_PENDIENTE_EX
,FACTU.MONTO_IMPONIBLE_EX
,FACTU.MONTO_NOIMPONIBLE_EX
,FACTU.MONTO_IMPUESTO_EX
,FACTU.MONTO_XDIST_MX
,FACTU.MONTO_XDIST_EX
,FACTU.OC_COMPANIA
,FACTU.OC_TIPO
,FACTU.OC
,FACTU.CREATED_BY
,NVL(TRIM(ORG.DIR_DESC),'--') as CREATED_BY_DESC
,NVL(XML.CDGENKEY,'--') as XML_UUID
,nvl(XMLDET.FTAN8,0) as XML_PROVEEDOR
,NVL(XMLDET.FTTAX,'--') as XML_PROVEEDOR_RFC
,NVL(XMLDET.FTTAXS,'--') as XML_COMPANIA_RFC
,NVL(XMLDET.FTBRTPO,'--') as XML_FACTURA_TIPO
,NVL(XMLDET.FTAMRT1/10000,0) as XML_IMPORTE
,case when XMLDET.FTIVD <> 0 then TO_DATE(1900000 + XMLDET.FTIVD,'YYYYDDD') else TO_DATE('01/01/1000','DD/MM/YYYY') end as XML_FECHA
,NVL(XMLDET.FTCRCD,'--') as XML_MONEDA
,NVL(XMLDET.FTURCD,'--') as XML_ASOCIACION     

FROM (
   select
         PASIVO.RPKCO as FAC_COMPANIA
        ,PASIVO.RPDCT as FAC_TIPO
        ,PASIVO.RPDOC as FAC
        ,nvl(trim(PASIVO.RPVINV),'--') as FACTURA
        ,PASIVO.RPAN8 as PROVEEDOR
        ,PASIVO.RPPYE as BENEFICIARIO
        ,case when PASIVO.RPDIVJ <> 0 then TO_DATE(1900000 + PASIVO.RPDIVJ,'YYYYDDD') end as FECHA_FACTURA
        ,CASE WHEN PASIVO.RPDGJ <> 0 THEN TO_DATE(1900000 + PASIVO.RPDGJ,'YYYYDDD') END AS FECHA_LM
        ,PASIVO.RPFY  as ANIO
        ,PASIVO.RPPN  as PERIODO
        ,nvl(trim(PASIVO.RPMCU),'--') as UN
        ,PASIVO.RPICU as BATCH
        ,PASIVO.RPICUT as BATCH_TIPO
        ,case when PASIVO.RPDICJ <> 0 then TO_DATE(1900000 + PASIVO.RPDICJ,'YYYYDDD') end as BATCH_FECHA
        ,PASIVO.RPPOST as POSTEO
        ,SUM(PASIVO.RPAG/100) as MONTO_TOTAL_MX
        ,SUM(PASIVO.RPAAP/100) as MONTO_PENDIENTE_MX
        ,SUM(PASIVO.RPATXA/100) as MONTO_IMPONIBLE_MX
        ,SUM(PASIVO.RPATXN/100) as MONTO_NOIMPONIBLE_MX
        ,SUM(PASIVO.RPSTAM/100) as MONTO_IMPUESTO_MX
        ,NVL(TRIM(PASIVO.RPTXA1),'--') as IMPUESTO        
        ,PASIVO.RPCRCD as MONEDA
        ,PASIVO.RPCRR as TASA
        ,SUM(PASIVO.RPACR/100) as MONTO_TOTAL_EX
        ,SUM(PASIVO.RPFAP/100) as MONTO_PENDIENTE_EX
        ,SUM(PASIVO.RPCTXA/100) as MONTO_IMPONIBLE_EX
        ,SUM(PASIVO.RPCTXN/100) as MONTO_NOIMPONIBLE_EX
        ,SUM(PASIVO.RPCTAM/100) as MONTO_IMPUESTO_EX
        ,SUM(PASIVO.RPATAD/100) as MONTO_XDIST_MX
        ,SUM(PASIVO.RPCTAD/100) as MONTO_XDIST_EX
        ,NVL(TRIM(PASIVO.RPPKCO),'--') as OC_COMPANIA
        ,NVL(TRIM(PASIVO.RPPDCT),'--') as OC_TIPO         
        ,TO_NUMBER(NVL(TRIM(PASIVO.RPPO),0)) as OC          
        ,TRIM(PASIVO.RPTORG) as CREATED_BY
      
      from PRODDTA.F0411 PASIVO where 1=1
      and PASIVO.RPDCTA <> 'PE'
      AND PASIVO.RPAG > 0
      
      group by
        PASIVO.RPKCO
        ,PASIVO.RPDCT
        ,PASIVO.RPDOC
        ,nvl(trim(PASIVO.RPVINV),'--')
        ,PASIVO.RPAN8
        ,PASIVO.RPPYE
        ,case when PASIVO.RPDIVJ <> 0 then TO_DATE(1900000 + PASIVO.RPDIVJ,'YYYYDDD') end
        ,CASE WHEN PASIVO.RPDGJ <> 0 THEN TO_DATE(1900000 + PASIVO.RPDGJ,'YYYYDDD') END
        ,PASIVO.RPFY 
        ,PASIVO.RPPN 
        ,nvl(trim(PASIVO.RPMCU),'--')
        ,PASIVO.RPICU
        ,PASIVO.RPICUT
        ,case when PASIVO.RPDICJ <> 0 then TO_DATE(1900000 + PASIVO.RPDICJ,'YYYYDDD') end
        ,PASIVO.RPPOST
        ,NVL(TRIM(PASIVO.RPTXA1),'--')
        ,PASIVO.RPCRCD
        ,PASIVO.RPCRR
        ,NVL(TRIM(PASIVO.RPPKCO),'--') 
        ,NVL(TRIM(PASIVO.RPPDCT),'--')
        ,TO_NUMBER(NVL(TRIM(PASIVO.RPPO),0)) 
        ,TRIM(PASIVO.RPTORG)

    ) FACTU
    
/*   GENERADORES
--------------------------------------------------------------------------------*/                 
left outer join NUVPD.VIEW_USUARIOS ORG on 1=1
            and ORG.CLAVE = FACTU.CREATED_BY
         
/*   PROVEEDORES   
--------------------------------------------------------------------------------*/ 
left outer join PRODDTA.F0101 PROVEEDOR  
             on PROVEEDOR.ABAN8 = FACTU.PROVEEDOR  
             
/*   BENEFICIARIOS   
--------------------------------------------------------------------------------*/ 
left outer join PRODDTA.F0101 BENEF  
             on BENEF.ABAN8 = FACTU.BENEFICIARIO               

 /*   XMLS
--------------------------------------------------------------------------------*/                        
left outer join PRODDTA.F5903001 XML on 1=1
            AND XML.CDKCOO = FACTU.FAC_COMPANIA   --/ Compania
            and XML.CDDCTO = FACTU.FAC_TIPO   --/ Tipo
            and XML.cddoco = FACTU.FAC   --/ Numero    

    /*   XMLS
--------------------------------------------------------------------------------*/  
left outer join PRODDTA.F5903000 XMLDET on 1=1
            AND XMLDET.FTGENKEY = xml.CDGENKEY     
                    
    
where 1=1;