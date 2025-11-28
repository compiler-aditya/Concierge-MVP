<template>
  <NuxtLink
    :to="`/vendor/${vendor.id}`"
    class="card block hover:scale-[1.02] transition-transform duration-200 cursor-pointer"
  >
    <!-- Image -->
    <div class="relative h-48 bg-gray-200 overflow-hidden">
      <img
        v-if="vendor.image_url"
        :src="vendor.image_url"
        :alt="vendor.name"
        class="w-full h-full object-cover"
        loading="lazy"
      />
      <div
        v-else
        class="w-full h-full flex items-center justify-center bg-gradient-to-br from-primary-400 to-primary-600"
      >
        <component :is="vendorIcon" class="w-16 h-16 text-white opacity-50" />
      </div>

      <!-- Verified Badge -->
      <div
        v-if="vendor.is_verified"
        class="absolute top-3 right-3 badge badge-verified flex items-center gap-1 shadow-lg"
      >
        <CheckCircle :size="16" />
        <span>Verified</span>
      </div>

      <!-- Type Badge -->
      <div class="absolute top-3 left-3 bg-white/90 backdrop-blur-sm px-3 py-1 rounded-full text-xs font-semibold text-gray-700 shadow-lg capitalize">
        {{ vendor.type }}
      </div>
    </div>

    <!-- Content -->
    <div class="p-4">
      <!-- Vendor Name -->
      <h3 class="text-lg font-bold text-gray-900 mb-2 line-clamp-1">
        {{ vendor.name }}
      </h3>

      <!-- Location -->
      <div class="flex items-center gap-2 text-gray-600 mb-3">
        <MapPin :size="16" class="flex-shrink-0" />
        <span class="text-sm line-clamp-1">{{ vendor.area }}</span>
      </div>

      <!-- Description -->
      <p v-if="vendor.description" class="text-sm text-gray-600 mb-3 line-clamp-2">
        {{ vendor.description }}
      </p>

      <!-- Amenities (for hostels) or highlights -->
      <div v-if="vendor.amenities && vendor.amenities.length > 0" class="flex flex-wrap gap-2 mb-3">
        <span
          v-for="(amenity, index) in vendor.amenities.slice(0, 3)"
          :key="index"
          class="text-xs bg-gray-100 text-gray-700 px-2 py-1 rounded-md"
        >
          {{ amenity }}
        </span>
        <span
          v-if="vendor.amenities.length > 3"
          class="text-xs text-gray-500"
        >
          +{{ vendor.amenities.length - 3 }} more
        </span>
      </div>

      <!-- Footer: Price & Rating -->
      <div class="flex items-center justify-between pt-3 border-t border-gray-100">
        <!-- Price -->
        <div class="flex flex-col">
          <span class="text-2xl font-bold text-primary-600">
            ₹{{ vendor.monthly_price.toLocaleString('en-IN') }}
          </span>
          <span class="text-xs text-gray-500">per month</span>
        </div>

        <!-- Rating -->
        <div class="badge badge-rating flex items-center gap-1">
          <Star :size="16" class="fill-current" />
          <span class="font-semibold">{{ vendor.rating }}</span>
        </div>
      </div>
    </div>
  </NuxtLink>
</template>

<script setup lang="ts">
import { MapPin, Star, CheckCircle, UtensilsCrossed, Home } from 'lucide-vue-next'
import type { Vendor } from '~/types'

const props = defineProps<{
  vendor: Vendor
}>()

// Determine icon based on vendor type
const vendorIcon = computed(() => {
  return props.vendor.type === 'hostel' ? Home : UtensilsCrossed
})
</script>

<style scoped>
/* Additional scoped styles if needed */
</style>
