
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_CCOMPARATIVO" ("COT_COMPANIA", "COT_TIPO", "COT", "COT_SUFIX", "COT_LINEA", "COT_FECHA", "PROVEEDOR", "PROVEEDOR_DESC ", "FECHA_REQ_RESPUESTA", "FECHA_RESPUESTA", "FECHA_PROMETIDA", "ESTADO_RESPUESTA", "UNIDADES", "PRECIO_UNITARIO", "MONEDA", "FECHA_VENCIMIENTO") AS 
  select
          SSF.P0KCOO as COT_COMPANIA
          ,SSF.P0DCTO as COT_TIPO
          ,SSF.P0DOCO as COT
          ,SSF.P0SFXO as COT_SUFIX
          ,BKP.P1LNID/1000 as COT_LINEA
          ,case when SSF.P0TRDJ <> 0 then TO_DATE(1900000 + SSF.P0TRDJ,'yyyyddd') end as COT_FECHA
          ,SSF.P0AN8    as PROVEEDOR
          ,NVL(TRIM(PROV.ABALPH),'--') as PROVEEDOR_DESC 

          ,case when SSF.P0RQQJ <> 0 then TO_DATE(1900000 + SSF.P0RQQJ,'yyyyddd') end as FECHA_REQ_RESPUESTA
          ,case when SSF.P0QRDJ <> 0 then TO_DATE(1900000 + SSF.P0QRDJ,'yyyyddd') end as FECHA_RESPUESTA
          ,case when SSF.P0PDDJ <> 0 then TO_DATE(1900000 + SSF.P0PDDJ,'yyyyddd') end as FECHA_PROMETIDA

          ,case when P0RSPO = 1 then 'PRECIOS ENTREGADOS' else 'FALTA RESPUESTA' END as ESTADO_RESPUESTA
          
          ,BKP.P1UORG/10000   as UNIDADES
          ,BKP.P1PRRC/10000   as PRECIO_UNITARIO
          ,BKP.P1CRCD    as MONEDA
          
          ,case when BKP.P1CNDJ <> 0 then TO_DATE(1900000 + BKP.P1CNDJ,'yyyyddd') end as FECHA_VENCIMIENTO          

          from PRODDTA.F4330 SSF

          /*   PROVEEDORES                   
          --------------------------------------------------------------------------------*/
          left outer join PRODDTA.F0101 PROV
                     ON PROV.ABAN8 = SSF.P0AN8
                     
          /*   Quantity Breaks File
          --------------------------------------------------------------------------------*/
          left outer join PRODDTA.F4331 BKP on 1=1
                    and BKP.P1KCOO = SSF.P0KCOO --/ Cot Compania
                    and BKP.P1DCTO = SSF.P0DCTO --/ Cot Tipo
                    and BKP.P1DOCO = SSF.P0DOCO --/ Cot Numero
                    and BKP.P1SFXO = SSF.P0SFXO --/ Cot Sufix     
                    AND BKP.P1AN8 = SSF.P0AN8  --/ Proveedor   
                    
          ORDER BY SSF.P0KCOO, SSF.P0DCTO, SSF.P0DOCO, BKP.P1LNID/1000;
