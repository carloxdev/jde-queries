
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_EFACTURARECEP" ("DOC_COMPANIA", "DOC_TIPO", "DOC", "PROVEEDOR", "UN", "FACTURA", "FECHA_LM", "MONTO_TOTAL_MX", "MONTO_PENDIENTE_MX", "MONTO_IMPONIBLE_MX", "MONTO_NOIMPONIBLE_MX", "MONTO_IMPUESTO_MX", "RECEP_COMPANIA", "RECEP_TIPO", "RECEP_DOC") AS 
  select
DOC_COMPANIA
,DOC_TIPO
,DOC
,PROVEEDOR
,TRIM(UN) AS UN
,FACTURA
,FECHA_LM
,SUM(MONTO_TOTAL_MX) AS MONTO_TOTAL_MX
,SUM(MONTO_PENDIENTE_MX) AS MONTO_PENDIENTE_MX
,SUM(MONTO_IMPONIBLE_MX) AS MONTO_IMPONIBLE_MX
,SUM(MONTO_NOIMPONIBLE_MX) AS MONTO_NOIMPONIBLE_MX
,SUM(MONTO_IMPUESTO_MX) AS MONTO_IMPUESTO_MX
,RECEP_COMPANIA
,RECEP_TIPO
,RECEP_DOC

from (
        select
           
          PASIVOS.RPKCO as DOC_COMPANIA
          ,PASIVOS.RPDCT as DOC_TIPO
          ,PASIVOS.RPDOC as DOC
          ,PASIVOs.RPSFX as DOC_LINEA
  
          ,PASIVOS.RPAN8 as PROVEEDOR
          ,PASIVOS.RPPYE as BENEFICIARIO
          ,max(PASIVOS.RPMCU) over (partition by PASIVOS.RPKCO, PASIVOS.RPDCT, PASIVOS.RPDOC) as UN
          
          ,NVL(TRIM(PASIVOS.RPVINV), ' ') as FACTURA
          ,case when PASIVOS.RPDIVJ <> 0 then TO_DATE(1900000 + PASIVOS.RPDIVJ,'YYYYDDD') end as FECHA_FACTURA
          ,CASE WHEN PASIVOS.RPDGJ <> 0 THEN TO_DATE(1900000 + PASIVOS.RPDGJ,'YYYYDDD') END AS FECHA_LM          
          
          ,PASIVOS.RPFY AS ANIO
          
          ,PASIVOS.RPAG/100 as MONTO_TOTAL_MX
          ,PASIVOS.RPAAP/100 as MONTO_PENDIENTE_MX
          ,PASIVOS.RPATXA/100 as MONTO_IMPONIBLE_MX
          ,PASIVOS.RPATXN/100 as MONTO_NOIMPONIBLE_MX
          ,PASIVOS.RPSTAM/100 as MONTO_IMPUESTO_MX
          
          ,case 
            when PASIVOS.RPDCT = 'PV'  then inventory.recep_compania
            else PASIVOS.RPKCO
          end RECEP_COMPANIA
          
          ,CASE 
            when PASIVOS.RPDCT = 'PV' THEN inventory.recep_tipo
            else PASIVOS.RPDCT
          END RECEP_TIPO
          
          ,case 
            when PASIVOS.RPDCT = 'PV' then inventory.recep_doc
            else PASIVOS.RPDOC
          END RECEP_doc        


        from PRODDTA.F0411 PASIVOS
        
        left outer join (
                            select
                              RECEP.PRKCO AS RECEP_COMPANIA
                              ,RECEP.PRDCT AS RECEP_TIPO
                              ,RECEP.PRDOC AS RECEP_DOC
                              ,COTEJO.PRKCO AS COTEJO_COMPANIA
                              ,COTEJO.PRDCT AS COTEJO_TIPO
                              ,COTEJO.PRDOC AS COTEJO_DOC        
                            FROM PRODDTA.F43121 RECEP
                            LEFT OUTER JOIN PRODDTA.F43121 COTEJO
                                         ON COTEJO.PRDOCO = RECEP.PRDOCO --<- OC
                                        AND COTEJO.PRDCTO = RECEP.PRDCTO --<- OC_TIPO
                                        AND COTEJO.PRKCOO = RECEP.PRKCOO --<- OC_COMPANIA
                                        AND COTEJO.PRSFXO = RECEP.PRSFXO --<- OC_SUFIX
                                        AND COTEJO.PRLNID = RECEP.PRLNID --<- OC_LINEA
                                        AND COTEJO.PRNLIN = RECEP.PRNLIN --<- TRANS_NUM
                                        AND COTEJO.PRMATC = 2
                            
                            where 1=1
                            and RECEP.PRMATC = 1
                            GROUP BY
                              RECEP.PRKCO
                              ,RECEP.PRDCT
                              ,RECEP.PRDOC
                              ,COTEJO.PRKCO
                              ,COTEJO.PRDCT
                              ,COTEJO.PRDOC      
      
                        ) INVENTORY
                     ON INVENTORY.COTEJO_COMPANIA = PASIVOS.RPKCO
                    AND INVENTORY.COTEJO_TIPO = PASIVOS.RPDCT
                    AND INVENTORY.COTEJO_DOC = PASIVOS.RPDOC          
        
        where 1=1
        and PASIVOS.RPDCTA <> 'PE'  --<- Quitamos los anulados ( registros marcados como anulados )
        AND PASIVOS.RPAG > 0        --<- Quitamos los anulados ( saldos mayores a 0 )  
   )
where 1=1

GROUP BY
DOC_COMPANIA
,DOC_TIPO
,DOC
,PROVEEDOR
,TRIM(UN)
,FACTURA
,FECHA_LM
,RECEP_COMPANIA
,RECEP_TIPO
,RECEP_DOC

order by 1,2,3;
