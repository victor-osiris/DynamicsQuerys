USE [DEVELOPMENT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_REPORTE_RECIBOS_TIPOS_CONTRATOS]    Script Date: 2/7/2021 8:19:44 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER  PROCEDURE [dbo].[PROC_REPORTE_RECIBOS_TIPOS_CONTRATOS]
    (
      @PREFIJO VARCHAR(50) ,
      @FECHADESDE DATE ,
      @FECHAHASTA DATE
    )
AS --DECLARE @VALOR CHAR(50)
    --SET @VALOR = 'PF'
    --IF @PREFIJO = @VALOR
    SELECT  LTRIM(P3.PRAPAYNMBR) AS 'Numero Pago Recibido' ,
            LTRIM(P3.PRANUM) AS 'Numero Prearreglo' ,
            LTRIM(P1.PRACONTRACT) AS 'Numero Contrato' ,
            LTRIM(P1.PRACUSTID) AS 'Codigo Cliente' ,
            LTRIM(P1.PRACUSTNAME) AS 'Nombre Cliente' ,
			--P3.PRAPAYNO AS 'Pagos',
            P1.PRAPLANAMOUNT AS 'Monto Plan' ,
            P1.PRASTARTAMNT AS 'Monto Inicial' ,
			P2.PRAPAYTYPE AS 'Condición de Pago',
            --P1.PRAPLANREMAIN AS 'Monto Pendiente' ,
            --( P1.PRAPLANREMAIN - P1.PRASTARTAMNT ) AS 'Monto Pagado' ,
            P2.PRAESTDATE AS 'Fecha Cuotas' ,
            --P2.PRAESTAMNT AS 'Cuotas' ,
            P2.PRAPAYDATE AS 'Día del Pago' ,
            P3.PRAPAYAMNT AS 'Cuota Pagada' ,
            --ISNULL(PC.ID, 'PF') AS ID_Tipo_Contrato,
            ISNULL(PC.Descripcion, 'Planes Funerarios') AS Tipo_Contrato
    FROM    DEVELOPMENT.dbo.DYNPRE01_PRA_MASTER P1
            RIGHT OUTER JOIN DYNPRE01_PRA_PAYAPPL P3 ON P3.PRANUM = P1.PRANUM--incluir esta y traer datos de recibos partiendo de aqui.
			LEFT OUTER JOIN DEVELOPMENT.dbo.DYNPRE01_PRA_PAYMENTS P2 ON P3.PRANUM = P2.PRANUM
            --LEFT OUTER JOIN PRE01.dbo.RM20101 R1 ON P2.PRAPAYNMBR = R1.DOCNUMBR
            LEFT OUTER JOIN ICON_PREFIJOS_CONTRATOS PC ON LEFT(P1.PRACONTRACT, 2) = PC.ID
    WHERE   CAST(P2.PRAPAYDATE AS DATE) BETWEEN @FECHADESDE AND @FECHAHASTA
            AND ( ISNULL(PC.ID, 'PF') = @PREFIJO --convierto lo null a PF
                  OR @PREFIJO = '*'
                )

		--		  AND P1.PRACONTRACT NOT LIKE 'CO%'
        --        AND P1.PRACONTRACT NOT LIKE 'BP%'
        --        AND P1.PRACONTRACT NOT LIKE 'CR%'
        --        AND P1.PRACONTRACT NOT LIKE 'FD%'
        --        AND P1.PRACONTRACT NOT LIKE 'FL%'
        --        AND P1.PRACONTRACT NOT LIKE 'NC%'
        --        AND P1.PRACONTRACT NOT LIKE 'NO%'
        --        AND P1.PRACONTRACT NOT LIKE 'PC%'
          
    --ELSE
    --    BEGIN
    --        SELECT  LTRIM(P2.PRAPAYNMBR) AS 'Numero Pago Recibido' ,
    --                LTRIM(P2.PRANUM) AS 'Numero Prearreglo' ,
    --                LTRIM(P1.PRACONTRACT) AS 'Numero Contrato' ,
    --                LTRIM(P1.PRACUSTID) AS 'Codigo Cliente' ,
    --                LTRIM(P1.PRACUSTNAME) AS 'Nombre Cliente' ,
    --                P1.PRAPLANAMOUNT AS 'Monto Plan' ,
    --                P1.PRASTARTAMNT AS 'Monto Inicial' ,
    --                P1.PRAPLANREMAIN AS 'Monto Pendiente' ,
    --                ( P1.PRAPLANREMAIN - P1.PRASTARTAMNT ) AS 'Monto Pagado' ,
    --                P2.PRAESTDATE AS 'Fecha Cuotas' ,
    --                P2.PRAESTAMNT AS 'Cuotas' ,
    --                P2.PRAPAYDATE AS 'Día del Pago' ,
    --                P2.PRAPAYAMNT AS 'Cuota Pagada'
    --        FROM    DEVELOPMENT.dbo.DYNPRE01_PRA_MASTER P1
    --                LEFT OUTER JOIN DEVELOPMENT.dbo.DYNPRE01_PRA_PAYMENTS P2 ON P1.PRANUM = P2.PRANUM
    --                LEFT OUTER JOIN PRE01.dbo.RM20101 R1 ON P2.PRAPAYNMBR = R1.DOCNUMBR
    --        WHERE   P1.PRACONTRACT LIKE @PREFIJO
    --                AND P2.PRAPAYDATE BETWEEN @FECHADESDE AND @FECHAHASTA
    --    END
