DECLARE @name VARCHAR(50) -- database name


DECLARE db_cursor CURSOR FOR
SELECT name
FROM master.dbo.sysdatabases
/* WHERE name IN ('512', '513', '514', '521', '522', '523', '524', '525', '527', '528', '541', '542', '543', '544', '561', '571', '581', '582', '583', '591', '593', '594')  -- include these databases */
WHERE name IN ('012', '013', '014', '021', '022', '023', '024', '025', '027', '028', '041', '042', '043', '044', '061', '071', '081', '082', '083', '091', '093', '094')  -- include these databases */
/* WHERE name IN ('521') */


OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @name

WHILE @@FETCH_STATUS = 0
BEGIN

DECLARE @query VARCHAR(MAX)

/* Debiteuren */
SET @query =
'
SELECT

/* REL.Division, */
' + @name + ' AS Division,
REL.[cmp_code],
REL.[cmp_name],
BNK.banknr,
BNK.accncd,
REL.BankAccountNumber,
BNK.[bank_rek],
BNK.accncd,
BNK.IBAN

FROM
[' + @name + '].[dbo].[cicmpy] AS REL
JOIN [' + @name + '].[dbo].[bnkkop] AS LNK
ON REL.crdnr = LNK.crdnr
JOIN [' + @name + '].[dbo].[bnkacc] AS BNK
ON LNK.[bank_rek] = BNK.banknr

-- nog een join op de koppeltabel toevoegen | 

ORDER BY
REL.[cmp_code] ASC
'

EXEC( @query)


  FETCH NEXT FROM db_cursor INTO @name
END

CLOSE db_cursor
DEALLOCATE db_cursor
