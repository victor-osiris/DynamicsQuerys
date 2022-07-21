USE DEVELOPMENT
GO
 
DECLARE @value VARCHAR(50)
DECLARE @columndatatype VARCHAR(50)
DECLARE @tabletype VARCHAR(2)

SET @value = 'PA0200003584' ----< PONER AQUI EL VALOR A BUSCAR.

SET @columndatatype = 'CHAR,VARCHAR,'
SET @tabletype = 'U'

DECLARE @tablename VARCHAR(50)
DECLARE @columnname VARCHAR(50)
DECLARE @columntype VARCHAR(50)
DECLARE @columnvalue VARCHAR(50)
DECLARE @sql VARCHAR(1000)
DECLARE @i INT

CREATE TABLE #tt
    (
      TableName VARCHAR(50) ,
      ColumnName VARCHAR(50) ,
      Active INT
    )

SET NOCOUNT ON
DECLARE Validate_Cursor CURSOR
FOR
    SELECT  o.name ,
            '[' + c.name + ']' name ,
            t.name
    FROM    sysobjects o
            INNER JOIN syscolumns c ON o.id = c.id
            INNER JOIN systypes t ON t.xtype = c.xtype
--and o.name='t_authorization'
    WHERE   o.type = @tabletype
 --and t.name=@columndatatype
            AND CHARINDEX(CAST(t.name AS VARCHAR) + ',', @columndatatype) > 0
    ORDER BY o.name ,
            c.name

OPEN Validate_Cursor
FETCH NEXT FROM Validate_Cursor INTO @tablename, @columnname, @columntype


WHILE @@FETCH_STATUS = 0
    BEGIN
	---------------------------------------------

        SET NOCOUNT ON

        SET @sql = N'insert #tt select ' + CHAR(39) + @tablename + CHAR(39)
            + N' as TableName,' + CHAR(39) + @columnname + CHAR(39)
            + N' as ColumnName, count(' + @columnname + N') as Active from '
            + QUOTENAME(@tablename) + N' where ' + @columnname + N'='
            + CHAR(39) + @value + CHAR(39) + N' GROUP BY ' + @columnname
--select @sql
        EXEC (@sql)

        IF @@error <> 0
            BEGIN
                PRINT @sql
            END

        FETCH NEXT FROM Validate_Cursor INTO @tablename, @columnname,
            @columntype

	--------------------------------------------
    END

CLOSE Validate_Cursor

DEALLOCATE Validate_Cursor
PRINT ( '========================================================================================================' )
SELECT  TableName ,
        ColumnName ,
        Active ,
        'Select * from ' + RTRIM(TableName) + ' where ' + RTRIM(ColumnName)
        + '=' + CHAR(39) + @value + CHAR(39) AS Query
FROM    #tt
ORDER BY 1


DROP TABLE #tt
