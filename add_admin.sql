-- ============================================
-- Add Admin Email Script
-- ============================================
-- Run this SQL to add an admin email
-- Replace 'your-admin@email.com' with the actual admin email

-- Add a single admin
INSERT INTO admins (email) 
VALUES ('your-admin@email.com')
ON CONFLICT (email) DO NOTHING;

-- ============================================
-- Examples of adding multiple admins:
-- ============================================
-- INSERT INTO admins (email) VALUES 
--     ('admin1@example.com'),
--     ('admin2@example.com'),
--     ('admin3@example.com')
-- ON CONFLICT (email) DO NOTHING;

-- ============================================
-- To remove an admin:
-- ============================================
-- DELETE FROM admins WHERE email = 'email-to-remove@example.com';

-- ============================================
-- To view all admins:
-- ============================================
-- SELECT * FROM admins;

