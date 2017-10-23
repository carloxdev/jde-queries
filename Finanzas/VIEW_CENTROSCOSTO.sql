
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NUVPD"."VIEW_CENTROSCOSTO" ("CLAVE", "DESCRIPCION", "COMPANIA", "COMPANIA_DESC", "COMPANIA_AB_CLAVE", "COMPANIA_AB_DESC", "COMPANIA_RFC", "COMPANIA_DIRECCION", "TIPO", "TIPO_DESC", "ESTADO", "ESTADO_DESC", "PROYECTO", "PROYECTO_TIPO", "PROYECTO_DESC", "PROYECTO_ZONA", "ESTRUCTURA", "ESTRUCTURA_DESC", "CIUDAD_OLD") AS 
  select
        TRIM(CENTRO.MCMCU) as CLAVE
        ,TRIM(CENTRO.MCDL01 || CENTRO.MCDL02) as DESCRIPCION
        ,CENTRO.MCCO as COMPANIA
        ,COMPANIA.DESCRIPCION  as COMPANIA_DESC
        ,COMPANIA.AB_CLAVE as COMPANIA_AB_CLAVE
        ,COMPANIA.AB_DESC as COMPANIA_AB_DESC
        ,COMPANIA.RFC as COMPANIA_RFC
        ,COMPANIA.DIRECCION AS COMPANIA_DIRECCION
        ,CENTRO.MCSTYL as TIPO
        ,TRIM(TIPO.DRDL01 || TIPO.DRDL02) as TIPO_DESC
        ,NVL(TRIM(CENTRO.MCPECC),'-') AS ESTADO
        ,CASE
          when CENTRO.MCPECC = 'K' then 'BLOQUEAR PRESUPUESTO'
          when CENTRO.MCPECC = 'N' then 'DESHABILITADO'
          when CENTRO.MCPECC = 'P' then 'DEPURACION'
          else 'HABILITADO'
        end as ESTADO_DESC
        ,NVL(TRIM(CENTRO.MCRP01), '-' ) AS PROYECTO
        ,NVL(TRIM(PROYECTO.DRSPHD),'-') as PROYECTO_TIPO
        ,NVL(TRIM(PROYECTO.DRDL01),'-') AS PROYECTO_DESC 
        ,NVL(TRIM(PROYECTO.DRDL02),'-') AS PROYECTO_ZONA
                
        ,NVL(TRIM(CENTRO.MCRP50),'-') as ESTRUCTURA
        ,NVL(TRIM(ESTRUCTURA.DRDL01 || ESTRUCTURA.DRDL02),'-') as ESTRUCTURA_DESC
        
        ,NVL(TRIM(CENTRO.MCRP02), '-' ) AS CIUDAD_OLD
        
        from proddtA.F0006 CENTRO
        
        /* UDC que representa el TIPO de la UN
        ------------------------------------------------------------*/
        LEFT OUTER JOIN PRODCTL.F0005 TIPO
                     ON TIPO.DRSY = '00'    
                    AND TIPO.DRRT = 'MC'    
                    AND TRIM(TIPO.DRKY) = trim(CENTRO.MCSTYL)

        /* UDC que representa el PROYECTO de la UN
        ------------------------------------------------------------*/        
        LEFT OUTER JOIN PRODCTL.F0005 PROYECTO
                     ON PROYECTO.DRSY = '00'    
                    AND PROYECTO.DRRT = '01'    
                    AND TRIM(PROYECTO.DRKY) = trim(CENTRO.MCRP01)

        /* UDC que representa si es la estructura actual
        o es la anterior implementada por la consultoria
        ------------------------------------------------------------*/                              
        LEFT OUTER JOIN PRODCTL.F0005 ESTRUCTURA
                     ON ESTRUCTURA.DRSY = '00'    
                    AND ESTRUCTURA.DRRT = '50'    
                    AND TRIM(ESTRUCTURA.DRKY) = trim(CENTRO.MCRP50)

        ------------------------------------------------------------*/
        left outer join NUVPD.VIEW_EMPRESAS COMPANIA on 1=1
                    AND COMPANIA.NUMERO = CENTRO.MCCO

        WHERE 1=1

        order BY 
            CENTRO.MCCO,
            NVL(TRIM(CENTRO.MCRP01), '-' ),
            trim(CENTRO.MCMCU);
