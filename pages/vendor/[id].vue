<template>
  <div class="min-h-screen bg-gray-50 pb-24">
    <!-- Loading State -->
    <div v-if="loading" class="animate-pulse">
      <div class="h-64 bg-gray-200"></div>
      <div class="container-custom py-6 space-y-4">
        <div class="h-8 bg-gray-200 rounded w-3/4"></div>
        <div class="h-4 bg-gray-200 rounded w-1/2"></div>
        <div class="h-32 bg-gray-200 rounded"></div>
      </div>
    </div>

    <!-- Vendor Not Found -->
    <div v-else-if="!vendor" class="container-custom py-16 text-center">
      <AlertCircle :size="48" class="mx-auto text-gray-400 mb-4" />
      <h2 class="text-2xl font-bold text-gray-900 mb-2">Vendor Not Found</h2>
      <p class="text-gray-600 mb-6">This vendor may have been removed or doesn't exist.</p>
      <NuxtLink to="/" class="btn-primary inline-block">
        Back to Directory
      </NuxtLink>
    </div>

    <!-- Vendor Details -->
    <div v-else class="animate-fade-in">
      <!-- Hero Image -->
      <div class="relative h-64 sm:h-80 bg-gray-200 overflow-hidden">
        <img
          v-if="vendor.image_url"
          :src="vendor.image_url"
          :alt="vendor.name"
          class="w-full h-full object-cover"
        />
        <div
          v-else
          class="w-full h-full flex items-center justify-center bg-gradient-to-br from-primary-400 to-primary-600"
        >
          <component :is="vendorIcon" class="w-24 h-24 text-white opacity-50" />
        </div>

        <!-- Back Button -->
        <NuxtLink
          to="/"
          class="absolute top-4 left-4 bg-white/90 backdrop-blur-sm p-2 rounded-full shadow-lg hover:bg-white transition-colors"
        >
          <ArrowLeft :size="24" class="text-gray-900" />
        </NuxtLink>

        <!-- Verified Badge -->
        <div
          v-if="vendor.is_verified"
          class="absolute top-4 right-4 badge badge-verified flex items-center gap-1 shadow-lg"
        >
          <CheckCircle :size="16" />
          <span>Verified</span>
        </div>
      </div>

      <!-- Vendor Info -->
      <div class="container-custom py-6">
        <!-- Header -->
        <div class="mb-6">
          <div class="flex items-start justify-between mb-3">
            <div>
              <h1 class="text-3xl font-bold text-gray-900 mb-2">{{ vendor.name }}</h1>
              <div class="flex items-center gap-2 text-gray-600 mb-2">
                <MapPin :size="18" />
                <span>{{ vendor.location }}, {{ vendor.area }}</span>
              </div>
            </div>
            <div class="text-right">
              <div class="text-3xl font-bold text-primary-600">
                ₹{{ vendor.monthly_price.toLocaleString('en-IN') }}
              </div>
              <div class="text-sm text-gray-500">per month</div>
            </div>
          </div>

          <!-- Rating & Type -->
          <div class="flex items-center gap-3">
            <div class="badge badge-rating flex items-center gap-1">
              <Star :size="16" class="fill-current" />
              <span class="font-semibold">{{ vendor.rating }}</span>
            </div>
            <div class="badge bg-gray-100 text-gray-800 capitalize">
              {{ vendor.type }}
            </div>
          </div>
        </div>

        <!-- Description -->
        <div v-if="vendor.description" class="mb-6">
          <h2 class="text-xl font-bold text-gray-900 mb-3">About</h2>
          <p class="text-gray-700 leading-relaxed">{{ vendor.description }}</p>
        </div>

        <!-- Amenities -->
        <div v-if="vendor.amenities && vendor.amenities.length > 0" class="mb-6">
          <h2 class="text-xl font-bold text-gray-900 mb-3">
            {{ vendor.type === 'hostel' ? 'Amenities' : 'Features' }}
          </h2>
          <div class="grid grid-cols-2 sm:grid-cols-3 gap-3">
            <div
              v-for="(amenity, index) in vendor.amenities"
              :key="index"
              class="flex items-center gap-2 bg-white p-3 rounded-lg shadow-sm"
            >
              <CheckCircle :size="18" class="text-green-500 flex-shrink-0" />
              <span class="text-sm text-gray-700">{{ amenity }}</span>
            </div>
          </div>
        </div>

        <!-- Menu (for Tiffin Services) -->
        <div v-if="vendor.type !== 'hostel' && menuItems.length > 0" class="mb-6">
          <h2 class="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
            <UtensilsCrossed :size="24" />
            Menu
          </h2>

          <!-- Grouped by Meal Type -->
          <div class="space-y-4">
            <div v-for="mealType in mealTypes" :key="mealType" class="bg-white rounded-xl shadow-sm p-4">
              <h3 class="text-lg font-semibold text-gray-900 mb-3 capitalize">
                {{ mealType }}
              </h3>
              <div class="space-y-2">
                <div
                  v-for="item in getMenuByMealType(mealType)"
                  :key="item.id"
                  class="flex items-start justify-between py-2 border-b border-gray-100 last:border-0"
                >
                  <div class="flex-1">
                    <div class="flex items-center gap-2">
                      <span
                        v-if="item.is_vegetarian"
                        class="w-4 h-4 border-2 border-green-600 flex items-center justify-center"
                      >
                        <span class="w-2 h-2 bg-green-600 rounded-full"></span>
                      </span>
                      <h4 class="font-medium text-gray-900">{{ item.item_name }}</h4>
                    </div>
                    <p v-if="item.description" class="text-sm text-gray-600 mt-1 ml-6">
                      {{ item.description }}
                    </p>
                  </div>
                  <span
                    v-if="item.day_of_week !== 'all'"
                    class="text-xs text-gray-500 capitalize ml-3 flex-shrink-0"
                  >
                    {{ item.day_of_week }}
                  </span>
                </div>
              </div>
            </div>
          </div>

          <!-- Menu Note -->
          <p class="text-sm text-gray-500 mt-3 italic">
            * Menu may vary. Contact us for current week's menu.
          </p>
        </div>

        <!-- Address & Contact -->
        <div class="bg-white rounded-xl shadow-sm p-5 mb-6">
          <h2 class="text-xl font-bold text-gray-900 mb-4">Contact Information</h2>
          <div class="space-y-3">
            <div v-if="vendor.address" class="flex items-start gap-3">
              <MapPin :size="20" class="text-gray-400 flex-shrink-0 mt-0.5" />
              <div>
                <div class="text-sm font-medium text-gray-900">Address</div>
                <div class="text-sm text-gray-600">{{ vendor.address || vendor.location }}</div>
              </div>
            </div>
            <div class="flex items-start gap-3">
              <Phone :size="20" class="text-gray-400 flex-shrink-0 mt-0.5" />
              <div>
                <div class="text-sm font-medium text-gray-900">Phone</div>
                <a :href="`tel:${vendor.phone}`" class="text-sm text-primary-600 hover:underline">
                  {{ vendor.phone }}
                </a>
              </div>
            </div>
          </div>
        </div>

        <!-- Important Notice -->
        <div class="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6">
          <div class="flex gap-3">
            <Info :size="20" class="text-blue-600 flex-shrink-0 mt-0.5" />
            <div class="text-sm text-blue-900">
              <p class="font-semibold mb-1">How It Works</p>
              <p>
                Click "Book Trial Meal" below to connect with us on WhatsApp. We'll coordinate with
                {{ vendor.name }} and arrange your trial at the best price. No payment needed now!
              </p>
            </div>
          </div>
        </div>
      </div>

      <!-- Sticky Bottom CTA -->
      <div class="sticky-bottom">
        <div class="container-custom">
          <button
            class="btn-whatsapp w-full text-lg py-4 shadow-2xl"
            :disabled="orderLoading"
            @click="handleBookTrial"
          >
            <MessageCircle :size="24" />
            <span v-if="!orderLoading">
              Book Trial {{ vendor.type === 'hostel' ? 'Visit' : 'Meal' }} via WhatsApp
            </span>
            <span v-else>Redirecting...</span>
          </button>
          <p class="text-xs text-gray-500 text-center mt-2">
            Free consultation • No payment required • Instant response
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import {
  ArrowLeft,
  MapPin,
  Star,
  CheckCircle,
  UtensilsCrossed,
  Home,
  Phone,
  Info,
  MessageCircle,
  AlertCircle
} from 'lucide-vue-next'
import type { Vendor, MenuItem } from '~/types'

