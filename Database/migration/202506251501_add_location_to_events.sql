-- Step 1: Add the column as nullable
ALTER TABLE Events
ADD COLUMN location VARCHAR;

-- Step 2 (optional): Populate column for existing rows
UPDATE Events
SET location = 'Room 4'
WHERE location IS NULL;

-- Step 3 (optional): Add the foreign key constraint

-- Step 4 (optional): Make the column NOT NULL
ALTER TABLE Events
ALTER COLUMN location SET NOT NULL;

-- Step 5 (optional): Add UNIQUE constraint
