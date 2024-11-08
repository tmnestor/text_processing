A teradata  table Table1 has a composite primary key (primary_key1, primary_key2, primary_key3, primary_key4).
However primary_key1, primary_key2, primary_key3, primary_key4 can have nulls but the nulls of primary_key1 are not coincident with the nulls of primary_key2, primary_key3, primary_key4 and similarly for the component keys.
Table1 also has additional_field1, additional_field2, additional_field3, additional_field4, additional_field5, additional_field6, additional_field7
I need to update Table1 with the matching values from Table2, including adding the additional additional_field8 from Table2 that is not originally present in Table1.
All sql should use alias so that:
Table1 is aliased as trg and Table2 is aliased as src.
primary_key1 is aliased as pk1, primary_key2 is aliased as pk2, primary_key3 is aliased as pk3,
primary_key4 is aliased as pk4, additional_field1 is aliased as af1, additional_field2 is aliased as af2
additional_field3 is aliased as af3, additional_field4 is aliased as af4, additional_field5 is aliased as af5
additional_field6 is aliased as af6, additional_field7 is aliased as af7, additional_field8 is aliased as af8

-- Add an additional field to table1
ALTER TABLE table1
ADD extra_field data_type;

-- Update existing records in trg with matching records from src
-- The `UPDATE` statement is used to modify existing records in the `trg` table where there 
-- is a match in the composite keys from the `src` table. 
-- The `IS NOT DISTINCT FROM` condition ensures that NULL values are considered equivalent.
UPDATE Table1 AS trg
FROM Table2 AS src
SET trg.af1 = src.af1,
    trg.af2 = src.af2,
    trg.af3 = src.af3,
    trg.af4 = src.af4,
    trg.af5 = src.af5,
    trg.af6 = src.af6,
    trg.af7 = src.af7,
    trg.af8 = src.af8
WHERE (trg.pk1 IS NOT DISTINCT FROM src.pk1)
  AND (trg.pk2 IS NOT DISTINCT FROM src.pk2)
  AND (trg.pk3 IS NOT DISTINCT FROM src.pk3)
  AND (trg.pk4 IS NOT DISTINCT FROM src.pk4);



-- Add an additional field to table1
ALTER TABLE table1
ADD extra_field data_type;

-- Update existing records in trg with matching records from src
-- The `UPDATE` statement is used to modify existing records in the `trg` table where there 
-- is a match in the composite keys from the `src` table. 
-- The `IS NOT DISTINCT FROM` condition ensures that NULL values are considered equivalent.
UPDATE table1 AS trg
FROM table 2 AS src
SET trg.column1 = src.column1,               -- Set column1 in trg to column1 from src for matching rows
    trg.column2 = src.column2,               -- Set column2 in trg to column2 from src for matching rows
    trg.extra_field = src.extra_field        -- Set extra_field in trg to extra_field from src for matching rows
WHERE (trg.pk1 IS NOT DISTINCT FROM src.pk1) -- Compare pk1 in trg and src; NULLs are treated as equal
  AND (trg.pk2 IS NOT DISTINCT FROM src.pk2) -- Compare pk2 in trg and src; NULLs are treated as equal
  AND (trg.pk3 IS NOT DISTINCT FROM src.pk3) -- Compare pk3 in trg and src; NULLs are treated as equal
  AND (trg.pk4 IS NOT DISTINCT FROM src.pk4);-- Compare pk4 in trg and src; NULLs are treated as equal

-- Insert new records from src into trg
-- The `INSERT` statement adds new records to the `trg` table by selecting records from `src` 
-- that do not exist in `trg`. 
-- It uses a `NOT EXISTS` subquery to perform the check, considering columns as equal if they both contain NULLs.
INSERT INTO trg (pk1, pk2, pk3, pk4, column1, column2, extra_field) -- Define target table columns
SELECT src.pk1, src.pk2, src.pk3, src.pk4, src.column1, src.column2, src.extra_field -- Select columns from src
FROM src
WHERE NOT EXISTS (
    SELECT 1
    FROM trg
    WHERE (trg.pk1 IS NOT DISTINCT FROM src.pk1) -- Check if pk1 from trg and src are equal, treating NULLs as equal
      AND (trg.pk2 IS NOT DISTINCT FROM src.pk2) -- Check if pk2 from trg and src are equal, treating NULLs as equal
      AND (trg.pk3 IS NOT DISTINCT FROM src.pk3) -- Check if pk3 from trg and src are equal, treating NULLs as equal
      AND (trg.pk4 IS NOT DISTINCT FROM src.pk4) -- Check if pk4 from trg and src are equal, treating NULLs as equal
);