const route = useRoute()
const supabase = useSupabaseClient()
const { trackVendorView, generateWhatsAppLink } = useAnalytics()

// State
const vendor = ref<Vendor | null>(null)
const menuItems = ref<MenuItem[]>([])
const loading = ref(true)
const orderLoading = ref(false)

// Fetch vendor details
const fetchVendor = async () => {
  loading.value = true
  try {
    const vendorId = route.params.id as string

    // Fetch vendor
    const { data: vendorData, error: vendorError } = await supabase
      .from('vendors')
      .select('*')
      .eq('id', vendorId)
      .eq('is_active', true)
      .single()

    if (vendorError) throw vendorError
    vendor.value = vendorData

    // Track vendor view
    if (vendorData) {
      await trackVendorView(vendorData.id)
    }

    // Fetch menu items if tiffin service
    if (vendorData && vendorData.type !== 'hostel') {
      const { data: menuData, error: menuError } = await supabase
        .from('menu_items')
        .select('*')
        .eq('vendor_id', vendorId)
        .order('meal_type')

      if (!menuError && menuData) {
        menuItems.value = menuData
      }
    }
  } catch (error) {
    console.error('Error fetching vendor:', error)
    vendor.value = null
  } finally {
    loading.value = false
  }
}

// Vendor icon
const vendorIcon = computed(() => {
  return vendor.value?.type === 'hostel' ? Home : UtensilsCrossed
})

