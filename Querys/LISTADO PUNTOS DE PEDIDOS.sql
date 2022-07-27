USE BLA01
GO

DECLARE @Desde AS DATE
DECLARE @Hasta AS DATE

--Fechas de Corte: Calcular ultimos tres meses en cada corrida.
SET @Desde = DATEADD(MONTH, -3, CAST(GETDATE() AS DATE))
SET @Hasta = DATEADD(DAY, -1, CAST(GETDATE() AS DATE))

SELECT  X.ARTICULO, RTRIM(I.ITEMDESC) NOMBRE_ARTICULO, X.PROMEDIO,X.TOPE,X.ALMACEN, ORDRPNTQTY CANTIDAD_PEDIDO_ACTUAL, ORDRUPTOLVL TOPE_ACTUAL, @Desde AS FechaInicial, @Hasta AS FechaFinal
FROM    IV00102 C
              LEFT OUTER JOIN dbo.IV00101 I ON I.ITEMNMBR=c.ITEMNMBR
        LEFT OUTER JOIN ( SELECT    RTRIM(P2.ITEMNMBR) ARTICULO ,
                                    ABS(AVG(P2.TRXQTY)) AS PROMEDIO ,
                                    ABS(AVG(P2.TRXQTY)) + ( ABS(AVG(P2.TRXQTY)) * 0.15 ) TOPE ,
                                    P2.TRXLOCTN ALMACEN
                          FROM      dbo.IV30200 P1
                                    LEFT OUTER JOIN dbo.IV30300 P2 ON P1.DOCNUMBR = P2.DOCNUMBR
                          WHERE     P1.IVDOCTYP = 1
                                    AND P2.ITEMNMBR IS NOT NULL
                                    AND P2.TRXLOCTN IS NOT NULL
                                    AND P1.DOCDATE BETWEEN @Desde AND @Hasta
                          GROUP BY  P2.ITEMNMBR ,
                                    P2.TRXLOCTN
                        ) X ON C.ITEMNMBR = X.ARTICULO
                               AND C.LOCNCODE = X.ALMACEN
WHERE   ORDRPNTQTY <> 0
        AND X.ARTICULO IS NOT NULL
ORDER BY X.ARTICULO



