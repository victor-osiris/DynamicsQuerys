USE BLA01;
GO

DECLARE @usuario AS VARCHAR(10);
SET @usuario = 'lmendez';
DECLARE @fecha AS VARCHAR(10);
SET @fecha = '2021';

SELECT SOPNUMBE AS [NUMERO FACTURA],
       USER2ENT AS [USUARIO],
       BCHSOURC AS TIPO,
       DOCDATE AS FECHA
FROM dbo.SOP10100
WHERE USER2ENT = @usuario
      --AND YEAR(DOCDATE) = @fecha
	  ORDER BY DOCDATE DESC;

--SELECT USER2ENT,BCHSOURC,* FROM dbo.SOP30200 WHERE USER2ENT = 'lmendez'
