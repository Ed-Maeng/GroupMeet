-- Step 1: Add the column as nullable
ALTER TABLE Users
ADD COLUMN email VARCHAR(255);

-- Step 2 (optional): Populate column for existing rows
UPDATE Users
SET email = 'test@ucla.edu'
WHERE email IS NULL;

-- Step 3 (optional): Add the foreign key constraint

-- Step 4 (optional): Make the column NOT NULL
ALTER TABLE Users
ALTER COLUMN email SET NOT NULL;

-- Step 5 (optional): Add UNIQUE constraint
ALTER TABLE Users
ADD CONSTRAINT unique_email UNIQUE (email);