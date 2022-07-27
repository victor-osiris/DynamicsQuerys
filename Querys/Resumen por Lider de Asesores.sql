USE DESARROLLOS
GO

DECLARE @lote VARCHAR(MAX)
DECLARE @asesor VARCHAR(MAX)

SET @lote = 'CAMPP20210602'
SET @asesor = 'JUANA PEREZ'

SELECT L.id AS Id_Lider, 
		D.Lider, 
		D.Asesor, 
		D.Fecha AS Fecha_Transacion, 
		D.Descripcion, 
		D.Servicio, 
		D.Cliente,
		D.MontoPA,
		D.Honorario,
		D.Adicionales,
		D.Aporte,
		D.Otro,
		D.Descuentos,
		D.Neto
FROM dbo.CAMPP_Lotes L
inner join dbo.CAMPP_Detalle D
ON L.id = D.loteID 
WHERE L.Lote = @lote AND D.Asesor = @asesor

--SELECT Lote FROM dbo.CAMPP_Lotes
--SELECT DISTINCT Lider, Asesor FROM dbo.CAMPP_Detalle

--SELECT * FROM dbo.CAMPP_Lotes
--SELECT * FROM dbo.CAMPP_Detalle


