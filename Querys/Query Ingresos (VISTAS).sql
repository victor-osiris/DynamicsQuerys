USE [BLA01]
GO

/****** Object:  View [dbo].[View_Detalle_Aplicacion_Ingresos]    Script Date: 13/5/2022 2:26:19 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[View_Detalle_Aplicacion_Ingresos]
AS
SELECT  T.CUSTNMBR [COD. CLIENTE] ,
        CM.CUSTNAME [NOMBRE CLIENTE] ,
        T.DOCDATE [FECHA DOCUMENTO] ,
        T.GLPOSTDT [FECHA CONTABILIZACION] ,
        CASE T.RMDTYPAL
          WHEN 7 THEN 'NOTA DE CREDITO'
          WHEN 8 THEN 'DEVOLUCION'
          WHEN 9 THEN 'PAGO'
        END AS [TIPO DOCUMENTO] ,
        T.BACHNUMB [LOTE DE PAGO] ,
        T.docTypeNum [TIPO Y NUMERO DOCUMENTO] ,
        T.DOCNUMBR [NUMERO DOCUMENTO] ,
        T.ORTRXAMT [MONTO TRANSACCION ORIGINAL] ,
        A.APPTOAMT [MONTO APLICADO] ,
        A.debitType [NOMBRE TIPO DOCUMENTO A APLICAR] ,
        A.APTODCNM [NUMERO DOCUMENTO A APLICAR] ,
		A.PropertyValue [NCF],
        A.APTODCDT [FECHA DOCUMENTO A APLICAR] ,
        A.ApplyToGLPostDate [FECHA CONTABILIZACION A APLICAR] ,
        A.DATE1 [FECHA DOCUMENTO APLICADO] ,
        A.GLPOSTDT [FECHA CONTABILIZACION APLICADA] ,
        D.ORTRXAMT [TOTAL APLICAR A DOCUMENTO] ,
        D.DINVPDOF [FECHA DE PAGO APLICADO]
FROM    ( SELECT    CUSTNMBR ,
                    DOCDATE ,
                    GLPOSTDT ,
                    RMDTYPAL ,
                    CASE RMDTYPAL
                      WHEN 7 THEN 'Nota de Credito'
                      WHEN 8 THEN 'Devuelto'
                      WHEN 9
                      THEN CASE CSHRCTYP
                             WHEN 0
                             THEN 'Pago - Cheque ' + CASE CHEKNMBR
                                                         WHEN '' THEN ''
                                                         ELSE '#' + CHEKNMBR
                                                       END
                             WHEN 1 THEN 'Pago - Efectivo'
                             WHEN 2 THEN 'Pago - Tarjeta de Credito'
                           END
                    END AS docTypeNum ,
                    DOCNUMBR ,
                    ORTRXAMT ,
                    BACHNUMB
          FROM      RM20101
          WHERE     ( RMDTYPAL > 6 )
                    AND ( VOIDSTTS = 0 )
          UNION
          SELECT    CUSTNMBR ,
                    DOCDATE ,
                    GLPOSTDT ,
                    RMDTYPAL ,
                    CASE RMDTYPAL
                      WHEN 7 THEN 'Nota de Credito'
                      WHEN 8 THEN 'Devuelto'
                      WHEN 9
                      THEN CASE CSHRCTYP
                             WHEN 0
                             THEN 'Pago - Cheque ' + CASE CHEKNMBR
                                                         WHEN '' THEN ''
                                                         ELSE '#' + CHEKNMBR
                                                       END
                             WHEN 1 THEN 'Pago - Efectivo'
                             WHEN 2 THEN 'Pago - Tarjeta de Credito'
                           END
                    END AS docTypeNum ,
                    DOCNUMBR ,
                    ORTRXAMT ,
                    BACHNUMB
          FROM      RM30101
          WHERE     ( RMDTYPAL > 6 )
                    AND ( VOIDSTTS = 0 )
        ) T
        INNER JOIN RM00101 CM ON T.CUSTNMBR = CM.CUSTNMBR
        INNER JOIN ( SELECT tO1.CUSTNMBR ,
                            APTODCTY ,
                            APTODCNM ,
                            APFRDCTY ,
                            APFRDCNM ,
                            CASE APTODCTY
                              WHEN 1 THEN 'Venta / Factura'
                              WHEN 2 THEN 'Pago Programado'
                              WHEN 3 THEN 'Nota de Debito'
                              WHEN 4 THEN 'Cargo Financiero'
                              WHEN 5 THEN 'Reparacion de Servicios'
                              WHEN 6 THEN 'Garantia'
                            END AS debitType ,
                            APPTOAMT ,
                            ApplyToGLPostDate ,
                            APTODCDT ,
                            tO2.DATE1 ,
                            tO2.GLPOSTDT,
							tH4.PropertyValue
                     FROM   RM20201 tO2
                            INNER JOIN RM20101 tO1 ON tO2.APTODCTY = tO1.RMDTYPAL
                                                      AND tO2.APTODCNM = tO1.DOCNUMBR
													  LEFT OUTER JOIN SY90000 tH4 ON tO2.APTODCNM = tH4.ObjectID WHERE PropertyName = 'NCF'
                     UNION
                     SELECT tH1.CUSTNMBR ,
                            APTODCTY ,
                            APTODCNM ,
                            APFRDCTY ,
                            APFRDCNM ,
                            CASE APTODCTY
                              WHEN 1 THEN 'Venta / Factura'
                              WHEN 2 THEN 'Pago Programado'
                              WHEN 3 THEN 'Nota de Debito'
                              WHEN 4 THEN 'Cargo Financiero'
                              WHEN 5 THEN 'Reparacion de Servicios'
                              WHEN 6 THEN 'Garantia'
                            END AS debitType ,
                            APPTOAMT ,
                            ApplyToGLPostDate ,
                            APTODCDT ,
                            tH2.DATE1 ,
                            tH2.GLPOSTDT,
							tH3.PropertyValue
                     FROM   RM30201 tH2
                            INNER JOIN RM30101 tH1 ON tH2.APTODCTY = tH1.RMDTYPAL
                                                      AND tH2.APTODCNM = tH1.DOCNUMBR
													  LEFT OUTER JOIN SY90000 tH3 ON tH2.APTODCNM = tH3.ObjectID WHERE PropertyName = 'NCF'
                   ) A ON A.APFRDCTY = T.RMDTYPAL
                          AND A.APFRDCNM = T.DOCNUMBR
        INNER JOIN ( SELECT RMDTYPAL ,
                            DOCNUMBR ,
                            ORTRXAMT ,
                            DINVPDOF 
                     FROM   RM20101
                     UNION
                     SELECT RMDTYPAL ,
                            DOCNUMBR ,
                            ORTRXAMT ,
                            DINVPDOF 
                     FROM   RM30101
                   ) D ON A.APTODCTY = D.RMDTYPAL
                          AND A.APTODCNM = D.DOCNUMBR
		

GO


