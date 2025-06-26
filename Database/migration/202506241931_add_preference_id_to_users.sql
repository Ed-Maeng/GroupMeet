-- Step 1: Add the column as nullable
ALTER TABLE Users
ADD COLUMN preference_id INTEGER;

-- Step 2 (optional): Populate column for existing rows

-- Step 3 (optional): Add the foreign key constraint
ALTER TABLE Users
ADD CONSTRAINT fk_users_preferences
FOREIGN KEY (preference_id) REFERENCES Preferences(preference_id);

-- Step 4 (optional): Make the column NOT NULL
ALTER TABLE Users
ALTER COLUMN preference_id SET NOT NULL;

-- Step 5 (optional): Add UNIQUE constraint
