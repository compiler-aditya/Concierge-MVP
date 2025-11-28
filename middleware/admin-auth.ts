export default defineNuxtRouteMiddleware((to, from) => {
  // Only run on client-side
  if (process.server) return

  // Check if user is authenticated
  const isAuthenticated = sessionStorage.getItem('admin_authenticated')
  const authTime = sessionStorage.getItem('admin_auth_time')

  // Check if session is still valid (24 hours)
  const isSessionValid = authTime && (Date.now() - parseInt(authTime)) < 86400000

  if (!isAuthenticated || !isSessionValid) {
    // Clear invalid session
    sessionStorage.removeItem('admin_authenticated')
    sessionStorage.removeItem('admin_auth_time')

    // Redirect to login
    return navigateTo('/admin/login')
  }
})
