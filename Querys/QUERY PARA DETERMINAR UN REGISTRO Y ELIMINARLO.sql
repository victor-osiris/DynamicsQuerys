
declare @codigo as char(50)
set @codigo = 'CD03'

if exists (select * from PRE01.dbo.CustomerDemographics where PRE01.dbo.CustomerDemographics.CustomerTypeID = @codigo)
	delete from PRE01.dbo.CustomerDem ographics where PRE01.dbo.CustomerDemographics.CustomerTypeID = @codigo
else
	print 'No existe el codigo '+@codigo
GO