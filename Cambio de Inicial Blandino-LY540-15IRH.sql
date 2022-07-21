USE DEVELOPMENT
GO

------------------------- Inicio Script

Declare @PA varchar(21)
Declare @NuevoINI numeric(19,5)

--------------Cambiar Valores Aqui
set @PA ='PA0200005574'
--61200
set @NUEVOINI =2500
--------------Fin de CAmbios

update DYNPRE01_PRA_MASTER
set PRASTARTAMNT = @NUEVOINI
where PRANUM=@PA

update DYNPRE01_PRA_PAYMENTS
set PRAESTAMNT=@NUEVOINI
where PRANUM=@PA and PRAPAYNO>0

EXEC ICONPRE01_PRA_CONCILIAR @PA
exec ICONPRE01_PRA_REDISTRIBUIR @PA
EXEC ICONPRE01_PRA_CONCILIAR @PA
------------------------- Fin script


