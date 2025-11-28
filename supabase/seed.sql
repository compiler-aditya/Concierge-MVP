-- =====================================================
-- SEED DATA for Testing
-- =====================================================
-- Run this AFTER schema.sql
-- =====================================================

-- Sample Tiffin Services
INSERT INTO vendors (name, type, location, area, monthly_price, rating, phone, whatsapp_number, is_verified, image_url, description, amenities) VALUES
(
  'Maa Ka Swad Tiffin',
  'tiffin',
  'Shop 12, Bhawarkuan Square',
  'Bhawarkuan',
  3500,
  4.5,
  '+919876543210',
  '+919876543210',
  true,
  'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800',
  'Homemade Gujarati & Punjabi thali delivered daily. Pure vegetarian.',
  '["Home Delivery", "Customizable Menu", "No MSG"]'
),
(
  'Student''s Choice Meals',
  'tiffin',
  'Near IIM Road',
  'Pipliyahana',
  2800,
  4.2,
  '+919876543211',
  '+919876543211',
  true,
  'https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=800',
  'Affordable meals for students. Mix of North & South Indian.',
  '["Budget Friendly", "Trial Available", "Flexible Plans"]'
),
(
  'Rajasthani Rasoi',
  'tiffin',
  'Vijay Nagar Main Road',
  'Vijay Nagar',
  4000,
  4.7,
  '+919876543212',
  '+919876543212',
  true,
  'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=800',
  'Authentic Rajasthani cuisine with homemade ghee and spices.',
  '["Traditional", "Hygenic", "Family Recipe"]'
),
(
  'Quick Bites Tiffin',
  'tiffin',
  'Palasia Square',
  'Palasia',
  3200,
  4.0,
  '+919876543213',
  '+919876543213',
  true,
  'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
  'Fast delivery, great taste. Perfect for working professionals.',
  '["On-Time Delivery", "Multiple Cuisines", "Contactless"]'
);

-- Sample Hostels
INSERT INTO vendors (name, type, location, area, monthly_price, rating, phone, whatsapp_number, is_verified, image_url, description, amenities) VALUES
(
  'Shanti Boys Hostel',
  'hostel',
  'Behind SGSITS College',
  'Indore',
  5000,
  4.3,
  '+919876543214',
  '+919876543214',
  true,
  'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800',
  'Safe and affordable boys hostel near major colleges.',
  '["WiFi", "CCTV", "24x7 Security", "Laundry"]'
),
(
  'Comfort Girls PG',
  'hostel',
  'Vijay Nagar Scheme 54',
  'Vijay Nagar',
  6500,
  4.6,
  '+919876543215',
  '+919876543215',
  true,
  'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
  'Premium girls PG with all modern amenities.',
  '["AC Rooms", "Attached Bathroom", "Meals Included", "Gym"]'
);

-- Sample Menu Items for "Maa Ka Swad Tiffin"
INSERT INTO menu_items (vendor_id, item_name, day_of_week, meal_type, description, is_vegetarian)
SELECT
  id as vendor_id,
  'Poha & Tea',
  'all',
  'breakfast',
  'Light and healthy breakfast',
  true
FROM vendors WHERE name = 'Maa Ka Swad Tiffin';

INSERT INTO menu_items (vendor_id, item_name, day_of_week, meal_type, description, is_vegetarian)
SELECT
  id as vendor_id,
  'Dal Fry, Roti, Rice, Sabzi',
  'monday',
  'lunch',
  'Complete Gujarati thali',
  true
FROM vendors WHERE name = 'Maa Ka Swad Tiffin';

INSERT INTO menu_items (vendor_id, item_name, day_of_week, meal_type, description, is_vegetarian)
SELECT
  id as vendor_id,
  'Paneer Curry, Roti, Rice',
  'tuesday',
  'lunch',
  'Special paneer preparation',
  true
FROM vendors WHERE name = 'Maa Ka Swad Tiffin';

INSERT INTO menu_items (vendor_id, item_name, day_of_week, meal_type, description, is_vegetarian)
SELECT
  id as vendor_id,
  'Mix Veg, Dal Tadka, Chapati',
  'all',
  'dinner',
  'Light dinner option',
  true
FROM vendors WHERE name = 'Maa Ka Swad Tiffin';

-- Sample Menu Items for "Student's Choice Meals"
INSERT INTO menu_items (vendor_id, item_name, day_of_week, meal_type, description, is_vegetarian)
SELECT
  id as vendor_id,
  'Upma & Sambhar',
  'all',
  'breakfast',
  'South Indian breakfast',
  true
FROM vendors WHERE name = 'Student''s Choice Meals';

INSERT INTO menu_items (vendor_id, item_name, day_of_week, meal_type, description, is_vegetarian)
SELECT
  id as vendor_id,
  'Rajma Rice with Salad',
  'monday',
  'lunch',
  'Protein-rich meal',
  true
FROM vendors WHERE name = 'Student''s Choice Meals';

INSERT INTO menu_items (vendor_id, item_name, day_of_week, meal_type, description, is_vegetarian)
SELECT
  id as vendor_id,
  'Chole Bhature',
  'sunday',
  'lunch',
  'Special Sunday treat',
  true
FROM vendors WHERE name = 'Student''s Choice Meals';

-- Sample analytics events (for testing dashboard)
INSERT INTO analytics_events (vendor_id, event_type, user_metadata)
SELECT
  v.id,
  'view_vendor',
  '{"user_agent": "Mozilla/5.0", "source": "organic"}'::jsonb
FROM vendors v
WHERE v.name IN ('Maa Ka Swad Tiffin', 'Student''s Choice Meals')
LIMIT 10;

INSERT INTO analytics_events (vendor_id, event_type, user_metadata)
SELECT
  v.id,
  'click_order',
  '{"user_agent": "Mozilla/5.0", "source": "organic"}'::jsonb
FROM vendors v
WHERE v.name = 'Maa Ka Swad Tiffin'
LIMIT 5;

-- =====================================================
-- Verify data
-- =====================================================
-- Run these queries to check:
-- SELECT * FROM vendors;
-- SELECT * FROM menu_items;
-- SELECT * FROM analytics_events;
-- SELECT * FROM vendor_performance;
