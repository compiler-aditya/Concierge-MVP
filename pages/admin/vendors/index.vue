<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header -->
    <header class="bg-white shadow-sm sticky top-0 z-40">
      <div class="container-custom py-4">
        <div class="flex items-center justify-between">
          <div>
            <NuxtLink to="/admin" class="text-sm text-gray-600 hover:text-primary-600 mb-2 inline-flex items-center gap-1">
              <ArrowLeft :size="16" />
              Back to Dashboard
            </NuxtLink>
            <h1 class="text-2xl font-bold text-gray-900">Manage Vendors</h1>
          </div>
          <NuxtLink to="/admin/vendors/new" class="btn-primary flex items-center gap-2">
            <Plus :size="20" />
            Add Vendor
          </NuxtLink>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="container-custom py-8">
      <!-- Filters -->
      <div class="card p-4 mb-6">
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Search vendors..."
            class="input"
          />
          <select v-model="filterType" class="input">
            <option value="">All Types</option>
            <option value="tiffin">Tiffin</option>
            <option value="hostel">Hostel</option>
            <option value="both">Both</option>
          </select>
          <select v-model="filterStatus" class="input">
            <option value="all">All Status</option>
            <option value="active">Active</option>
            <option value="inactive">Inactive</option>
          </select>
        </div>
      </div>

      <!-- Vendors List -->
      <div class="card overflow-hidden">
        <!-- Loading -->
        <div v-if="loading" class="p-8 space-y-4">
          <div v-for="i in 5" :key="i" class="h-20 bg-gray-100 rounded skeleton"></div>
        </div>

        <!-- Table -->
        <div v-else-if="filteredVendors.length > 0" class="overflow-x-auto">
          <table class="w-full">
            <thead class="bg-gray-50 border-b border-gray-200">
              <tr>
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-900">Vendor</th>
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-900">Type</th>
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-900">Location</th>
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-900">Price</th>
                <th class="px-4 py-3 text-center text-sm font-semibold text-gray-900">Status</th>
                <th class="px-4 py-3 text-center text-sm font-semibold text-gray-900">Actions</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
              <tr
                v-for="vendor in filteredVendors"
                :key="vendor.id"
                class="hover:bg-gray-50 transition-colors"
              >
                <td class="px-4 py-3">
                  <div class="flex items-center gap-3">
                    <img
                      v-if="vendor.image_url"
                      :src="vendor.image_url"
                      :alt="vendor.name"
                      class="w-12 h-12 rounded-lg object-cover"
                    />
                    <div
                      v-else
                      class="w-12 h-12 rounded-lg bg-gray-200 flex items-center justify-center"
                    >
                      <Store :size="20" class="text-gray-400" />
                    </div>
                    <div>
                      <div class="font-medium text-gray-900">{{ vendor.name }}</div>
                      <div v-if="vendor.is_verified" class="text-xs text-green-600 flex items-center gap-1">
                        <CheckCircle :size="12" />
                        Verified
                      </div>
                    </div>
                  </div>
                </td>
                <td class="px-4 py-3">
                  <span class="badge bg-gray-100 text-gray-800 capitalize">
                    {{ vendor.type }}
                  </span>
                </td>
                <td class="px-4 py-3 text-sm text-gray-600">
                  {{ vendor.area }}
                </td>
                <td class="px-4 py-3 text-sm font-medium text-gray-900">
                  ₹{{ vendor.monthly_price.toLocaleString('en-IN') }}
                </td>
                <td class="px-4 py-3 text-center">
                  <button
                    class="badge cursor-pointer"
                    :class="vendor.is_active ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'"
                    @click="toggleStatus(vendor)"
                  >
                    {{ vendor.is_active ? 'Active' : 'Inactive' }}
                  </button>
                </td>
                <td class="px-4 py-3">
                  <div class="flex items-center justify-center gap-2">
                    <NuxtLink
                      :to="`/vendor/${vendor.id}`"
                      target="_blank"
                      class="text-gray-600 hover:text-primary-600 transition-colors"
                      title="View"
                    >
                      <Eye :size="18" />
                    </NuxtLink>
                    <NuxtLink
                      :to="`/admin/vendors/edit/${vendor.id}`"
                      class="text-gray-600 hover:text-blue-600 transition-colors"
                      title="Edit"
                    >
                      <Edit :size="18" />
                    </NuxtLink>
                    <button
                      class="text-gray-600 hover:text-red-600 transition-colors"
                      title="Delete"
                      @click="confirmDelete(vendor)"
                    >
                      <Trash2 :size="18" />
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Empty State -->
        <div v-else class="p-12 text-center">
          <Store :size="48" class="mx-auto text-gray-300 mb-3" />
          <p class="text-gray-600">No vendors found</p>
        </div>
      </div>
    </main>

    <!-- Delete Confirmation Modal -->
    <div
      v-if="deleteModal.show"
      class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4"
      @click.self="deleteModal.show = false"
    >
      <div class="card max-w-md w-full p-6 animate-fade-in">
        <h3 class="text-xl font-bold text-gray-900 mb-3">Delete Vendor?</h3>
        <p class="text-gray-600 mb-6">
          Are you sure you want to delete <strong>{{ deleteModal.vendor?.name }}</strong>?
          This action cannot be undone.
        </p>
        <div class="flex gap-3">
          <button
            class="btn-secondary flex-1"
            @click="deleteModal.show = false"
          >
            Cancel
          </button>
          <button
            class="bg-red-500 text-white px-6 py-3 rounded-lg font-semibold hover:bg-red-600 flex-1"
            @click="deleteVendor"
          >
            Delete
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ArrowLeft, Plus, Store, CheckCircle, Eye, Edit, Trash2 } from 'lucide-vue-next'
import type { Vendor } from '~/types'

