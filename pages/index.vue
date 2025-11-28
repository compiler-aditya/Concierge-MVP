<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header -->
    <header class="bg-white shadow-sm sticky top-0 z-50">
      <div class="container-custom py-4">
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-bold text-gray-900">
              <span class="text-primary-600">Indore</span> Food & Stay
            </h1>
            <p class="text-sm text-gray-600 mt-1">Find verified tiffin services & hostels</p>
          </div>
          <NuxtLink
            to="/admin"
            class="text-sm text-gray-600 hover:text-primary-600 transition-colors"
          >
            <Settings :size="24" />
          </NuxtLink>
        </div>
      </div>
    </header>

    <!-- Filter Bar -->
    <FilterBar v-model="filters" class="mt-4" />

    <!-- Main Content -->
    <main class="container-custom py-6">
      <!-- Results Count -->
      <div class="mb-4 flex items-center justify-between">
        <p class="text-sm text-gray-600">
          <span class="font-semibold text-gray-900">{{ filteredVendors.length }}</span>
          {{ filteredVendors.length === 1 ? 'service' : 'services' }} found
        </p>

        <!-- Sort Dropdown -->
        <select
          v-model="sortBy"
          class="text-sm border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none"
        >
          <option value="rating">Highest Rated</option>
          <option value="price_low">Price: Low to High</option>
          <option value="price_high">Price: High to Low</option>
          <option value="newest">Newest First</option>
        </select>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <div v-for="i in 6" :key="i" class="card animate-pulse">
          <div class="h-48 bg-gray-200"></div>
          <div class="p-4 space-y-3">
            <div class="h-6 bg-gray-200 rounded skeleton"></div>
            <div class="h-4 bg-gray-200 rounded w-2/3 skeleton"></div>
            <div class="h-4 bg-gray-200 rounded skeleton"></div>
          </div>
        </div>
      </div>

      <!-- Vendor Grid -->
      <div
        v-else-if="filteredVendors.length > 0"
        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 animate-fade-in"
      >
        <VendorCard
          v-for="vendor in sortedVendors"
          :key="vendor.id"
          :vendor="vendor"
        />
      </div>

      <!-- Empty State -->
      <div v-else class="text-center py-16 animate-fade-in">
        <div class="inline-flex items-center justify-center w-16 h-16 bg-gray-100 rounded-full mb-4">
          <SearchX :size="32" class="text-gray-400" />
        </div>
        <h3 class="text-xl font-semibold text-gray-900 mb-2">No services found</h3>
        <p class="text-gray-600 mb-6">Try adjusting your filters or search query</p>
        <button
          class="btn-secondary"
          @click="clearFilters"
        >
          Clear Filters
        </button>
      </div>

      <!-- CTA Section -->
      <div class="mt-12 bg-gradient-to-r from-primary-500 to-primary-600 rounded-2xl p-8 text-white text-center">
        <h2 class="text-2xl font-bold mb-3">Can't find what you're looking for?</h2>
        <p class="text-primary-50 mb-6 max-w-2xl mx-auto">
          We're constantly adding new verified vendors. Contact us on WhatsApp and we'll help you find the perfect tiffin service or hostel.
        </p>
        <a
          :href="contactWhatsAppLink"
          target="_blank"
          rel="noopener noreferrer"
          class="btn-whatsapp inline-flex bg-white text-primary-600 hover:bg-primary-50"
        >
          <MessageCircle :size="20" />
          Contact Us on WhatsApp
        </a>
      </div>
    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-gray-200 mt-12">
      <div class="container-custom py-8">
        <div class="text-center text-sm text-gray-600">
          <p class="mb-2">© 2024 Indore Food & Stay Directory</p>
          <p class="text-xs text-gray-500">Helping students and professionals find trusted services in Indore</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { Settings, SearchX, MessageCircle } from 'lucide-vue-next'
import type { Vendor, FilterOptions } from '~/types'

// SEO
useHead({
  title: 'Tiffin Services & Hostels in Indore | Verified Directory',
  meta: [
    {
      name: 'description',
      content: 'Find verified tiffin services and hostels in Indore. Compare prices, menus, and book trial meals via WhatsApp.'
    }
  ]
})

const supabase = useSupabaseClient()
const config = useRuntimeConfig()
const { trackSearch, trackFilter } = useAnalytics()

// State
const vendors = ref<Vendor[]>([])
const loading = ref(true)
const sortBy = ref('rating')

const filters = ref<FilterOptions>({
  area: '',
  priceRange: [0, 15000],
  type: 'all',
  searchQuery: ''
})

// Fetch vendors
const fetchVendors = async () => {
  loading.value = true
  try {
    const { data, error } = await supabase
      .from('vendors')
      .select('*')
      .eq('is_active', true)
      .order('rating', { ascending: false })

    if (error) throw error
    vendors.value = data || []
  } catch (error) {
    console.error('Error fetching vendors:', error)
  } finally {
    loading.value = false
  }
}

// Filtered vendors
const filteredVendors = computed(() => {
  let result = vendors.value

  // Type filter
  if (filters.value.type !== 'all') {
    result = result.filter(v => v.type === filters.value.type)
  }

  // Area filter
  if (filters.value.area) {
    result = result.filter(v => v.area === filters.value.area)
  }

  // Price filter
  result = result.filter(v => v.monthly_price <= filters.value.priceRange[1])

  // Search query
  if (filters.value.searchQuery) {
    const query = filters.value.searchQuery.toLowerCase()
    result = result.filter(v =>
      v.name.toLowerCase().includes(query) ||
      v.area.toLowerCase().includes(query) ||
      v.description?.toLowerCase().includes(query)
    )
  }

  return result
})

// Sorted vendors
const sortedVendors = computed(() => {
  const vendors = [...filteredVendors.value]

  switch (sortBy.value) {
    case 'rating':
      return vendors.sort((a, b) => b.rating - a.rating)
    case 'price_low':
      return vendors.sort((a, b) => a.monthly_price - b.monthly_price)
    case 'price_high':
      return vendors.sort((a, b) => b.monthly_price - a.monthly_price)
    case 'newest':
      return vendors.sort((a, b) =>
        new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
      )
    default:
      return vendors
  }
})

// Contact WhatsApp link
const contactWhatsAppLink = computed(() => {
  const message = encodeURIComponent('Hi! I need help finding a tiffin service or hostel in Indore.')
  return `https://wa.me/${config.public.adminWhatsapp.replace(/\D/g, '')}?text=${message}`
})

// Clear filters
const clearFilters = () => {
  filters.value = {
    area: '',
    priceRange: [0, 15000],
    type: 'all',
    searchQuery: ''
  }
}

// Track filter changes
watch(filters, (newFilters) => {
  if (newFilters.searchQuery) {
    trackSearch(newFilters.searchQuery, newFilters)
  }
}, { deep: true })

// Fetch vendors on mount
onMounted(() => {
  fetchVendors()
})
</script>
