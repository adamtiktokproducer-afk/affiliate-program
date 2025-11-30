-- ============================================
-- Supabase Schema for Affiliate Marketing System
-- Simple email-based admin verification
-- ============================================

-- 1. Admins Table - stores admin emails who can access the management page
CREATE TABLE IF NOT EXISTS admins (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Settings Table - stores system settings like product price
CREATE TABLE IF NOT EXISTS settings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    key TEXT UNIQUE NOT NULL,
    value TEXT NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Marketers Table - stores all marketer information
CREATE TABLE IF NOT EXISTS marketers (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    link TEXT NOT NULL,
    sales INTEGER DEFAULT 0,
    commission DECIMAL(10, 2) DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- Initial Data
-- ============================================

-- Insert default product price setting
INSERT INTO settings (key, value) 
VALUES ('product_price', '297')
ON CONFLICT (key) DO NOTHING;

-- Insert commission rate setting (50% = 0.5)
INSERT INTO settings (key, value) 
VALUES ('commission_rate', '0.5')
ON CONFLICT (key) DO NOTHING;

-- ============================================
-- Row Level Security (RLS) Policies
-- Allow public access (frontend handles admin verification)
-- ============================================

-- Enable RLS on all tables
ALTER TABLE admins ENABLE ROW LEVEL SECURITY;
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE marketers ENABLE ROW LEVEL SECURITY;

-- Admins table - allow read for all (to verify admin emails)
CREATE POLICY "Allow public read admins" ON admins
    FOR SELECT
    USING (true);

-- Settings table - allow read and update for all
CREATE POLICY "Allow public read settings" ON settings
    FOR SELECT
    USING (true);

CREATE POLICY "Allow public update settings" ON settings
    FOR UPDATE
    USING (true);

CREATE POLICY "Allow public insert settings" ON settings
    FOR INSERT
    WITH CHECK (true);

-- Marketers table - allow all operations
CREATE POLICY "Allow public read marketers" ON marketers
    FOR SELECT
    USING (true);

CREATE POLICY "Allow public insert marketers" ON marketers
    FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Allow public update marketers" ON marketers
    FOR UPDATE
    USING (true);

CREATE POLICY "Allow public delete marketers" ON marketers
    FOR DELETE
    USING (true);

-- ============================================
-- Function to update timestamp on marketers
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to auto-update updated_at
DROP TRIGGER IF EXISTS update_marketers_updated_at ON marketers;
CREATE TRIGGER update_marketers_updated_at
    BEFORE UPDATE ON marketers
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