definePageMeta({
  middleware: 'admin-auth'
})

const supabase = useSupabaseClient()

// State
const vendors = ref<Vendor[]>([])
const loading = ref(true)
const searchQuery = ref('')
const filterType = ref('')
const filterStatus = ref('all')
const deleteModal = ref({
  show: false,
  vendor: null as Vendor | null
})

// Fetch vendors
const fetchVendors = async () => {
  loading.value = true
  try {
    const { data, error } = await supabase
      .from('vendors')
      .select('*')
      .order('created_at', { ascending: false })

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

  // Search
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    result = result.filter(v =>
      v.name.toLowerCase().includes(query) ||
      v.area.toLowerCase().includes(query)
    )
  }

  // Type filter
  if (filterType.value) {
    result = result.filter(v => v.type === filterType.value)
  }

  // Status filter
  if (filterStatus.value !== 'all') {
    const isActive = filterStatus.value === 'active'
    result = result.filter(v => v.is_active === isActive)
  }

  return result
})

// Toggle vendor status
const toggleStatus = async (vendor: Vendor) => {
  try {
    const { error } = await supabase
      .from('vendors')
      .update({ is_active: !vendor.is_active })
      .eq('id', vendor.id)

    if (error) throw error

    // Update local state
    vendor.is_active = !vendor.is_active
  } catch (error) {
    console.error('Error toggling status:', error)
    alert('Failed to update vendor status')
  }
}

// Confirm delete
const confirmDelete = (vendor: Vendor) => {
  deleteModal.value = {
    show: true,
    vendor
  }
}

// Delete vendor
const deleteVendor = async () => {
  if (!deleteModal.value.vendor) return

  try {
    const { error } = await supabase
      .from('vendors')
      .delete()
      .eq('id', deleteModal.value.vendor.id)

    if (error) throw error

    // Remove from local state
    vendors.value = vendors.value.filter(v => v.id !== deleteModal.value.vendor?.id)

    deleteModal.value.show = false
    deleteModal.value.vendor = null
  } catch (error) {
    console.error('Error deleting vendor:', error)
    alert('Failed to delete vendor')
  }
}

// Fetch on mount
onMounted(() => {
  fetchVendors()
})
</script>
