<template>
  <div class="min-h-screen bg-gradient-to-br from-primary-500 to-primary-700 flex items-center justify-center px-4">
    <div class="card max-w-md w-full p-8 animate-fade-in">
      <div class="text-center mb-8">
        <div class="inline-flex items-center justify-center w-16 h-16 bg-primary-100 rounded-full mb-4">
          <Lock :size="32" class="text-primary-600" />
        </div>
        <h1 class="text-2xl font-bold text-gray-900">Admin Login</h1>
        <p class="text-gray-600 mt-2">Enter your PIN to access the dashboard</p>
      </div>

      <form @submit.prevent="handleLogin">
        <div class="mb-6">
          <label for="pin" class="block text-sm font-medium text-gray-700 mb-2">
            Admin PIN
          </label>
          <input
            id="pin"
            v-model="pin"
            type="password"
            inputmode="numeric"
            pattern="[0-9]*"
            maxlength="6"
            placeholder="Enter your PIN"
            class="input text-center text-2xl tracking-widest"
            :class="{ 'border-red-500': error }"
            required
            autofocus
          />
          <p v-if="error" class="text-red-600 text-sm mt-2">{{ error }}</p>
        </div>

        <button
          type="submit"
          class="btn-primary w-full"
          :disabled="loading || pin.length < 4"
        >
          <span v-if="!loading">Access Dashboard</span>
          <span v-else class="flex items-center justify-center gap-2">
            <Loader :size="20" class="animate-spin" />
            Verifying...
          </span>
        </button>
      </form>

      <div class="mt-6 p-4 bg-blue-50 rounded-lg">
        <p class="text-sm text-blue-900">
          <strong>Note:</strong> This is a simple PIN-based authentication for MVP purposes.
          For production, implement proper authentication.
        </p>
      </div>

      <div class="mt-6 text-center">
        <NuxtLink to="/" class="text-sm text-gray-600 hover:text-primary-600 transition-colors">
          ← Back to Directory
        </NuxtLink>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Lock, Loader } from 'lucide-vue-next'

definePageMeta({
  layout: false
})

const router = useRouter()
const config = useRuntimeConfig()

const pin = ref('')
const loading = ref(false)
const error = ref('')

const handleLogin = async () => {
  loading.value = true
  error.value = ''

  try {
    // Simple PIN verification for MVP
    const adminPin = config.public.adminPin || '1234'

    // Simulate a delay for security
    await new Promise(resolve => setTimeout(resolve, 500))

    if (pin.value === adminPin) {
      // Store authentication in session storage
      sessionStorage.setItem('admin_authenticated', 'true')
      sessionStorage.setItem('admin_auth_time', Date.now().toString())

      // Redirect to dashboard
      router.push('/admin')
    } else {
      error.value = 'Invalid PIN. Please try again.'
      pin.value = ''
    }
  } catch (err) {
    error.value = 'An error occurred. Please try again.'
  } finally {
    loading.value = false
  }
}

// Auto-submit on 4-6 digit PIN
watch(pin, (newPin) => {
  error.value = ''
  if (newPin.length >= 4 && newPin.length <= 6) {
    // Auto-submit after a short delay
    setTimeout(() => {
      if (pin.value === newPin) {
        handleLogin()
      }
    }, 300)
  }
})
</script>
