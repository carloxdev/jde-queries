
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_RECEPCIONES" ("OC_COMPANIA", "OC_TIPO", "OC", "OC_LINEA", "OC_LINEA_TIPO", "OC_SUFIX", "TRAN_COMPANIA", "TRAN_UN", "TRAN_TIPO", "TRAN_TIPO_DESC", "TRAN_LINEA", "DOC_COMPANIA", "DOC_TIPO", "DOC", "DOC_LINEA", "DOC_JE_LINEA", "DOC_FACTURA", "PROVEEDOR", "ITEM", "ITEM_NUMERO", "ITEM_DESCRIPCION", "ITEM_GLCLASS", "ORIGINADOR", "ORIGINADOR_DESC", "FECHA_CREACION", "FECHA_TRAN", "FECHA_LM", "CANTIDAD_RECIB", "UDM_RECIB", "PU_EX", "MONTO_RECIB_EX", "MONEDA", "TASA", "PU_MX", "MONTO_RECIB_MX", "IMPUESTO", "IMPUESTO_FLAG", "BATCH", "BATCH_TIPO", "ACTIVO", "UBICACION", "LOTE", "CONTENEDOR", "OBSERVACIONES", "UPDATER", "UPDATER_DESC", "FECHA_UPDATE") AS 
  select
          RECEIVE.PRKCOO AS OC_COMPANIA
          ,RECEIVE.PRDCTO AS OC_TIPO
          ,RECEIVE.PRDOCO as OC
          ,RECEIVE.PRLNID/1000 AS OC_LINEA
          ,TRIM(RECEIVE.PRLNTY) as OC_LINEA_TIPO
          ,RECEIVE.PRSFXO AS OC_SUFIX   
      
          ,RECEIVE.PRCO as TRAN_COMPANIA
          ,trim(RECEIVE.PRMCU) as TRAN_UN     
          ,RECEIVE.PRMATC as TRAN_TIPO
          ,CASE
            WHEN RECEIVE.PRMATC = 1 THEN 'RECEPCION'
            WHEN RECEIVE.PRMATC = 4 THEN 'REVERCION RECEPCION'
            WHEN RECEIVE.PRMATC = 2 THEN 'COTEJO'
            when RECEIVE.PRMATC = 3 then 'ANULACION COTEJO'
            else 'ERROR'
          end as TRAN_TIPO_DESC 
          ,RECEIVE.PRNLIN AS TRAN_LINEA
          ,RECEIVE.PRKCO AS DOC_COMPANIA
          ,RECEIVE.PRDCT AS DOC_TIPO
          ,RECEIVE.PRDOC as DOC
          ,TO_NUMBER(nvl(trim(RECEIVE.PRSFX),'0')) AS DOC_LINEA
          ,RECEIVE.PRJELN as DOC_JE_LINEA
          ,nvl(trim(RECEIVE.PRVINV),'--') AS DOC_FACTURA
          
          ,RECEIVE.PRAN8  as PROVEEDOR
          ,RECEIVE.PRITM as ITEM
          ,TRIM(RECEIVE.PRLITM) as ITEM_NUMERO
          ,NVL(TRIM(ITEM.IMDSC1 || ITEM.IMDSC2),'--') as ITEM_DESCRIPCION
          ,RECEIVE.PRGLC AS ITEM_GLCLASS
          ,TRIM(RECEIVE.PRTORG) as ORIGINADOR
          ,NVL(trim(ORG.DIR_DESC), '--') AS ORIGINADOR_DESC
          
          ,case when RECEIVE.PRTRDJ <> 0 then TO_DATE(1900000 + RECEIVE.PRTRDJ,'yyyyddd') end as FECHA_CREACION      
          ,case when RECEIVE.PRRCDJ <> 0 then TO_DATE(1900000 + RECEIVE.PRRCDJ,'yyyyddd') end as FECHA_TRAN
          ,case when RECEIVE.PRDGL <> 0 then TO_DATE(1900000 + RECEIVE.PRDGL,'yyyyddd') end as FECHA_LM
          
          ,RECEIVE.PRUREC/10000 AS CANTIDAD_RECIB
          ,RECEIVE.PRUOM AS UDM_RECIB
          ,RECEIVE.PRFRRC/10000 as PU_EX    
          ,RECEIVE.PRFREC/100 AS MONTO_RECIB_EX
          ,RECEIVE.PRCRCD AS MONEDA
          ,RECEIVE.PRCRR AS TASA
          ,RECEIVE.PRPRRC/10000 as PU_MX
          ,RECEIVE.PRAREC/100 AS MONTO_RECIB_MX
          ,TRIM(RECEIVE.PRTXA1) AS IMPUESTO
          ,RECEIVE.PRTX  AS IMPUESTO_FLAG

          ,NVL(ASIENTOS.BATCH,0 )  as BATCH
          ,nvl(ASIENTOS.BATCH_TIPO,'--') AS BATCH_TIPO

          ,nvl(TRIM(RECEIVE.PRASID),'--' ) as ACTIVO
          ,NVL(TRIM(RECEIVE.PRLOCN),'--' ) as UBICACION
          ,NVL(TRIM(RECEIVE.PRLOTN),'--' ) as LOTE
          ,NVL(TRIM(RECEIVE.PRCNID),'--' ) as CONTENEDOR
          ,NVL(TRIM(RECEIVE.PRVRMK),'--' ) as OBSERVACIONES
          ,TRIM(RECEIVE.PRUSER) as UPDATER
          ,NVL(trim(UPD.DIR_DESC), '--') AS UPDATER_DESC
          ,case when RECEIVE.PRUPMJ <> 0 then TO_DATE(1900000 + RECEIVE.PRUPMJ,'YYYYDDD') end as FECHA_UPDATE
          
      FROM PRODDTA.F43121 RECEIVE
      
      /*  ITEMS
      --------------------------------------------------------------------------------*/    
      left outer join PRODDTA.F4101 ITEM on 1=1
                  and ITEM.IMITM = RECEIVE.PRITM
      
      /*   GENERADORES
      --------------------------------------------------------------------------------*/                 
      left outer join NUVPD.VIEW_USUARIOS ORG on 1=1
                  and ORG.CLAVE = RECEIVE.PRTORG
                  
      /*   ACTUALIZADORES
      --------------------------------------------------------------------------------*/ 
      left outer join NUVPD.VIEW_USUARIOS UPD on 1=1
                  and UPD.CLAVE = RECEIVE.PRUSER      
               
      /*   ASIENTOS CONTABLES
      --------------------------------------------------------------------------------*/
      left outer join (
                        SELECT
                             ASIENTO.GLKCO AS DOC_COMPANIA
                            ,ASIENTO.GLDCT AS DOC_TIPO
                            ,ASIENTO.GLDOC AS DOC
                            ,ASIENTO.GLSFX as DOC_LINEA
                            ,ASIENTO.GLPKCO as OC_COMPANIA
                            ,ASIENTO.GLDCTO as OC_TIPO
                            ,TO_NUMBER(NVL(TRIM(ASIENTO.GLPO),'0')) as OC
                            ,ASIENTO.GLICU AS BATCH
                            ,ASIENTO.GLICUT as BATCH_TIPO
                        from PRODDTA.F0911 ASIENTO where 1=1
                        and ASIENTO.GLDCT = 'OV'
                        GROUP BY
                             ASIENTO.GLKCO
                            ,ASIENTO.GLDCT
                            ,ASIENTO.GLDOC
                            ,ASIENTO.GLSFX
                            ,ASIENTO.GLPKCO
                            ,ASIENTO.GLPO
                            ,ASIENTO.GLDCTO
                            ,ASIENTO.GLICU
                            ,ASIENTO.GLICUT 

                      ) ASIENTOS on 1=1
                  and ASIENTOS.DOC_COMPANIA = RECEIVE.PRKCO
                  AND ASIENTOS.DOC_TIPO = RECEIVE.PRDCT
                  AND ASIENTOS.DOC = RECEIVE.PRDOC
                  and ASIENTOS.DOC_LINEA = RECEIVE.PRSFX 
                  
                  and ASIENTOS.OC_COMPANIA = RECEIVE.PRKCOO
                  and ASIENTOS.OC = RECEIVE.PRDOCO
                  and ASIENTOS.OC_TIPO = RECEIVE.PRDCTO
                  
      order by 
        RECEIVE.PRKCOO  --/ OC_COMPANIA
        ,RECEIVE.PRDCTO --/ OC_TIPO
        ,RECEIVE.PRDOCO --/ OC
        ,RECEIVE.PRLNID --/ OC_LINEA
        ,RECEIVE.PRNLIN --/ TRAN_LINEA
        ,RECEIVE.PRMATC --/ TRAN_TIPO
;
