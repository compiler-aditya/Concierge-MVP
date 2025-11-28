// Database types matching Supabase schema

export interface Vendor {
  id: string
  name: string
  type: 'tiffin' | 'hostel' | 'both'
  location: string
  area: string
  monthly_price: number
  rating: number
  phone: string
  whatsapp_number: string | null
  is_verified: boolean
  is_active: boolean
  image_url: string | null
  description: string | null
  amenities: string[]
  address: string | null
  latitude: number | null
  longitude: number | null
  created_at: string
  updated_at: string
}

export interface MenuItem {
  id: string
  vendor_id: string
  item_name: string
  day_of_week: 'monday' | 'tuesday' | 'wednesday' | 'thursday' | 'friday' | 'saturday' | 'sunday' | 'all'
  meal_type: 'breakfast' | 'lunch' | 'dinner' | 'snack'
  description: string | null
  is_vegetarian: boolean
  created_at: string
}

export interface AnalyticsEvent {
  id: string
  vendor_id: string | null
  event_type: string
  user_metadata: Record<string, any>
  created_at: string
}

export interface VendorPerformance {
  id: string
  name: string
  type: string
  location: string
  area: string
  order_clicks: number
  page_views: number
  last_interaction: string | null
}

export interface DailyAnalytics {
  date: string
  event_type: string
  event_count: number
}

// Frontend-specific types
export interface FilterOptions {
  area: string
  priceRange: [number, number]
  type: 'all' | 'tiffin' | 'hostel'
  searchQuery: string
}

export interface VendorWithMenu extends Vendor {
  menu_items?: MenuItem[]
}
