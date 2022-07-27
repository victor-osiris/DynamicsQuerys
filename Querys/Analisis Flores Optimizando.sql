USE BLA01;
GO

DECLARE @Desde AS DATE;
DECLARE @Hasta AS DATE;

DECLARE @Desde_PA AS DATE;
DECLARE @Hasta_PA AS DATE;

SET @Desde = '2022-03-01';
SET @Hasta = '2022-03-31';

SET @Desde_PA = DATEADD(YEAR, -1, @Desde);
SET @Hasta_PA = DATEADD(YEAR, -1, @Hasta);


SELECT 'Arreglos' Tipo,
       RTRIM(H.SOPNUMBE) [Numero de Ventas],
       CASE
           WHEN D.CMPNTSEQ = 0 THEN
               'NO'
           ELSE
               'SI'
       END KIT,
       H.DOCID Tipo,
       H.DOCDATE [Fecha del documento],
       YEAR(H.DOCDATE) Año,
       RTRIM(H.CUSTNMBR) [Numero de cliente],
       RTRIM(H.CUSTNAME) [Nombre de cliente],
       RTRIM(D.ITEMNMBR) [Numero de articulo],
       RTRIM(I.ITMCLSCD) Clase,
       RTRIM(D.ITEMDESC) [Descripcion articulo],
       D.QUANTITY Cantidad,
       D.UNITPRCE Precio,
       (D.MRKDNAMT * -1) Descuento,
       (D.QUANTITY * D.UNITPRCE) - D.MRKDNAMT Total,
       CASE LEFT(H.SOPNUMBE, 4)
           WHEN 'FB02' THEN
               'B2 - Lincoln'
           WHEN 'FB03' THEN
               'B3 - Ozama'
           WHEN 'FB04' THEN
               'B4 - Herrera'
           WHEN 'FB05' THEN
               'B5 - Santiago'
           WHEN 'FB06' THEN
               'B6 - AILA'
           WHEN 'FB07' THEN
               'B7 - Charles de Gaulle'
           WHEN 'FB09' THEN
               'B9 - Luperon'
           ELSE
               ''
       END Sucursal,
       D.SLPRSNID VENDEDOR,
       RTRIM(C.ACTNUMST) CUENTA,
       RTRIM(NC.ACTDESCR) DESC_CUENTA
FROM dbo.SOP30200 H
    LEFT OUTER JOIN dbo.SOP30300 D
        ON H.SOPTYPE = D.SOPTYPE
           AND H.SOPNUMBE = D.SOPNUMBE
    LEFT OUTER JOIN dbo.IV00101 I
        ON I.ITEMNMBR = D.ITEMNMBR
    LEFT OUTER JOIN dbo.GL00105 C
        ON D.SLSINDX = C.ACTINDX
    LEFT OUTER JOIN dbo.GL00100 NC
        ON NC.ACTINDX = C.ACTINDX
WHERE 
(
          H.DOCDATE
      BETWEEN @Desde AND @Hasta
          AND H.SOPTYPE = 3
          AND H.VOIDSTTS = 0
          AND D.CMPNTSEQ = 0
          AND RTRIM(I.ITMCLSCD) = 'FLORES'
      )
       AND ((D.QUANTITY * D.UNITPRCE) - D.MRKDNAMT) > 0
	   AND D.ITEMDESC NOT LIKE '%UNGR%' 
	   AND D.ITEMDESC NOT LIKE '%INDIV%' 
	   AND D.ITEMDESC NOT LIKE '%GRADE%' 
	   AND D.ITEMDESC NOT LIKE '%DIF%'
UNION ALL
SELECT 'Adicionales' Tipo,
       x.*
FROM
(
    VALUES
        ('%UNGR%', 1),
        ('%INDIV%', 2),
        ('%GRADE%', 3),
        ('%DIF%', 4)
) AS v (pattern, row_count)
    CROSS APPLY
