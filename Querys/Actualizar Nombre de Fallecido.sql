USE BLA01
GO

DECLARE @Documento AS VARCHAR(50)

SET @Documento = 'FB0300016810'


--UPDATE SOP10106
--SET USRDEF04='JOSE MARTIRES'
--WHERE [SOPNUMBE]=@Documento


SELECT USRDEF03 'Declarante',USRDEF04 'Fallecido'
from SOP10106 where [SOPNUMBE]=@Documento