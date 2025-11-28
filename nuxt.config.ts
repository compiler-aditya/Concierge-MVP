// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },

  // Modules
  modules: [
    '@nuxtjs/tailwindcss',
    '@nuxtjs/supabase'
  ],

  // Supabase configuration
  supabase: {
    redirect: false, // We'll handle auth redirects manually
    redirectOptions: {
      login: '/admin/login',
      callback: '/admin',
      exclude: ['/', '/vendor/*']
    }
  },

  // App configuration
  app: {
    head: {
      title: 'Tiffin & Hostel Directory - Indore',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        {
          name: 'description',
          content: 'Find verified tiffin services and hostels in Indore. Book trial meals via WhatsApp.'
        },
        {
          name: 'keywords',
          content: 'tiffin service indore, hostel indore, pg indore, food delivery, student meals'
        },
        { property: 'og:title', content: 'Tiffin & Hostel Directory - Indore' },
        {
          property: 'og:description',
          content: 'Find verified tiffin services and hostels in Indore'
        },
        { property: 'og:type', content: 'website' }
      ],
      link: [
        { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
      ]
    }
  },

  // CSS
  css: ['~/assets/css/main.css'],

  // Tailwind configuration
  tailwindcss: {
    cssPath: '~/assets/css/main.css',
    configPath: 'tailwind.config.js',
    exposeConfig: false,
    viewer: true
  },

  // Runtime config (for environment variables)
  runtimeConfig: {
    public: {
      supabaseUrl: process.env.SUPABASE_URL,
      supabaseKey: process.env.SUPABASE_KEY,
      adminWhatsapp: process.env.ADMIN_WHATSAPP || '+919876543210', // Your admin WhatsApp number
      adminPin: process.env.ADMIN_PIN || '1234' // Simple PIN for MVP
    }
  }
})