( -- your query
    SELECT DISTINCT 
           RTRIM(H.SOPNUMBE) [Numero de Ventas],
           CASE
               WHEN D.CMPNTSEQ = 0 THEN
                   'NO'
               ELSE
                   'SI'
           END KIT,
           H.DOCID Tipo,
           H.DOCDATE [Fecha del documento],
           YEAR(H.DOCDATE) Año,
           RTRIM(H.CUSTNMBR) [Numero de cliente],
           RTRIM(H.CUSTNAME) [Nombre de cliente],
           RTRIM(D.ITEMNMBR) [Numero de articulo],
           RTRIM(I.ITMCLSCD) Clase,
           RTRIM(D.ITEMDESC) [Descripcion articulo],
           D.QUANTITY Cantidad,
           D.UNITPRCE Precio,
           (D.MRKDNAMT * -1) Descuento,
           (D.QUANTITY * D.UNITPRCE) - D.MRKDNAMT Total,
           CASE LEFT(H.SOPNUMBE, 4)
               WHEN 'FB02' THEN
                   'B2 - Lincoln'
               WHEN 'FB03' THEN
                   'B3 - Ozama'
               WHEN 'FB04' THEN
                   'B4 - Herrera'
               WHEN 'FB05' THEN
                   'B5 - Santiago'
               WHEN 'FB06' THEN
                   'B6 - AILA'
               WHEN 'FB07' THEN
                   'B7 - Charles de Gaulle'
               WHEN 'FB09' THEN
                   'B9 - Luperon'
               ELSE
                   ''
           END Sucursal,
           D.SLPRSNID VENDEDOR,
           RTRIM(C.ACTNUMST) CUENTA,
           RTRIM(NC.ACTDESCR) DESC_CUENTA
    FROM dbo.SOP30200 H
        LEFT OUTER JOIN dbo.SOP30300 D
            ON H.SOPTYPE = D.SOPTYPE
               AND H.SOPNUMBE = D.SOPNUMBE
        LEFT OUTER JOIN dbo.IV00101 I
            ON I.ITEMNMBR = D.ITEMNMBR
        LEFT OUTER JOIN dbo.GL00105 C
            ON D.SLSINDX = C.ACTINDX
        LEFT OUTER JOIN dbo.GL00100 NC
            ON NC.ACTINDX = C.ACTINDX
    WHERE (
              H.DOCDATE
          BETWEEN @Desde AND @Hasta
              AND H.SOPTYPE = 3
              AND H.VOIDSTTS = 0
              AND D.CMPNTSEQ = 0
              AND RTRIM(I.ITMCLSCD) = 'FLORES'
          )
          AND D.ITEMDESC LIKE v.pattern
) AS x
UNION ALL
SELECT --DISTINCT
    'Arreglos' Tipo,
    RTRIM(H.SOPNUMBE) [Numero de Ventas],
    CASE
        WHEN D.CMPNTSEQ = 0 THEN
            'NO'
        ELSE
            'SI'
    END KIT,
    H.DOCID Tipo,
    H.DOCDATE [Fecha del documento],
    YEAR(H.DOCDATE) Año,
    RTRIM(H.CUSTNMBR) [Numero de cliente],
    RTRIM(H.CUSTNAME) [Nombre de cliente],
    RTRIM(D.ITEMNMBR) [Numero de articulo],
    RTRIM(I.ITMCLSCD) Clase,
    RTRIM(D.ITEMDESC) [Descripcion articulo],
    D.QUANTITY Cantidad,
    D.UNITPRCE Precio,
    (D.MRKDNAMT * -1) Descuento,
    (D.QUANTITY * D.UNITPRCE) - D.MRKDNAMT Total,
    CASE LEFT(H.SOPNUMBE, 4)
        WHEN 'FB02' THEN
            'B2 - Lincoln'
        WHEN 'FB03' THEN
            'B3 - Ozama'
        WHEN 'FB04' THEN
            'B4 - Herrera'
        WHEN 'FB05' THEN
            'B5 - Santiago'
        WHEN 'FB06' THEN
            'B6 - AILA'
        WHEN 'FB07' THEN
            'B7 - Charles de Gaulle'
        WHEN 'FB09' THEN
            'B9 - Luperon'
        ELSE
            ''
    END Sucursal,
    D.SLPRSNID VENDEDOR,
    RTRIM(C.ACTNUMST) CUENTA,
    RTRIM(NC.ACTDESCR) DESC_CUENTA
