USE [DEVELOPMENT]
GO


ALTER   PROCEDURE [dbo].[PROC_REPORTE_RECIBOS_TIPOS_CONTRATOS]
    (
      @PREFIJO VARCHAR(50) ,
      @FECHADESDE DATE ,
      @FECHAHASTA DATE
    )
AS
    SELECT  P3.PRAPAYNO ,
            rTRIM(P3.PRAPAYNMBR) AS 'Numero Pago Recibido' ,
            rTRIM(P3.PRANUM) AS 'Numero Prearreglo' ,
            rTRIM(P1.PRACONTRACT) AS 'Numero Contrato' ,
            rTRIM(P1.PRACUSTID) AS 'Codigo Cliente' ,
            rTRIM(P1.PRACUSTNAME) AS 'Nombre Cliente' ,
            P1.PRAPLANAMOUNT AS 'Monto Plan' ,
            P1.PRASTARTAMNT AS 'Monto Inicial' ,
            P2.PRAPAYTYPE AS 'Condición de Pago' ,
            P2.PRAESTDATE AS 'Fecha Cuotas' ,
            P2.PRAPAYDATE AS 'Día del Pago' ,
            P3.PRAPAYAMNT AS 'Cuota Pagada' ,
            ISNULL(PC.Descripcion, 'Planes Funerarios') AS Tipo_Contrato
    FROM    DEVELOPMENT.dbo.DYNPRE01_PRA_PAYMENTS P2
            RIGHT JOIN DYNPRE01_PRA_PAYAPPL P3 ON P3.PRANUM = P2.PRANUM
                                                  AND P3.PRAPAYNO = P2.PRAPAYNO
            INNER JOIN DEVELOPMENT.dbo.DYNPRE01_PRA_MASTER P1 ON P1.PRANUM = P2.PRANUM--incluir esta y traer datos de recibos partiendo de aqui.			
            LEFT OUTER JOIN ICON_PREFIJOS_CONTRATOS PC ON LEFT(P1.PRACONTRACT,
                                                              2) = PC.ID
    WHERE   CAST(P2.PRAPAYDATE AS DATE) BETWEEN @FECHADESDE
                                        AND     @FECHAHASTA
            AND ( ISNULL(PC.ID, 'PF') = @PREFIJO --convierto lo null a PF
                  OR @PREFIJO = '*'
                )

