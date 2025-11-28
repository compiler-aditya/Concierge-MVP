<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header -->
    <header class="bg-white shadow-sm sticky top-0 z-40">
      <div class="container-custom py-4">
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-bold text-gray-900">Admin Dashboard</h1>
            <p class="text-sm text-gray-600 mt-1">Analytics & Vendor Management</p>
          </div>
          <div class="flex items-center gap-3">
            <NuxtLink to="/" class="text-sm text-gray-600 hover:text-primary-600 transition-colors">
              View Site
            </NuxtLink>
            <button
              class="text-sm text-red-600 hover:text-red-700 transition-colors flex items-center gap-1"
              @click="handleLogout"
            >
              <LogOut :size="18" />
              Logout
            </button>
          </div>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="container-custom py-8">
      <!-- Stats Overview -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Total Vendors -->
        <div class="card p-6">
          <div class="flex items-center justify-between mb-2">
            <h3 class="text-sm font-medium text-gray-600">Total Vendors</h3>
            <Store :size="20" class="text-gray-400" />
          </div>
          <p class="text-3xl font-bold text-gray-900">{{ stats.totalVendors }}</p>
          <p class="text-sm text-gray-500 mt-1">
            {{ stats.activeVendors }} active
          </p>
        </div>

        <!-- Total Leads Today -->
        <div class="card p-6">
          <div class="flex items-center justify-between mb-2">
            <h3 class="text-sm font-medium text-gray-600">Leads Today</h3>
            <TrendingUp :size="20" class="text-green-500" />
          </div>
          <p class="text-3xl font-bold text-green-600">{{ stats.leadsToday }}</p>
          <p class="text-sm text-gray-500 mt-1">
            WhatsApp clicks
          </p>
        </div>

        <!-- Total Views Today -->
        <div class="card p-6">
          <div class="flex items-center justify-between mb-2">
            <h3 class="text-sm font-medium text-gray-600">Views Today</h3>
            <Eye :size="20" class="text-blue-500" />
          </div>
          <p class="text-3xl font-bold text-blue-600">{{ stats.viewsToday }}</p>
          <p class="text-sm text-gray-500 mt-1">
            Vendor page views
          </p>
        </div>

        <!-- Conversion Rate -->
        <div class="card p-6">
          <div class="flex items-center justify-between mb-2">
            <h3 class="text-sm font-medium text-gray-600">Conversion Rate</h3>
            <BarChart3 :size="20" class="text-purple-500" />
          </div>
          <p class="text-3xl font-bold text-purple-600">{{ conversionRate }}%</p>
          <p class="text-sm text-gray-500 mt-1">
            Views to leads
          </p>
        </div>
      </div>

      <!-- Top Performing Vendors -->
      <div class="card p-6 mb-8">
        <div class="flex items-center justify-between mb-6">
          <h2 class="text-xl font-bold text-gray-900">Top Performing Vendors</h2>
          <button
            class="text-sm text-primary-600 hover:text-primary-700 transition-colors"
            @click="fetchAnalytics"
          >
            <RefreshCw :size="18" class="inline" /> Refresh
          </button>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="space-y-3">
          <div v-for="i in 5" :key="i" class="h-16 bg-gray-100 rounded skeleton"></div>
        </div>

        <!-- Table -->
        <div v-else-if="topVendors.length > 0" class="overflow-x-auto">
          <table class="w-full">
            <thead class="bg-gray-50 border-b border-gray-200">
              <tr>
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-900">Rank</th>
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-900">Vendor</th>
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-900">Type</th>
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-900">Location</th>
                <th class="px-4 py-3 text-center text-sm font-semibold text-gray-900">Views</th>
                <th class="px-4 py-3 text-center text-sm font-semibold text-gray-900">Leads</th>
                <th class="px-4 py-3 text-center text-sm font-semibold text-gray-900">Rate</th>
                <th class="px-4 py-3 text-center text-sm font-semibold text-gray-900">Actions</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
              <tr
                v-for="(vendor, index) in topVendors"
                :key="vendor.id"
                class="hover:bg-gray-50 transition-colors"
              >
                <td class="px-4 py-3">
                  <div
                    class="w-8 h-8 rounded-full flex items-center justify-center font-bold text-sm"
                    :class="getRankBadgeClass(index)"
                  >
                    {{ index + 1 }}
                  </div>
                </td>
                <td class="px-4 py-3">
                  <div class="font-medium text-gray-900">{{ vendor.name }}</div>
                </td>
                <td class="px-4 py-3">
                  <span class="badge bg-gray-100 text-gray-800 capitalize">
                    {{ vendor.type }}
                  </span>
                </td>
                <td class="px-4 py-3 text-sm text-gray-600">
                  {{ vendor.area }}
                </td>
                <td class="px-4 py-3 text-center text-sm font-medium text-gray-900">
                  {{ vendor.page_views }}
                </td>
                <td class="px-4 py-3 text-center">
                  <span class="text-sm font-bold text-green-600">
                    {{ vendor.order_clicks }}
                  </span>
                </td>
                <td class="px-4 py-3 text-center text-sm text-gray-600">
                  {{ getConversionRate(vendor.page_views, vendor.order_clicks) }}%
                </td>
                <td class="px-4 py-3 text-center">
                  <NuxtLink
                    :to="`/vendor/${vendor.id}`"
                    target="_blank"
                    class="text-primary-600 hover:text-primary-700 text-sm"
                  >
                    View
                  </NuxtLink>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Empty State -->
        <div v-else class="text-center py-12">
          <BarChart3 :size="48" class="mx-auto text-gray-300 mb-3" />
          <p class="text-gray-600">No analytics data available yet</p>
        </div>
      </div>

      <!-- Quick Actions -->
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
        <!-- Add New Vendor -->
        <div class="card p-6">
          <h2 class="text-xl font-bold text-gray-900 mb-4">Quick Actions</h2>
          <div class="space-y-3">
            <NuxtLink
              to="/admin/vendors/new"
              class="btn-primary w-full flex items-center justify-center gap-2"
            >
              <Plus :size="20" />
              Add New Vendor
            </NuxtLink>
            <NuxtLink
              to="/admin/vendors"
              class="btn-secondary w-full flex items-center justify-center gap-2"
            >
              <List :size="20" />
              Manage Vendors
            </NuxtLink>
          </div>
        </div>

        <!-- Recent Activity -->
        <div class="card p-6">
          <h2 class="text-xl font-bold text-gray-900 mb-4">Recent Activity</h2>
          <div class="space-y-3">
            <div
              v-for="event in recentEvents.slice(0, 5)"
              :key="event.id"
              class="flex items-start gap-3 pb-3 border-b border-gray-100 last:border-0"
            >
              <div class="w-2 h-2 bg-green-500 rounded-full mt-2 flex-shrink-0"></div>
              <div class="flex-1 min-w-0">
                <p class="text-sm text-gray-900">
                  <span class="font-medium">{{ event.event_type.replace('_', ' ') }}</span>
                </p>
                <p class="text-xs text-gray-500">
                  {{ formatTimeAgo(event.created_at) }}
                </p>
              </div>
            </div>
            <div v-if="recentEvents.length === 0" class="text-sm text-gray-500 text-center py-4">
              No recent activity
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import {
  Store,
  TrendingUp,
  Eye,
  BarChart3,
  RefreshCw,
  LogOut,
  Plus,
  List
} from 'lucide-vue-next'
import type { VendorPerformance, AnalyticsEvent } from '~/types'

