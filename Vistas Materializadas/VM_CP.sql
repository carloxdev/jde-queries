
  CREATE MATERIALIZED VIEW "NUVPD"."VM_CP" ("BENEFICIARIO", "BENEFICIARIO_DESC", "BENEFICIARIO_CLASE5", "BENEFICIARIO_CLASE5_DESC", "UN", "UN_DESC", "UN_PROYECTO", "UN_PROYECTO_DESC", "UN_PROYECTO_ZONA", "UN_PROYECTO_TIPO", "UN_PROYECTO_ESTADO", "ANIO", "PERIODO", "COMPANIA", "DOC_TIPO", "DOC", "FACTURA", "FECHA_LM", "CUENTA", "CUENTA_NUMERO", "CUENTA_DESC", "CUENTA_CLASE_DESC", "CUENTA_TIPO", "CUENTA_FLUJO", "FPAGO", "MONEDA", "MONTO_PAGO_EX", "CUENTA_BANCO", "TOTAL", "ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO", "AGOSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 0 INITRANS 2 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND START WITH sysdate+0 NEXT SYSDATE +1
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE QUERY REWRITE
  AS SELECT PAGOS.BENEFICIARIO,
       NVL (SUPPLIER.DESCRIPCION, '-') AS BENEFICIARIO_DESC,
       NVL (SUPPLIER.CLASE5, '-') AS BENEFICIARIO_CLASE5,
       NVL (SUPPLIER.CLASE5_DESC, '-') AS BENEFICIARIO_CLASE5_DESC,
       PAGOS.UN,
       NVL (CENTRO.MCDL01, '-') AS UN_DESC,
       NVL (TRIM (CENTRO.MCRP01), '-') AS UN_PROYECTO,
       NVL (TRIM (PROYECTO.DRDL01), '-') AS UN_PROYECTO_DESC,
       NVL (TRIM (PROYECTO.DRDL02), '-') AS UN_PROYECTO_ZONA,
       NVL (TRIM (PROYECTO.DRSPHD), '-') AS UN_PROYECTO_TIPO,
       NVL (TRIM (PROYECTO.DRHRDC), '-') AS UN_PROYECTO_ESTADO,
       PAGOS.ANIO,
       PAGOS.PERIODO,
       PAGOS.COMPANIA,
       PAGOS.DOC_TIPO,
       PAGOS.DOC,
       PAGOS.FACTURA,
       PAGOS.FECHA_LM,
       PAGOS.CUENTA,
       PAGOS.CUENTA_NUMERO,
       PAGOS.CUENTA_DESC,
       PAGOS.CUENTA_CLASE_DESC,
       PAGOS.CUENTA_TIPO,
       PAGOS.CUENTA_FLUJO,
       PAGOS.FPAGO,
       PAGOS.MONEDA,
       PAGOS.MONTO_PAGO_EX,
       PAGOS.CUENTA_BANCO,
       PAGOS.TOTAL,
       PAGOS.ENERO,
       PAGOS.FEBRERO,
       PAGOS.MARZO,
       PAGOS.ABRIL,
       PAGOS.MAYO,
       PAGOS.JUNIO,
       PAGOS.JULIO,
       PAGOS.AGOSTO,
       PAGOS.SEPTIEMBRE,
       PAGOS.OCTUBRE,
       PAGOS.NOVIEMBRE,
       PAGOS.DICIEMBRE
  FROM (SELECT GASTOS.BENEFICIARIO,
               GASTOS.UN,
               GASTOS.ANIO,
               GASTOS.PERIODO,
               GASTOS.DOC_COMPANIA AS COMPANIA,
               GASTOS.DOC_TIPO,
               GASTOS.DOC,
               GASTOS.FACTURA,
               GASTOS.FECHA_LM,
               GASTOS.CUENTA,
               GASTOS.CUENTA_NUMERO,
               GASTOS.CUENTA_CLASE_DESC,
               GASTOS.CUENTA_TIPO,
               GASTOS.CUENTA_FLUJO,
               GASTOS.CUENTA_DESC,
               GASTOS.FPAGO,
               GASTOS.MONEDA,
               GASTOS.MONTO_PAGO_EX,
               GASTOS.CUENTA_BANCO,
               GASTOS.MONTO_DSTB AS TOTAL,
               CASE WHEN GASTOS.PERIODO = 1 THEN GASTOS.MONTO_DSTB ELSE 0 END
                  AS ENERO,
               CASE WHEN GASTOS.PERIODO = 2 THEN GASTOS.MONTO_DSTB ELSE 0 END
                  AS FEBRERO,
               CASE WHEN GASTOS.PERIODO = 3 THEN GASTOS.MONTO_DSTB ELSE 0 END
                  AS MARZO,
               CASE WHEN GASTOS.PERIODO = 4 THEN GASTOS.MONTO_DSTB ELSE 0 END
                  AS ABRIL,
               CASE WHEN GASTOS.PERIODO = 5 THEN GASTOS.MONTO_DSTB ELSE 0 END
                  AS MAYO,
               CASE WHEN GASTOS.PERIODO = 6 THEN GASTOS.MONTO_DSTB ELSE 0 END
                  AS JUNIO,
               CASE WHEN GASTOS.PERIODO = 7 THEN GASTOS.MONTO_DSTB ELSE 0 END
                  AS JULIO,
               CASE WHEN GASTOS.PERIODO = 8 THEN GASTOS.MONTO_DSTB ELSE 0 END
                  AS AGOSTO,
               CASE WHEN GASTOS.PERIODO = 9 THEN GASTOS.MONTO_DSTB ELSE 0 END
                  AS SEPTIEMBRE,
               CASE
                  WHEN GASTOS.PERIODO = 10 THEN GASTOS.MONTO_DSTB
                  ELSE 0
               END
                  AS OCTUBRE,
               CASE
                  WHEN GASTOS.PERIODO = 11 THEN GASTOS.MONTO_DSTB
                  ELSE 0
               END
                  AS NOVIEMBRE,
               CASE
                  WHEN GASTOS.PERIODO = 12 THEN GASTOS.MONTO_DSTB
                  ELSE 0
               END
                  AS DICIEMBRE
          FROM NUVPD.VIEW_E GASTOS
        UNION ALL
        SELECT NOMINAS.PROVEEDOR,
               NOMINAS.UN,
               NOMINAS.ANIO,
               NOMINAS.PERIODO,
               NOMINAS.DOC_COMPANIA AS COMPANIA,
               NOMINAS.DOC_TIPO,
               NOMINAS.DOC,
               NOMINAS.FACTURA,
               NOMINAS.FECHA_LM,
               NOMINAS.CUENTA,
               NOMINAS.CUENTA_NUMERO,
               NOMINAS.CUENTA_CLASE_DESC,
               NOMINAS.CUENTA_TIPO,
               NOMINAS.CUENTA_FLUJO,
               NOMINAS.CUENTA_DESC,
               NOMINAS.FECHA_LM AS FPAGO,
               CAST ('MXP' AS NVARCHAR2 (20)) AS MONEDA,
               0 AS MONTO_PAGO_EX,
               CAST ('----' AS NVARCHAR2 (20)) AS CUENTA_BANCO,
               NOMINAS.MONTO AS TOTAL,
               CASE WHEN NOMINAS.PERIODO = 1 THEN (NOMINAS.MONTO) ELSE 0 END
                  AS ENERO,
               CASE WHEN NOMINAS.PERIODO = 2 THEN (NOMINAS.MONTO) ELSE 0 END
                  AS FEBRERO,
               CASE WHEN NOMINAS.PERIODO = 3 THEN (NOMINAS.MONTO) ELSE 0 END
                  AS MARZO,
               CASE WHEN NOMINAS.PERIODO = 4 THEN (NOMINAS.MONTO) ELSE 0 END
                  AS ABRIL,
               CASE WHEN NOMINAS.PERIODO = 5 THEN (NOMINAS.MONTO) ELSE 0 END
                  AS MAYO,
               CASE WHEN NOMINAS.PERIODO = 6 THEN (NOMINAS.MONTO) ELSE 0 END
                  AS JUNIO,
               CASE WHEN NOMINAS.PERIODO = 7 THEN (NOMINAS.MONTO) ELSE 0 END
                  AS JULIO,
               CASE WHEN NOMINAS.PERIODO = 8 THEN (NOMINAS.MONTO) ELSE 0 END
                  AS AGOSTO,
               CASE WHEN NOMINAS.PERIODO = 9 THEN (NOMINAS.MONTO) ELSE 0 END
                  AS SEPTIEMBRE,
               CASE WHEN NOMINAS.PERIODO = 10 THEN (NOMINAS.MONTO) ELSE 0 END
                  AS OCTUBRE,
               CASE WHEN NOMINAS.PERIODO = 11 THEN (NOMINAS.MONTO) ELSE 0 END
                  AS NOVIEMBRE,
               CASE WHEN NOMINAS.PERIODO = 12 THEN (NOMINAS.MONTO) ELSE 0 END
                  AS DICIEMBRE
          FROM NUVPD.VIEW_ENOMINA NOMINAS
        UNION ALL
        SELECT SINAPLICAR.PROVEEDOR,
               SINAPLICAR.UN,
               SINAPLICAR.ANIO,
               SINAPLICAR.PERIODO,
               SINAPLICAR.DOC_COMPANIA AS COMPANIA,
               SINAPLICAR.DOC_TIPO,
               SINAPLICAR.DOC,
               SINAPLICAR.FACTURA,
               SINAPLICAR.FECHA_LM,
               SINAPLICAR.CUENTA,
               SINAPLICAR.CUENTA_NUMERO,
               SINAPLICAR.CUENTA_CLASE_DESC,
               SINAPLICAR.CUENTA_TIPO,
               SINAPLICAR.CUENTA_FLUJO,
               SINAPLICAR.CUENTA_DESC,
               SINAPLICAR.FECHA_LM AS FPAGO,
               CAST ('MXP' AS NVARCHAR2 (20)) AS MONEDA,
               0.0 AS MONTO_PAGO_EX,
               CAST ('----' AS NVARCHAR2 (20)) AS CUENTA_BANCO,
               SINAPLICAR.MONTO AS TOTAL,
               CASE
                  WHEN SINAPLICAR.PERIODO = 1 THEN (SINAPLICAR.MONTO)
                  ELSE 0
               END
                  AS ENERO,
               CASE
                  WHEN SINAPLICAR.PERIODO = 2 THEN (SINAPLICAR.MONTO)
                  ELSE 0
               END
                  AS FEBRERO,
               CASE
                  WHEN SINAPLICAR.PERIODO = 3 THEN (SINAPLICAR.MONTO)
                  ELSE 0
               END
                  AS MARZO,
               CASE
                  WHEN SINAPLICAR.PERIODO = 4 THEN (SINAPLICAR.MONTO)
                  ELSE 0
               END
                  AS ABRIL,
               CASE
                  WHEN SINAPLICAR.PERIODO = 5 THEN (SINAPLICAR.MONTO)
                  ELSE 0
               END
                  AS MAYO,
               CASE
                  WHEN SINAPLICAR.PERIODO = 6 THEN (SINAPLICAR.MONTO)
                  ELSE 0
               END
                  AS JUNIO,
               CASE
                  WHEN SINAPLICAR.PERIODO = 7 THEN (SINAPLICAR.MONTO)
                  ELSE 0
               END
                  AS JULIO,
               CASE
                  WHEN SINAPLICAR.PERIODO = 8 THEN (SINAPLICAR.MONTO)
                  ELSE 0
               END
                  AS AGOSTO,
               CASE
                  WHEN SINAPLICAR.PERIODO = 9 THEN (SINAPLICAR.MONTO)
                  ELSE 0
               END
                  AS SEPTIEMBRE,
               CASE
                  WHEN SINAPLICAR.PERIODO = 10 THEN (SINAPLICAR.MONTO)
                  ELSE 0
               END
                  AS OCTUBRE,
               CASE
                  WHEN SINAPLICAR.PERIODO = 11 THEN (SINAPLICAR.MONTO)
                  ELSE 0
               END
                  AS NOVIEMBRE,
               CASE
                  WHEN SINAPLICAR.PERIODO = 12 THEN (SINAPLICAR.MONTO)
                  ELSE 0
               END
                  AS DICIEMBRE
          FROM NUVPD.VIEW_ES SINAPLICAR) PAGOS
       LEFT OUTER JOIN PRODDTA.F0006 CENTRO
          ON TRIM (CENTRO.MCMCU) = PAGOS.UN
       LEFT OUTER JOIN PRODCTL.F0005 PROYECTO
          ON     PROYECTO.DRSY = '00'
             AND PROYECTO.DRRT = '01'
             AND TRIM (PROYECTO.DRKY) = TRIM (CENTRO.MCRP01)
       LEFT OUTER JOIN (SELECT ADDRESS.ABAN8 AS CLAVE,
                               NVL (ADDRESS.ABALPH, '-') AS DESCRIPCION,
                               ADDRESS.ABAT1 AS TIPO,
                               NVL (TRIM (TIPO.DRDL01), '-') AS TIPO_DESC,
                               NVL (TRIM (ADDRESS.ABCLASS05), '-') AS CLASE5,
                               NVL (TRIM (CLASE5.DRDL01), '-') AS CLASE5_DESC
                          FROM PRODDTA.F0101 ADDRESS
                               LEFT OUTER JOIN PRODCTL.F0005 TIPO
                                  ON TIPO.DRSY = '01' AND TIPO.DRRT = 'ST'
                                     AND TRIM (TIPO.DRKY) =
                                            TRIM (ADDRESS.ABAT1)
                               LEFT OUTER JOIN PRODCTL.F0005 CLASE5
                                  ON CLASE5.DRSY = '01'
                                     AND CLASE5.DRRT = 'CE'
                                     AND TRIM (CLASE5.DRKY) =
                                            TRIM (ADDRESS.ABCLASS05)
                         WHERE 1 = 1) SUPPLIER
          ON SUPPLIER.CLAVE = PAGOS.BENEFICIARIO;

   COMMENT ON MATERIALIZED VIEW "NUVPD"."VM_CP"  IS 'snapshot table for snapshot NUVPD.VM_CP';
