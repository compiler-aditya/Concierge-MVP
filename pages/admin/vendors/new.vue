<template>
  <div class="min-h-screen bg-gray-50 pb-12">
    <!-- Header -->
    <header class="bg-white shadow-sm sticky top-0 z-40">
      <div class="container-custom py-4">
        <NuxtLink to="/admin/vendors" class="text-sm text-gray-600 hover:text-primary-600 mb-2 inline-flex items-center gap-1">
          <ArrowLeft :size="16" />
          Back to Vendors
        </NuxtLink>
        <h1 class="text-2xl font-bold text-gray-900">Add New Vendor</h1>
      </div>
    </header>

    <!-- Form -->
    <main class="container-custom py-8">
      <form @submit.prevent="handleSubmit" class="max-w-3xl mx-auto">
        <div class="card p-6 mb-6">
          <h2 class="text-xl font-bold text-gray-900 mb-4">Basic Information</h2>

          <div class="space-y-4">
            <!-- Vendor Name -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Vendor Name *
              </label>
              <input
                v-model="form.name"
                type="text"
                class="input"
                placeholder="e.g., Maa Ka Swad Tiffin"
                required
              />
            </div>

            <!-- Type -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Type *
              </label>
              <select v-model="form.type" class="input" required>
                <option value="">Select type</option>
                <option value="tiffin">Tiffin Service</option>
                <option value="hostel">Hostel</option>
                <option value="both">Both</option>
              </select>
            </div>

            <!-- Location & Area -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  Location *
                </label>
                <input
                  v-model="form.location"
                  type="text"
                  class="input"
                  placeholder="e.g., Shop 12, Bhawarkuan Square"
                  required
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  Area *
                </label>
                <select v-model="form.area" class="input" required>
                  <option value="">Select area</option>
                  <option value="Bhawarkuan">Bhawarkuan</option>
                  <option value="Vijay Nagar">Vijay Nagar</option>
                  <option value="Pipliyahana">Pipliyahana</option>
                  <option value="Palasia">Palasia</option>
                  <option value="Indore">Indore (General)</option>
                  <option value="Other">Other</option>
                </select>
              </div>
            </div>

            <!-- Price & Rating -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  Monthly Price (₹) *
                </label>
                <input
                  v-model.number="form.monthly_price"
                  type="number"
                  class="input"
                  placeholder="3500"
                  min="0"
                  required
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  Rating (0-5)
                </label>
                <input
                  v-model.number="form.rating"
                  type="number"
                  class="input"
                  placeholder="4.5"
                  min="0"
                  max="5"
                  step="0.1"
                />
              </div>
            </div>

            <!-- Phone & WhatsApp -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  Phone Number *
                </label>
                <input
                  v-model="form.phone"
                  type="tel"
                  class="input"
                  placeholder="+919876543210"
                  required
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  WhatsApp Number
                </label>
                <input
                  v-model="form.whatsapp_number"
                  type="tel"
                  class="input"
                  placeholder="+919876543210 (optional)"
                />
              </div>
            </div>

            <!-- Description -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Description
              </label>
              <textarea
                v-model="form.description"
                class="input min-h-24"
                placeholder="Brief description about the service..."
                rows="3"
              ></textarea>
            </div>

            <!-- Image URL -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Image URL
              </label>
              <input
                v-model="form.image_url"
                type="url"
                class="input"
                placeholder="https://example.com/image.jpg"
              />
              <p class="text-xs text-gray-500 mt-1">
                Use Unsplash or upload to a CDN
              </p>
            </div>

            <!-- Address -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Full Address
              </label>
              <textarea
                v-model="form.address"
                class="input min-h-20"
                placeholder="Complete address with landmarks..."
                rows="2"
              ></textarea>
            </div>

            <!-- Amenities/Features -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Amenities/Features
              </label>
              <input
                v-model="amenitiesInput"
                type="text"
                class="input"
                placeholder="Type and press Enter to add"
                @keydown.enter.prevent="addAmenity"
              />
              <div v-if="form.amenities.length > 0" class="flex flex-wrap gap-2 mt-2">
                <span
                  v-for="(amenity, index) in form.amenities"
                  :key="index"
                  class="badge bg-primary-100 text-primary-800 flex items-center gap-1"
                >
                  {{ amenity }}
                  <button type="button" @click="removeAmenity(index)">
                    <X :size="14" />
                  </button>
                </span>
              </div>
            </div>

            <!-- Verified & Active -->
            <div class="flex gap-6">
              <label class="flex items-center gap-2 cursor-pointer">
                <input
                  v-model="form.is_verified"
                  type="checkbox"
                  class="w-4 h-4 text-primary-600 rounded focus:ring-primary-500"
                />
                <span class="text-sm text-gray-700">Verified Vendor</span>
              </label>
              <label class="flex items-center gap-2 cursor-pointer">
                <input
                  v-model="form.is_active"
                  type="checkbox"
                  class="w-4 h-4 text-primary-600 rounded focus:ring-primary-500"
                />
                <span class="text-sm text-gray-700">Active (Visible to users)</span>
              </label>
            </div>
          </div>
        </div>

        <!-- Submit Buttons -->
        <div class="flex gap-3">
          <NuxtLink to="/admin/vendors" class="btn-secondary flex-1">
            Cancel
          </NuxtLink>
          <button
            type="submit"
            class="btn-primary flex-1"
            :disabled="loading"
          >
            <span v-if="!loading">Create Vendor</span>
            <span v-else class="flex items-center justify-center gap-2">
              <Loader :size="20" class="animate-spin" />
              Creating...
            </span>
          </button>
        </div>
      </form>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ArrowLeft, X, Loader } from 'lucide-vue-next'

definePageMeta({
  middleware: 'admin-auth'
})

const router = useRouter()
const supabase = useSupabaseClient()

// Form state
const form = ref({
  name: '',
  type: '' as 'tiffin' | 'hostel' | 'both' | '',
  location: '',
  area: '',
  monthly_price: 0,
  rating: 4.0,
  phone: '',
  whatsapp_number: '',
  description: '',
  image_url: '',
  address: '',
  amenities: [] as string[],
  is_verified: false,
  is_active: true
})

const amenitiesInput = ref('')
const loading = ref(false)

// Add amenity
const addAmenity = () => {
  const value = amenitiesInput.value.trim()
  if (value && !form.value.amenities.includes(value)) {
    form.value.amenities.push(value)
    amenitiesInput.value = ''
  }
}

// Remove amenity
const removeAmenity = (index: number) => {
  form.value.amenities.splice(index, 1)
}

// Submit form
const handleSubmit = async () => {
  loading.value = true

  try {
    // If WhatsApp not provided, use phone number
    if (!form.value.whatsapp_number) {
      form.value.whatsapp_number = form.value.phone
    }

    const { data, error } = await supabase
      .from('vendors')
      .insert([{
        ...form.value,
        amenities: form.value.amenities
      }])
      .select()
      .single()

    if (error) throw error

    // Success - redirect to vendor page
    router.push(`/vendor/${data.id}`)
  } catch (error) {
    console.error('Error creating vendor:', error)
    alert('Failed to create vendor. Please try again.')
  } finally {
    loading.value = false
  }
}
</script>
