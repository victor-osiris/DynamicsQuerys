USE BLA01
GO

SELECT  [N·mero OC] = OC.PONUMBER ,
        [Estado orden de compra] = CASE OC.POSTATUS
                                     WHEN 1 THEN 'Nuevo'
                                     WHEN 2 THEN 'Liberado'
                                     WHEN 3 THEN 'Cambiar Pedido'
                                     WHEN 4 THEN 'Recibido'
                                     WHEN 5 THEN 'Cerrado(a)'
                                     WHEN 6 THEN 'Cancelado'
                                   END ,
        [Tipo de OC] = CASE OC.POTYPE
                         WHEN 1 THEN 'Estandar'
                         WHEN 2 THEN 'Entrega directa'
                         WHEN 3 THEN 'Global'
                         WHEN 4 THEN 'Global de entrega directa'
                       END ,
        [Fecha del documento] = OC.DOCDATE ,
        [Subtotal pendiente] = OC.SUBTOTAL ,
        [Id. de proveedor] = RTRIM(OC.VENDORID) ,
        [Nombre proveedor] = RTRIM(OC.VENDNAME) ,
        [Suspensión] = 'No',
		[Id. Articulo] = IT.ITEMNMBR,
		[Descripcion de Articulo] = IT.ITEMDESC,
		[Almacen] = IT.LOCNCODE,
		[Tipo de Medida] = IT.UOFM,
		[Cantidad de la Orden] = IT.QTYORDER,
		[Cantidad Cancelada] = IT.QTYCANCE,
		[Precio Unitario] = IT.UNITCOST,
		[Costo Total] = IT.QTYORDER * IT.UNITCOST 
FROM    dbo.POP10100 OC LEFT OUTER JOIN POP10110 IT ON OC.PONUMBER = IT.PONUMBER





