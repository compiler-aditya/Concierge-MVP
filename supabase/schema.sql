-- =====================================================
-- Tiffin & Hostel Concierge MVP - Database Schema
-- =====================================================
-- Run this in Supabase SQL Editor
-- =====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- 1. VENDORS TABLE
-- =====================================================
CREATE TABLE vendors (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  type VARCHAR(50) NOT NULL CHECK (type IN ('tiffin', 'hostel', 'both')),
  location VARCHAR(255) NOT NULL,
  area VARCHAR(100) NOT NULL, -- e.g., "Bhawarkuan", "Vijay Nagar"
  monthly_price INTEGER NOT NULL, -- in INR
  rating DECIMAL(2,1) DEFAULT 4.0 CHECK (rating >= 0 AND rating <= 5),
  phone VARCHAR(15) NOT NULL,
  whatsapp_number VARCHAR(15), -- Can be different from phone
  is_verified BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  image_url TEXT,
  description TEXT,
  amenities JSONB DEFAULT '[]'::jsonb, -- ["AC", "WiFi", "Parking"]
  address TEXT,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for faster location-based queries
CREATE INDEX idx_vendors_location ON vendors(area);
CREATE INDEX idx_vendors_type ON vendors(type);
CREATE INDEX idx_vendors_price ON vendors(monthly_price);
CREATE INDEX idx_vendors_active ON vendors(is_active) WHERE is_active = true;

-- =====================================================
-- 2. MENU ITEMS TABLE
-- =====================================================
CREATE TABLE menu_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  vendor_id UUID NOT NULL REFERENCES vendors(id) ON DELETE CASCADE,
  item_name VARCHAR(255) NOT NULL,
  day_of_week VARCHAR(10) CHECK (day_of_week IN ('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday', 'all')),
  meal_type VARCHAR(20) NOT NULL CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack')),
  description TEXT,
  is_vegetarian BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for faster vendor menu lookups
CREATE INDEX idx_menu_vendor ON menu_items(vendor_id);
CREATE INDEX idx_menu_type ON menu_items(meal_type);

-- =====================================================
-- 3. ANALYTICS EVENTS TABLE
-- =====================================================
CREATE TABLE analytics_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  vendor_id UUID REFERENCES vendors(id) ON DELETE SET NULL,
  event_type VARCHAR(50) NOT NULL, -- 'click_order', 'view_vendor', 'search', etc.
  user_metadata JSONB DEFAULT '{}'::jsonb, -- Store user agent, referrer, etc.
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for analytics queries
CREATE INDEX idx_analytics_vendor ON analytics_events(vendor_id);
CREATE INDEX idx_analytics_type ON analytics_events(event_type);
CREATE INDEX idx_analytics_created ON analytics_events(created_at DESC);

-- =====================================================
-- 4. ADMIN USERS TABLE (Optional - for dashboard auth)
-- =====================================================
CREATE TABLE admin_users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  pin_hash VARCHAR(255) NOT NULL, -- Store hashed PIN
  role VARCHAR(20) DEFAULT 'admin',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 5. ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Enable RLS
ALTER TABLE vendors ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;

-- Vendors: Public read access for active vendors
CREATE POLICY "Vendors are viewable by everyone"
  ON vendors FOR SELECT
  USING (is_active = true);

-- Vendors: Admins can do everything (you'll need to set up auth)
CREATE POLICY "Admins can manage vendors"
  ON vendors FOR ALL
  USING (auth.role() = 'authenticated');

-- Menu Items: Public read access
CREATE POLICY "Menu items are viewable by everyone"
  ON menu_items FOR SELECT
  USING (true);

-- Analytics: Anyone can insert (for tracking)
CREATE POLICY "Anyone can insert analytics"
  ON analytics_events FOR INSERT
  WITH CHECK (true);

-- Analytics: Only admins can read
CREATE POLICY "Only admins can view analytics"
  ON analytics_events FOR SELECT
  USING (auth.role() = 'authenticated');

-- =====================================================
-- 6. FUNCTIONS & TRIGGERS
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for vendors table
CREATE TRIGGER update_vendors_updated_at
  BEFORE UPDATE ON vendors
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 7. VIEWS FOR ANALYTICS
-- =====================================================

-- View: Top performing vendors by order clicks
CREATE OR REPLACE VIEW vendor_performance AS
SELECT
  v.id,
  v.name,
  v.type,
  v.location,
  v.area,
  COUNT(ae.id) FILTER (WHERE ae.event_type = 'click_order') as order_clicks,
  COUNT(ae.id) FILTER (WHERE ae.event_type = 'view_vendor') as page_views,
  MAX(ae.created_at) as last_interaction
FROM vendors v
LEFT JOIN analytics_events ae ON v.id = ae.vendor_id
GROUP BY v.id, v.name, v.type, v.location, v.area
ORDER BY order_clicks DESC;

-- View: Daily analytics summary
CREATE OR REPLACE VIEW daily_analytics AS
SELECT
  DATE(created_at) as date,
  event_type,
  COUNT(*) as event_count
FROM analytics_events
GROUP BY DATE(created_at), event_type
ORDER BY date DESC, event_count DESC;

-- =====================================================
-- 8. HELPER FUNCTIONS
-- =====================================================

-- Function to log analytics event (can be called from Supabase client)
CREATE OR REPLACE FUNCTION log_analytics_event(
  p_vendor_id UUID,
  p_event_type VARCHAR,
  p_user_metadata JSONB DEFAULT '{}'::jsonb
)
RETURNS UUID AS $$
DECLARE
  new_event_id UUID;
BEGIN
  INSERT INTO analytics_events (vendor_id, event_type, user_metadata)
  VALUES (p_vendor_id, p_event_type, p_user_metadata)
  RETURNING id INTO new_event_id;

  RETURN new_event_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- DONE! Your database is ready.
-- =====================================================
