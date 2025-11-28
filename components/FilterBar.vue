<template>
  <div class="filter-section animate-fade-in">
    <div class="container-custom">
      <!-- Search Bar -->
      <div class="relative mb-4">
        <Search class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" :size="20" />
        <input
          v-model="localFilters.searchQuery"
          type="text"
          placeholder="Search by name or location..."
          class="input pl-10"
          @input="onSearchChange"
        />
      </div>

      <!-- Filters Row -->
      <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
        <!-- Type Filter -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Type</label>
          <select
            v-model="localFilters.type"
            class="input"
            @change="onFilterChange"
          >
            <option value="all">All Services</option>
            <option value="tiffin">Tiffin Only</option>
            <option value="hostel">Hostel Only</option>
          </select>
        </div>

        <!-- Area Filter -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Area</label>
          <select
            v-model="localFilters.area"
            class="input"
            @change="onFilterChange"
          >
            <option value="">All Areas</option>
            <option value="Bhawarkuan">Bhawarkuan</option>
            <option value="Vijay Nagar">Vijay Nagar</option>
            <option value="Pipliyahana">Pipliyahana</option>
            <option value="Palasia">Palasia</option>
            <option value="Indore">Indore (General)</option>
          </select>
        </div>

        <!-- Price Range -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Max Price: ₹{{ localFilters.priceRange[1].toLocaleString('en-IN') }}
          </label>
          <input
            v-model.number="localFilters.priceRange[1]"
            type="range"
            min="1000"
            max="15000"
            step="500"
            class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-primary-500"
            @input="onFilterChange"
          />
          <div class="flex justify-between text-xs text-gray-500 mt-1">
            <span>₹1,000</span>
            <span>₹15,000</span>
          </div>
        </div>
      </div>

      <!-- Active Filters Summary -->
      <div v-if="hasActiveFilters" class="mt-4 flex items-center gap-2 flex-wrap">
        <span class="text-sm text-gray-600">Active filters:</span>

        <button
          v-if="localFilters.type !== 'all'"
          class="text-xs bg-primary-100 text-primary-700 px-3 py-1 rounded-full flex items-center gap-1 hover:bg-primary-200"
          @click="clearFilter('type')"
        >
          {{ localFilters.type }}
          <X :size="14" />
        </button>

        <button
          v-if="localFilters.area"
          class="text-xs bg-primary-100 text-primary-700 px-3 py-1 rounded-full flex items-center gap-1 hover:bg-primary-200"
          @click="clearFilter('area')"
        >
          {{ localFilters.area }}
          <X :size="14" />
        </button>

        <button
          v-if="localFilters.priceRange[1] < 15000"
          class="text-xs bg-primary-100 text-primary-700 px-3 py-1 rounded-full flex items-center gap-1 hover:bg-primary-200"
          @click="clearFilter('price')"
        >
          Under ₹{{ localFilters.priceRange[1].toLocaleString('en-IN') }}
          <X :size="14" />
        </button>

        <button
          class="text-xs text-gray-600 underline hover:text-gray-800"
          @click="clearAllFilters"
        >
          Clear all
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Search, X } from 'lucide-vue-next'
import type { FilterOptions } from '~/types'

const props = defineProps<{
  modelValue: FilterOptions
}>()

const emit = defineEmits<{
  'update:modelValue': [value: FilterOptions]
}>()

const localFilters = ref<FilterOptions>({ ...props.modelValue })

// Debounced search
let searchTimeout: NodeJS.Timeout
const onSearchChange = () => {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    emit('update:modelValue', { ...localFilters.value })
  }, 300)
}

const onFilterChange = () => {
  emit('update:modelValue', { ...localFilters.value })
}

const hasActiveFilters = computed(() => {
  return (
    localFilters.value.type !== 'all' ||
    localFilters.value.area !== '' ||
    localFilters.value.priceRange[1] < 15000 ||
    localFilters.value.searchQuery !== ''
  )
})

const clearFilter = (filterType: string) => {
  switch (filterType) {
    case 'type':
      localFilters.value.type = 'all'
      break
    case 'area':
      localFilters.value.area = ''
      break
    case 'price':
      localFilters.value.priceRange[1] = 15000
      break
  }
  emit('update:modelValue', { ...localFilters.value })
}

const clearAllFilters = () => {
  localFilters.value = {
    area: '',
    priceRange: [0, 15000],
    type: 'all',
    searchQuery: ''
  }
  emit('update:modelValue', { ...localFilters.value })
}

// Watch for external changes
watch(() => props.modelValue, (newValue) => {
  localFilters.value = { ...newValue }
}, { deep: true })
</script>