FROM dbo.SOP30200 H
    LEFT OUTER JOIN dbo.SOP30300 D
        ON H.SOPTYPE = D.SOPTYPE
           AND H.SOPNUMBE = D.SOPNUMBE
    LEFT OUTER JOIN dbo.IV00101 I
        ON I.ITEMNMBR = D.ITEMNMBR
    LEFT OUTER JOIN dbo.GL00105 C
        ON D.SLSINDX = C.ACTINDX
    LEFT OUTER JOIN dbo.GL00100 NC
        ON NC.ACTINDX = C.ACTINDX
WHERE (
          H.DOCDATE
      BETWEEN @Desde_PA AND @Hasta_PA
          AND H.SOPTYPE = 3
          AND H.VOIDSTTS = 0
          AND D.CMPNTSEQ = 0
          AND RTRIM(I.ITMCLSCD) = 'FLORES'
      )
      --AND H.SOPNUMBE = 'FB02000045098'
      AND ((D.QUANTITY * D.UNITPRCE) - D.MRKDNAMT) > 0
	  AND D.ITEMDESC NOT LIKE '%UNGR%' 
	  AND D.ITEMDESC NOT LIKE '%INDIV%' 
	  AND D.ITEMDESC NOT LIKE '%GRADE%' 
	  AND D.ITEMDESC NOT LIKE '%DIF%'     
UNION ALL
SELECT 'Adicionales' Tipo,
       x.*
FROM
(
    VALUES
        ('%UNGR%', 1),
        ('%INDIV%', 2),
        ('%GRADE%', 3),
        ('%DIF%', 4)
) AS v (pattern, row_count)
    CROSS APPLY
( -- your query
    SELECT DISTINCT
           RTRIM(H.SOPNUMBE) [Numero de Ventas],
           CASE
               WHEN D.CMPNTSEQ = 0 THEN
                   'NO'
               ELSE
                   'SI'
           END KIT,
           H.DOCID Tipo,
           H.DOCDATE [Fecha del documento],
           YEAR(H.DOCDATE) Año,
           RTRIM(H.CUSTNMBR) [Numero de cliente],
           RTRIM(H.CUSTNAME) [Nombre de cliente],
           RTRIM(D.ITEMNMBR) [Numero de articulo],
           RTRIM(I.ITMCLSCD) Clase,
           RTRIM(D.ITEMDESC) [Descripcion articulo],
           D.QUANTITY Cantidad,
           D.UNITPRCE Precio,
           (D.MRKDNAMT * -1) Descuento,
           (D.QUANTITY * D.UNITPRCE) - D.MRKDNAMT Total,
           CASE LEFT(H.SOPNUMBE, 4)
               WHEN 'FB02' THEN
                   'B2 - Lincoln'
               WHEN 'FB03' THEN
                   'B3 - Ozama'
               WHEN 'FB04' THEN
                   'B4 - Herrera'
               WHEN 'FB05' THEN
                   'B5 - Santiago'
               WHEN 'FB06' THEN
                   'B6 - AILA'
               WHEN 'FB07' THEN
                   'B7 - Charles de Gaulle'
               WHEN 'FB09' THEN
                   'B9 - Luperon'
               ELSE
                   ''
           END Sucursal,
           D.SLPRSNID VENDEDOR,
           RTRIM(C.ACTNUMST) CUENTA,
           RTRIM(NC.ACTDESCR) DESC_CUENTA
    FROM dbo.SOP30200 H
        LEFT OUTER JOIN dbo.SOP30300 D
            ON H.SOPTYPE = D.SOPTYPE
               AND H.SOPNUMBE = D.SOPNUMBE
        LEFT OUTER JOIN dbo.IV00101 I
            ON I.ITEMNMBR = D.ITEMNMBR
        LEFT OUTER JOIN dbo.GL00105 C
            ON D.SLSINDX = C.ACTINDX
        LEFT OUTER JOIN dbo.GL00100 NC
            ON NC.ACTINDX = C.ACTINDX
    WHERE (
              H.DOCDATE
          BETWEEN @Desde_PA AND @Hasta_PA          
                 AND H.SOPTYPE = 3
                 AND H.VOIDSTTS = 0
                 AND D.CMPNTSEQ = 0
                 AND RTRIM(I.ITMCLSCD) = 'FLORES'
          )
          AND D.ITEMDESC LIKE v.pattern
) AS x;