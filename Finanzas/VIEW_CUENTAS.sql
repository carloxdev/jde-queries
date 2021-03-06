
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_CUENTAS" ("ID", "DESCRIPCION", "COMPANIA", "UN", "UN_DESC", "UN_PROYECTO", "UN_PROYECTO_DESC", "UN_PROYECTO_ZONA", "UN_PROYECTO_TIPO", "UN_PROYECTO_ESTADO", "OBJETO", "AUXILIAR", "NIVEL", "ESTADO", "ESTADO_DESC", "MONEDA", "TIPO", "TIPO_DESC", "CLASE", "CLASE_DESC", "FLUJO", "FLUJO_DESC", "CLASE_PORF", "CLASE_PORF_DESC") AS 
  SELECT CUENTA.GMAID AS ID,
          TRIM (CUENTA.GMDL01) AS DESCRIPCION,
          CUENTA.GMCO AS COMPANIA,
          TRIM (CUENTA.GMMCU) AS UN,
          TRIM (CENTRO.MCDL01) AS UN_DESC,
          NVL (TRIM (CENTRO.MCRP01), '-') AS UN_PROYECTO,
          NVL (TRIM (PROYECTO.DRDL01), '-') AS UN_PROYECTO_DESC,
          NVL (TRIM (PROYECTO.DRDL02), '-') AS UN_PROYECTO_ZONA,
          NVL (TRIM (PROYECTO.DRSPHD), '-') AS UN_PROYECTO_TIPO,
          NVL (TRIM (PROYECTO.DRHRDC), '-') AS UN_PROYECTO_ESTADO,
          TRIM (CUENTA.GMOBJ) AS OBJETO,
          NVL (TRIM (CUENTA.GMSUB), '-') AS AUXILIAR,
          CUENTA.GMLDA AS NIVEL,
          CUENTA.GMPEC AS ESTADO,
          NVL (TRIM (ESTADO.DRDL01), 'Activa') AS ESTADO_DESC,
          CUENTA.GMCRCD as MONEDA,
          NVL (TRIM (CUENTA.GMR011), '-') AS TIPO,
          NVL (TRIM (TIPO.DRDL01), 'SIN TIPO') AS TIPO_DESC,
          NVL (TRIM (CUENTA.GMR010), '-') AS CLASE,
          NVL (TRIM (CLASE.DRDL01), 'SIN CLASIFICACION') AS CLASE_DESC,
          NVL (TRIM (CUENTA.GMR009), '-') as FLUJO,
          NVL (TRIM (FLUJO.DRDL01), 'SIN FLUJO') as FLUJO_DESC,
          NVL (TRIM (CUENTA.GMR008), '-') as CLASE_PORF,
          NVL (TRIM (CLASE_PORF.DRDL01), 'SIN CLASIFICACION') as CLASE_PORF_DESC          
     FROM proddta.F0901 CUENTA
          LEFT OUTER JOIN proddta.F0006 CENTRO
             ON CENTRO.MCMCU = CUENTA.GMMCU
          LEFT OUTER JOIN PRODCTL.F0005D ESTADO
             ON     ESTADO.DRSY = 'H00'
                AND ESTADO.DRRT = 'PE'
                AND TRIM (ESTADO.DRKY) = TRIM (CUENTA.GMPEC)
          LEFT OUTER JOIN PRODCTL.F0005 PROYECTO
             ON     PROYECTO.DRSY = '00'
                AND PROYECTO.DRRT = '01'
                AND TRIM (PROYECTO.DRKY) = TRIM (CENTRO.MCRP01)
          LEFT OUTER JOIN PRODCTL.F0005 TIPO
             ON     TIPO.DRSY = '09'
                AND TIPO.DRRT = '11'
                and TRIM (TIPO.DRKY) = TRIM (CUENTA.GMR011)
          LEFT OUTER JOIN PRODCTL.F0005 CLASE
             ON     CLASE.DRSY = '09'
                AND CLASE.DRRT = '10'
                AND TRIM (CLASE.DRKY) = TRIM (CUENTA.gmr010)
          LEFT OUTER JOIN PRODCTL.F0005 FLUJO
             ON     FLUJO.DRSY = '09'
                AND FLUJO.DRRT = '09'
                and TRIM (FLUJO.DRKY) = TRIM (CUENTA.GMR009)
          left outer join PRODCTL.F0005 CLASE_PORF
             ON     CLASE_PORF.DRSY = '09'
                and CLASE_PORF.DRRT = '08'
                AND TRIM (CLASE_PORF.DRKY) = TRIM (CUENTA.gmr008)
                
    where 1 = 1;
