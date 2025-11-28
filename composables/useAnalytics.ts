import type { AnalyticsEvent } from '~/types'

export const useAnalytics = () => {
  const supabase = useSupabaseClient()

  /**
   * Track an analytics event
   * This silently logs events without blocking the user experience
   */
  const trackEvent = async (
    vendorId: string | null,
    eventType: string,
    metadata: Record<string, any> = {}
  ): Promise<void> => {
    try {
      // Gather user metadata
      const userMetadata = {
        ...metadata,
        user_agent: navigator.userAgent,
        timestamp: new Date().toISOString(),
        referrer: document.referrer || 'direct',
        screen_width: window.innerWidth,
        screen_height: window.innerHeight
      }

      // Insert analytics event
      const { error } = await supabase
        .from('analytics_events')
        .insert({
          vendor_id: vendorId,
          event_type: eventType,
          user_metadata: userMetadata
        })

      if (error) {
        console.error('Analytics tracking error:', error)
        // Don't throw - analytics should never break user experience
      }
    } catch (err) {
      console.error('Analytics tracking failed:', err)
      // Fail silently
    }
  }

  /**
   * Track vendor view
   */
  const trackVendorView = async (vendorId: string) => {
    await trackEvent(vendorId, 'view_vendor', {
      action: 'vendor_page_view'
    })
  }

  /**
   * Track order click (WhatsApp button click)
   */
  const trackOrderClick = async (vendorId: string, vendorName: string) => {
    await trackEvent(vendorId, 'click_order', {
      action: 'whatsapp_click',
      vendor_name: vendorName
    })
  }

  /**
   * Track search action
   */
  const trackSearch = async (searchQuery: string, filters: any) => {
    await trackEvent(null, 'search', {
      query: searchQuery,
      filters: filters
    })
  }

  /**
   * Track filter usage
   */
  const trackFilter = async (filterType: string, filterValue: any) => {
    await trackEvent(null, 'filter_used', {
      filter_type: filterType,
      filter_value: filterValue
    })
  }

  /**
   * Generate WhatsApp link with pre-filled message
   * Also tracks the click event
   */
  const generateWhatsAppLink = async (
    vendorId: string,
    vendorName: string,
    vendorPhone?: string
  ): Promise<string> => {
    const config = useRuntimeConfig()

    // Track the click before redirecting
    await trackOrderClick(vendorId, vendorName)

    // Use admin WhatsApp number (not vendor's)
    const adminNumber = config.public.adminWhatsapp

    // Pre-filled message
    const message = `Hi! I want to book a trial tiffin from *${vendorName}*.

My details:
Name:
Location:
Phone:

Please share more details about the trial meal.`

    // Encode the message for URL
    const encodedMessage = encodeURIComponent(message)

    // Return WhatsApp API link
    return `https://wa.me/${adminNumber.replace(/\D/g, '')}?text=${encodedMessage}`
  }

  return {
    trackEvent,
    trackVendorView,
    trackOrderClick,
    trackSearch,
    trackFilter,
    generateWhatsAppLink
  }
}
