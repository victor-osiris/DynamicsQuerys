USE DEVELOPMENT
GO


ALTER PROCEDURE Proc_Proveedores_Volumen 
	@empresa varchar(5), 
	@periodo1 DATE,
	@periodo2 DATE
AS 
IF @empresa = 'BLA01'
BEGIN
		SELECT [Id. de proveedor],
       [Nombre proveedor],
       SUM([Costo Total]) AS [Costo Total]
		FROM BLA01.dbo.View_Detalles_Ordenes_de_Compras
		WHERE [Fecha del documento] BETWEEN @periodo1 AND @periodo2
		GROUP BY [Id. de proveedor], [Nombre proveedor]
		ORDER BY [Costo Total] DESC
END
IF @empresa = 'PRE01'
BEGIN
		SELECT [Id. de proveedor],
       [Nombre proveedor],
       SUM([Costo Total]) AS [Costo Total]
		FROM PRE01.dbo.View_Detalles_Ordenes_de_Compras
		WHERE [Fecha del documento] BETWEEN @periodo1 AND @periodo2
		GROUP BY [Id. de proveedor], [Nombre proveedor]
		ORDER BY [Costo Total] DESC
END
IF @empresa = 'PR01'
BEGIN
		SELECT [Id. de proveedor],
       [Nombre proveedor],
       SUM([Costo Total]) AS [Costo Total]
		FROM PR01.dbo.View_Detalles_Ordenes_de_Compras
		WHERE [Fecha del documento] BETWEEN @periodo1 AND @periodo2
		GROUP BY [Id. de proveedor], [Nombre proveedor]
		ORDER BY [Costo Total] DESC
END
IF @empresa = 'LEA01'
BEGIN
		SELECT [Id. de proveedor],
       [Nombre proveedor],
       SUM([Costo Total]) AS [Costo Total]
		FROM LEA01.dbo.View_Detalles_Ordenes_de_Compras
		WHERE [Fecha del documento] BETWEEN @periodo1 AND @periodo2
		GROUP BY [Id. de proveedor], [Nombre proveedor]
		ORDER BY [Costo Total] DESC
END
IF @empresa = 'FUN01'
BEGIN
		SELECT [Id. de proveedor],
       [Nombre proveedor],
       SUM([Costo Total]) AS [Costo Total]
		FROM FUN01.dbo.View_Detalles_Ordenes_de_Compras
		WHERE [Fecha del documento] BETWEEN @periodo1 AND @periodo2
		GROUP BY [Id. de proveedor], [Nombre proveedor]
		ORDER BY [Costo Total] DESC
END
GO