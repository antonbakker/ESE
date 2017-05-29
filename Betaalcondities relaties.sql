DECLARE @name VARCHAR(50) -- database name

DECLARE db_cursor CURSOR FOR
SELECT name
FROM master.dbo.sysdatabases
WHERE name IN ('512', '513', '514', '521', '522', '523', '524', '525', '527', '528', '541', '542', '543', '544', '561', '571', '581', '582', '583', '591', '593', '594')  -- include these databases

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @name

WHILE @@FETCH_STATUS = 0
BEGIN

DECLARE @query VARCHAR(MAX)

SET @query =
'
SELECT
' + @name + ' AS Division,
[ESE_Relaties].[cmp_code],
[ESE_Relaties].[cmp_name],
[ESE_Relaties].[cmp_fadd1],
[ESE_Relaties].[cmp_fpc],
[ESE_Relaties].[cmp_fcity],
[ESE_Relaties].[cmp_fctry],
[ESE_DDeb].[Division] AS [DebDivion],
[ESE_DDeb].[DebCode],
[ESE_DCred].[Division] AS [CredDivision],
[ESE_DCred].[CrdCode],
[EGN_Relaties].[PaymentCondition]
FROM
[Syn_ent].[dbo].cicmpy AS [ESE_Relaties]
LEFT JOIN [Syn_ent].[dbo].DivisionCreditors AS [ESE_DCred]
ON [ESE_Relaties].[cmp_wwn] = [ESE_DCred].[Account]
LEFT JOIN [Syn_ent].[dbo].DivisionDebtors AS [ESE_DDeb]
ON [ESE_Relaties].[cmp_wwn] = [ESE_DDeb].[Account]
JOIN [' + @name + '].[dbo].[cicmpy] AS [EGN_Relaties]
ON [ESE_Relaties].[cmp_wwn] = [EGN_Relaties].[SyncID]
WHERE
/*[ESE_DDeb].Division = ' + @name + ' OR*/
[ESE_DCred].Division = ' + @name + '
'

EXEC( @query)


  FETCH NEXT FROM db_cursor INTO @name
END

CLOSE db_cursor
DEALLOCATE db_cursor
