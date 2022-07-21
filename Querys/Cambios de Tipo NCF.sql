USE BLA01;
GO

/*
Script para actualizar tipo de NCF en clientes de 
	BlA01 -- Blandino
	PRE01 -- Camoruco

Valores:
	GOB - Gobierno
	PER - Personas
	MSC - Misceláneos
	EXE - Exento
	COM - Comercios
	PAS - Pasaporte
*/

DECLARE @CLIENTE AS VARCHAR(10);

SET @CLIENTE = 'CB062543';

-----------------------ACTUALIZAR TIPO COMPROBANTE A CLIENTE--------------------------
--UPDATE  dbo.SY90000
--SET     PropertyValue = 'PER - Personas'
--WHERE   ObjectID = @CLIENTE
--        AND ObjectType = 'NCF_Cliente'


----------------------INSERTAR TIPO DE COMPROBANTE A CLIENTE------------------------------
--INSERT INTO dbo.SY90000
--(
--    ObjectType,
--    ObjectID,
--    PropertyName,
--    PropertyValue
--)
--VALUES
--(   'NCF_Cliente', -- ObjectType - char(31)
--    @CLIENTE, -- ObjectID - char(61)
--    'TipoNCF', -- PropertyName - char(31)
--    'PAS - Pasaporte'  -- PropertyValue - char(133)
--    )

----------------------UPDATE EN MASA-----------------------------

--UPDATE dbo.SY90000
--SET PropertyValue = 'PER - Personas'
--WHERE ObjectType = 'NCF_Cliente'
--      AND ObjectID IN ('000479', '001692', '005693', '009439', '012393', '012485', '013127', '016850', '018587');

--SELECT *
--FROM dbo.SY90000
--WHERE ObjectType = 'NCF_Cliente'
--      AND ObjectID IN ('000479', '001692', '005693', '009439', '012393', '012485', '013127', '016850', '018587')
--					  ORDER BY ObjectID asc;

SELECT *
FROM dbo.SY90000
WHERE ObjectID = @CLIENTE
      AND ObjectType = 'NCF_Cliente';