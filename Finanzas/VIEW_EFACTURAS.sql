
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_EFACTURAS" ("COMPANIA", "TIPO", "NUMERO", "LINEA", "AJUSTE", "AJUSTE_TIPO", "FACTURA", "PROVEEDOR", "BENEFICIARIO", "FECHA_FACTURA", "FECHA_VENCIMIENTO", "FECHA_LM", "ANIO", "PERIODO", "BATCH", "BATCH_TIPO", "BATCH_FECHA", "POSTEO", "MONTO_TOTAL_MX", "MONTO_PENDIENTE_MX", "MONTO_IMPONIBLE_MX", "MONTO_NOIMPONIBLE_MX", "MONTO_IMPUESTO_MX", "IMPUESTO", "MONEDA", "TASA", "MONTO_TOTAL_EX", "MONTO_PENDIENTE_EX", "MONTO_IMPONIBLE_EX", "MONTO_NOIMPONIBLE_EX", "MONTO_IMPUESTO_EX", "MONTO_XDIST_MX", "MONTO_XDIST_EX", "BANCO", "GLCLASS", "UN", "CUENTA_SUBLIBRO", "CUENTA_SUB_TIPO", "PAGO_ESTADO", "PAGO_TERMINOS", "PAGO_INTRUMENTO", "FLAG_VOID", "CODIGO_GESTION", "OC_COMPANIA", "OC_TIPO", "OC", "OC_LINEA", "OC_SUFIX", "DESCRIPCION", "ITEM", "ITEM_NUMERO", "ITEM_DESC", "ITEM_GLCLASS", "ITEM_GLCLASS_DESC", "CANTIDAD", "UDM", "UDM_DESC", "CREADOR", "UPDATER", "FECHA_UPDATE") AS 
  select
         PASIVO.RPKCO as COMPANIA
        ,PASIVO.RPDCT as TIPO
        ,PASIVO.RPDOC as NUMERO
        ,PASIVO.RPSFX as LINEA
      
        ,PASIVO.RPSFXE as AJUSTE
        ,nvl(trim(PASIVO.RPDCTA),'--') as AJUSTE_TIPO
        
        ,nvl(trim(PASIVO.RPVINV),'--') as FACTURA
        
        ,PASIVO.RPAN8 as PROVEEDOR
        ,PASIVO.RPPYE as BENEFICIARIO
      
        ,case when PASIVO.RPDIVJ <> 0 then TO_DATE(1900000 + PASIVO.RPDIVJ,'YYYYDDD') end as FECHA_FACTURA
        ,case when PASIVO.RPDDJ <> 0 then TO_DATE(1900000 + PASIVO.RPDDJ,'YYYYDDD') end as FECHA_VENCIMIENTO
        ,CASE WHEN PASIVO.RPDGJ <> 0 THEN TO_DATE(1900000 + PASIVO.RPDGJ,'YYYYDDD') END AS FECHA_LM
      
        ,PASIVO.RPFY  as ANIO
        ,PASIVO.RPPN  as PERIODO
        --,PASIVO.RPCO  as COMPANIA
        
        ,PASIVO.RPICU as BATCH
        ,PASIVO.RPICUT as BATCH_TIPO
        ,case when PASIVO.RPDICJ <> 0 then TO_DATE(1900000 + PASIVO.RPDICJ,'YYYYDDD') end as BATCH_FECHA
        ,PASIVO.RPPOST as POSTEO
        
        ,PASIVO.RPAG/100 as MONTO_TOTAL_MX
        ,PASIVO.RPAAP/100 as MONTO_PENDIENTE_MX
        ,PASIVO.RPATXA/100 as MONTO_IMPONIBLE_MX
        ,PASIVO.RPATXN/100 as MONTO_NOIMPONIBLE_MX
        ,PASIVO.RPSTAM/100 as MONTO_IMPUESTO_MX
        ,nvl(trim(PASIVO.RPTXA1),'--') as IMPUESTO
        
        ,PASIVO.RPCRCD as MONEDA
        ,PASIVO.RPCRR as TASA
        ,PASIVO.RPACR/100 as MONTO_TOTAL_EX
        ,PASIVO.RPFAP/100 as MONTO_PENDIENTE_EX
        ,PASIVO.RPCTXA/100 as MONTO_IMPONIBLE_EX
        ,PASIVO.RPCTXN/100 as MONTO_NOIMPONIBLE_EX
        ,PASIVO.RPCTAM/100 as MONTO_IMPUESTO_EX

        ,PASIVO.RPATAD/100 as MONTO_XDIST_MX
        ,PASIVO.RPCTAD/100 as MONTO_XDIST_EX        
        
        ,PASIVO.RPGLBA as BANCO
        ,NVL(TRIM(PASIVO.RPGLC),'--') as GLCLASS

        ,NVL(TRIM(PASIVO.RPMCU),'--') as UN
        ,NVL(TRIM(PASIVO.RPSBL),'--') as CUENTA_SUBLIBRO
        ,nvl(trim(PASIVO.RPSBLT),'--') as CUENTA_SUB_TIPO
        
        ,NVL(TRIM(PASIVO.RPPST),'--') as PAGO_ESTADO
        ,NVL(TRIM(PASIVO.RPPTC),'--') as PAGO_TERMINOS
        ,NVL(TRIM(PASIVO.RPPYIN),'--') as PAGO_INTRUMENTO  
        
        ,nvl(trim(PASIVO.RPVOD),'--') as FLAG_VOID
        ,nvl(trim(PASIVO.RPCRC),'--') as CODIGO_GESTION
        
        ,NVL(TRIM(PASIVO.RPPKCO),'--') as OC_COMPANIA
        ,nvl(trim(PASIVO.RPPDCT),'--') as OC_TIPO
        
        ,TO_NUMBER(NVL(trim(PASIVO.RPPO),'0')) as oc
        
        ,PASIVO.RPLNID/1000 as OC_LINEA

        ,nvl(trim(PASIVO.RPSFXO),'--') as OC_SUFIX
        
        ,nvl(trim(PASIVO.RPRMK),'--') as DESCRIPCION
          
        ,PASIVO.RPITM as ITEM
        ,NVL(ITEM.IMLITM,'--') as ITEM_NUMERO        
        ,NVL(ITEM.IMDSC1 || ITEM.IMDSC2,'--') as ITEM_DESC
        ,nvl(ITEM.IMGLPT,'--') as ITEM_GLCLASS
        ,nvl(TRIM(GLCLASS.DRDL01),'--') as ITEM_GLCLASS_DESC
        
        ,(PASIVO.RPU/100) as CANTIDAD
        ,nvl(trim(PASIVO.RPUM),'--') as UDM
        ,nvl(TRIM(UDM.DRDL01),'--') as UDM_DESC
        
        ,TRIM(PASIVO.RPTORG) as CREADOR
        ,trim(PASIVO.RPUSER) as UPDATER
        ,CASE WHEN PASIVO.RPUPMJ <> 0 THEN TO_DATE(1900000 + PASIVO.RPUPMJ,'YYYYDDD') END AS FECHA_UPDATE
        
      
      from PRODDTA.F0411 PASIVO

      /*   ITEMS
      --------------------------------------------------------------------------------*/
      left outer join PRODDTA.F4101 ITEM
                   on ITEM.IMITM = PASIVO.RPITM

      /*   UNIDADES DE MEDIDAS 
      --------------------------------------------------------------------------------*/
      LEFT OUTER JOIN PRODCTL.F0005D UDM
                   ON UDM.DRSY = '00'
                  and UDM.DRRT = 'UM'
                  AND TRIM(UDM.DRKY) = trim(PASIVO.RPUM)   

      /*   GLCLASS
      --------------------------------------------------------------------------------*/                  
      LEFT OUTER JOIN PRODCTL.F0005 GLCLASS
                   ON GLCLASS.DRSY = '41'    
                  AND GLCLASS.DRRT = '9'    
                  AND TRIM(GLCLASS.DRKY) = TRIM(ITEM.IMGLPT);