// Get unique meal types
const mealTypes = computed(() => {
  const types = new Set(menuItems.value.map(item => item.meal_type))
  return Array.from(types).sort((a, b) => {
    const order = ['breakfast', 'lunch', 'dinner', 'snack']
    return order.indexOf(a) - order.indexOf(b)
  })
})

// Get menu items by meal type
const getMenuByMealType = (mealType: string) => {
  return menuItems.value.filter(item => item.meal_type === mealType)
}

// Handle Book Trial - THE CONCIERGE LOGIC
const handleBookTrial = async () => {
  if (!vendor.value) return

  orderLoading.value = true

  try {
    // Step A: Track analytics event (silently in background)
    // This is already done in generateWhatsAppLink

    // Step B: Generate WhatsApp link (also tracks the event)
    const whatsappLink = await generateWhatsAppLink(
      vendor.value.id,
      vendor.value.name,
      vendor.value.whatsapp_number || vendor.value.phone
    )

    // Step C: Redirect to WhatsApp
    // Small delay to ensure analytics is logged
    setTimeout(() => {
      window.open(whatsappLink, '_blank')
      orderLoading.value = false
    }, 500)
  } catch (error) {
    console.error('Error generating WhatsApp link:', error)
    orderLoading.value = false
  }
}

// SEO
useHead({
  title: computed(() => vendor.value ? `${vendor.value.name} - Indore Directory` : 'Loading...'),
  meta: computed(() => [
    {
      name: 'description',
      content: vendor.value?.description || `View details for ${vendor.value?.name} in ${vendor.value?.area}`
    }
  ])
})

// Fetch vendor on mount
onMounted(() => {
  fetchVendor()
})
</script>
