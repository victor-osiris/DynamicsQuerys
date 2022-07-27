USE BLA01
GO

ALTER PROCEDURE [dbo].[PROC_report_administracion_CXC]
   @ano1 INT,
   @ano2 INT,
	@cliente VARCHAR(MAX)
AS

--VARIABLES DEL CURSOR
DECLARE @numFact VARCHAR(MAX);
DECLARE @numRecibo VARCHAR(MAX);
DECLARE @montoFact FLOAT;
DECLARE @montoRecibo FLOAT;
DECLARE @retencion FLOAT;
DECLARE @balance FLOAT;


    DECLARE balance_cursor CURSOR FOR
    SELECT B.DOCAMNT AS [MONTO FACTURA],
           F.MONTO AS [MONTO RECIBO],
           B.SOPNUMBE AS [COD_FACTURA],
           F.RECIBO,
           F.RT
    FROM
    (
        SELECT SOPTYPE,
               SOPNUMBE,
               DOCAMNT,
               CUSTNMBR,
               DOCDATE
        FROM dbo.SOP10100
        WHERE VOIDSTTS <> 1
              AND SOPTYPE = 3
        UNION
        SELECT SOPTYPE,
               SOPNUMBE,
               DOCAMNT,
               CUSTNMBR,
               DOCDATE
        FROM dbo.SOP30200
        WHERE VOIDSTTS <> 1
              AND SOPTYPE = 3
        UNION
        SELECT RMDTYPAL AS SOPTYPE,
               DOCNUMBR AS SOPNUMBE,
               ORTRXAMT AS DOCAMNT,
               CUSTNMBR AS CUSTNMBR,
               DOCDATE AS DOCDATE
        FROM RM20101
        WHERE VOIDSTTS <> 1
              AND RMDTYPAL = 1
    ) B
        LEFT OUTER JOIN
        (
            SELECT SOPTYPE AS [TIPO FACTURA],
                   SOPNUMBE AS FACTURA,
                   DOCNUMBR AS RECIBO,
                   AMNTPAID AS MONTO,
                   0 AS RT,
                   '' AS CLIENTE,
                   DOCDATE AS FECHA
            FROM SOP10103
            WHERE SOPTYPE = 3
            UNION
            SELECT APFRDCTY AS [TIPO FACTURA],
                   APTODCNM AS FACTURA,
                   APFRDCNM AS RECIBO,
                   APPTOAMT AS MONTO,
                   0 AS RT,
                   CUSTNMBR AS CLIENTE,
                   DATE1 AS FECHA
            FROM RM20201
            WHERE APFRDCTY IN ( 9, 7, 3 )
                  AND CUSTNMBR = @cliente
                  AND YEAR(DATE1)
                  BETWEEN @ano1 AND @ano2
        ) F
            ON B.SOPNUMBE = F.FACTURA
    WHERE RTRIM(LTRIM(B.CUSTNMBR)) = @cliente
          OR RTRIM(LTRIM(F.CLIENTE)) = @cliente
             AND
             (
                 YEAR(B.DOCDATE)
          BETWEEN @ano1 AND @ano2
                 OR YEAR(F.FECHA)
          BETWEEN @ano1 AND @ano2
             )
    GROUP BY B.SOPNUMBE,
             B.DOCAMNT,
             F.MONTO,
             F.RECIBO,
             F.RT;
    OPEN balance_cursor;
    FETCH NEXT FROM balance_cursor
    INTO @montoFact,
         @montoRecibo,
         @numFact,
         @numRecibo,
         @retencion;

    CREATE TABLE #amortiz
    (
        balance FLOAT,
        montoFactura FLOAT,
        montoRecibo FLOAT,
        numeroFact VARCHAR(MAX),
        numeroRecibo VARCHAR(MAX),
        retencion FLOAT
    );



    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @balance =
        (
            SELECT SUM(montoFactura) FROM #amortiz WHERE numeroFact = @numFact
        );

        SET @balance = @balance - (@montoRecibo + @retencion);

        INSERT INTO #amortiz
        (
            balance,
            montoFactura,
            montoRecibo,
            numeroFact,
            numeroRecibo,
            retencion
        )
        VALUES
        (   @balance, @montoFact, @montoRecibo, -- montoRecibo - float
            @numFact,                           -- numeroFact - varchar(max)
            @numRecibo,                         -- numeroRecibo - varchar(max)
            @retencion);

        FETCH NEXT FROM balance_cursor
        INTO @montoFact,
             @montoRecibo,
             @numFact,
             @numRecibo,
             @retencion;


    END;


    SELECT DISTINCT
           RTRIM(LTRIM(B.CUSTNMBR)) AS ID_CLIENTE,
           B.CUSTNAME AS NOMBRE,
           B.SOPTYPE AS [TIPO FACTURA],
           ISNULL(LTRIM(B.SOPNUMBE), 'FB') AS [NUMERO FACTURA],
           B.DOCDATE AS [FECHA FACTURA],
           B.DOCAMNT AS [MONTO FACTURA],
           LTRIM(F.RECIBO) AS [RECIBO],
           F.MONTO AS [MONTO RECIBO],
           F.FECHA,
           F.RT AS RT,
           (
               SELECT ISNULL(Z.balance, 0)
               FROM #amortiz Z
               WHERE B.SOPNUMBE = Z.numeroFact
                     AND F.RECIBO = Z.numeroRecibo
           ) AS PENDIENTE
    FROM
    (
        SELECT SOPTYPE,
               CUSTNMBR,
               CUSTNAME,
               SOPNUMBE,
               DOCDATE,
               DOCAMNT
        FROM dbo.SOP10100
        WHERE VOIDSTTS <> 1
              AND SOPTYPE = 3
              AND YEAR(DOCDATE)
              BETWEEN @ano1 AND @ano2
              AND CUSTNMBR = @cliente
        UNION
        SELECT SOPTYPE,
               CUSTNMBR,
               CUSTNAME,
               SOPNUMBE,
               DOCDATE,
               DOCAMNT
        FROM dbo.SOP30200
        WHERE VOIDSTTS <> 1
              AND SOPTYPE = 3
              AND YEAR(DOCDATE)
              BETWEEN @ano1 AND @ano2
              AND CUSTNMBR = @cliente
        UNION
        SELECT 3 AS SOPTYPE,
               BZ.CUSTNMBR AS CUSTNMBR,
               CZ.CUSTNAME AS CUSTNAME,
               BZ.DOCNUMBR AS SOPNUMBE,
               BZ.DOCDATE AS DOCDATE,
               BZ.ORTRXAMT AS DOCAMNT
        FROM RM20101 BZ
            LEFT OUTER JOIN RM00101 CZ
                ON CZ.CUSTNMBR = BZ.CUSTNMBR
        WHERE BZ.VOIDSTTS <> 1
              AND BZ.RMDTYPAL in (1, 3)
              AND YEAR(DOCDATE)
              BETWEEN @ano1 AND @ano2
              AND BZ.CUSTNMBR = @cliente
    ) B
        LEFT OUTER JOIN
        (
            SELECT SOPTYPE AS [TIPO FACTURA],
                   SOPNUMBE AS FACTURA,
                   DOCNUMBR AS RECIBO,
                   AMNTPAID AS MONTO,
                   DOCDATE AS FECHA,
                   0 AS RT,
                   '' AS CLIENTE
            FROM SOP10103
            WHERE SOPTYPE = 3
                  AND YEAR(DOCDATE)
                  BETWEEN @ano1 AND @ano2
            UNION
            SELECT APFRDCTY AS [TIPO FACTURA],
                   APTODCNM AS FACTURA,
                   APFRDCNM AS RECIBO,
                   APPTOAMT AS MONTO,
                   DATE1 AS FECHA,
                   0 AS RT,
                   CUSTNMBR AS CLIENTE
            FROM RM20201
            WHERE APFRDCTY IN ( 9, 7 )
                  AND CUSTNMBR = @cliente
                  AND YEAR(DATE1)
                  BETWEEN @ano1 AND @ano2        
        ) F
            ON F.FACTURA = B.SOPNUMBE
    UNION
    SELECT DISTINCT
           R1.CUSTNMBR AS ID_CLIENTE,
           R2.CUSTNAME AS NOMBRE,
           R1.RMDTYPAL AS [TIPO FACTURA],
           '' AS [NUMERO FACTURA],
           '' AS [FECHA FACTURA],
           0 AS [MONTO FACTURA],
           R1.DOCNUMBR AS RECIBO,
           R1.ORTRXAMT AS [MONTO RECIBO],
           R1.DOCDATE AS FECHA,
           0 AS RT,
           R1.ORTRXAMT AS PENDIENTE
    FROM RM20101 R1
        LEFT OUTER JOIN dbo.RM00101 R2
            ON R2.CUSTNMBR = R1.CUSTNMBR
    WHERE RMDTYPAL IN ( 9, 7 )
          AND R1.CUSTNMBR = @cliente
          AND YEAR(DOCDATE)
          BETWEEN @ano1 AND @ano2
          AND R1.DOCNUMBR NOT IN
              (
                  SELECT DOCNUMBR
                  FROM SOP10103
                  WHERE SOPTYPE = 3
                        AND YEAR(DOCDATE)
                        BETWEEN @ano1 AND @ano2
					UNION
					SELECT APFRDCNM
                  FROM RM20201
                  WHERE APFRDCTY IN (3, 7, 9)
                        AND YEAR(DATE1)
                        BETWEEN @ano1 AND @ano2 AND CUSTNMBR = @cliente
              )

    CLOSE balance_cursor;
    DEALLOCATE balance_cursor;
    DROP TABLE #amortiz;

GO