definePageMeta({
  middleware: 'admin-auth'
})

const router = useRouter()
const supabase = useSupabaseClient()

// State
const loading = ref(true)
const stats = ref({
  totalVendors: 0,
  activeVendors: 0,
  leadsToday: 0,
  viewsToday: 0
})
const topVendors = ref<VendorPerformance[]>([])
const recentEvents = ref<AnalyticsEvent[]>([])

// Computed
const conversionRate = computed(() => {
  if (stats.value.viewsToday === 0) return 0
  return ((stats.value.leadsToday / stats.value.viewsToday) * 100).toFixed(1)
})

// Fetch analytics
const fetchAnalytics = async () => {
  loading.value = true
  try {
    // Fetch vendor stats
    const { data: vendorsData } = await supabase
      .from('vendors')
      .select('id, is_active')

    if (vendorsData) {
      stats.value.totalVendors = vendorsData.length
      stats.value.activeVendors = vendorsData.filter(v => v.is_active).length
    }

    // Fetch today's stats
    const today = new Date()
    today.setHours(0, 0, 0, 0)

    const { data: eventsData } = await supabase
      .from('analytics_events')
      .select('*')
      .gte('created_at', today.toISOString())

    if (eventsData) {
      stats.value.leadsToday = eventsData.filter(e => e.event_type === 'click_order').length
      stats.value.viewsToday = eventsData.filter(e => e.event_type === 'view_vendor').length
    }

    // Fetch vendor performance
    const { data: performanceData } = await supabase
      .from('vendor_performance')
      .select('*')
      .order('order_clicks', { ascending: false })
      .limit(10)

    if (performanceData) {
      topVendors.value = performanceData
    }

    // Fetch recent events
    const { data: recentEventsData } = await supabase
      .from('analytics_events')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(10)

    if (recentEventsData) {
      recentEvents.value = recentEventsData
    }
  } catch (error) {
    console.error('Error fetching analytics:', error)
  } finally {
    loading.value = false
  }
}

// Helper functions
const getRankBadgeClass = (index: number) => {
  if (index === 0) return 'bg-yellow-100 text-yellow-800'
  if (index === 1) return 'bg-gray-200 text-gray-800'
  if (index === 2) return 'bg-orange-100 text-orange-800'
  return 'bg-gray-100 text-gray-600'
}

const getConversionRate = (views: number, clicks: number) => {
  if (views === 0) return 0
  return ((clicks / views) * 100).toFixed(1)
}

const formatTimeAgo = (timestamp: string) => {
  const now = new Date()
  const then = new Date(timestamp)
  const diff = now.getTime() - then.getTime()

  const minutes = Math.floor(diff / 60000)
  const hours = Math.floor(diff / 3600000)
  const days = Math.floor(diff / 86400000)

  if (minutes < 1) return 'Just now'
  if (minutes < 60) return `${minutes}m ago`
  if (hours < 24) return `${hours}h ago`
  return `${days}d ago`
}

const handleLogout = () => {
  sessionStorage.removeItem('admin_authenticated')
  sessionStorage.removeItem('admin_auth_time')
  router.push('/admin/login')
}

// Fetch on mount
onMounted(() => {
  fetchAnalytics()

  // Auto-refresh every 30 seconds
  const interval = setInterval(() => {
    fetchAnalytics()
  }, 30000)

  onUnmounted(() => {
    clearInterval(interval)
  })
})
</script>
