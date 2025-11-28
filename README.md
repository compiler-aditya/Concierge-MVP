# 🍛 Tiffin & Hostel Concierge MVP - Indore

A hyperlocal directory platform for verified tiffin services and hostels in Indore, India. Built as a Concierge MVP to validate demand, collect user data, and generate leads via WhatsApp without complex payment infrastructure.

## 🎯 Key Features

- **Public Directory**: Browse verified tiffin services and hostels with filtering by location, price, and type
- **Vendor Detail Pages**: View menus, amenities, photos, and complete information
- **Smart Concierge System**:
  - Track analytics silently when users click "Book Trial"
  - Redirect to WhatsApp with pre-filled message to YOUR admin number
  - No direct vendor contact - you control all leads
- **Admin Dashboard**:
  - Real-time analytics and conversion tracking
  - Vendor performance metrics
  - Simple PIN-based authentication
  - Add/Edit/Manage vendors

## 🛠️ Tech Stack

- **Framework**: Nuxt 3 (Vue 3) - SSR for SEO
- **Styling**: Tailwind CSS - Mobile-first responsive design
- **Backend**: Supabase - PostgreSQL database with real-time subscriptions
- **Icons**: Lucide Vue Next
- **Analytics**: Custom event tracking system

## 📋 Prerequisites

- Node.js 18+ and npm/yarn
- Supabase account (free tier works)
- WhatsApp Business number for leads

## 🚀 Quick Start

### 1. Clone & Install

```bash
git clone <your-repo-url>
cd Concierge-MVP
npm install
```

### 2. Set Up Supabase

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to SQL Editor in your Supabase dashboard
3. Run the schema:

```bash
# Copy and paste the contents of supabase/schema.sql
# Then run supabase/seed.sql for sample data
```

4. Get your API credentials:
   - Go to Settings > API
   - Copy the `Project URL` and `anon/public` key

### 3. Configure Environment

Create a `.env` file in the root:

```bash
cp .env.example .env
```

Edit `.env` with your credentials:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-anon-public-key-here
ADMIN_WHATSAPP=+919876543210  # Your WhatsApp number
ADMIN_PIN=1234                # Your admin dashboard PIN
```

### 4. Run Development Server

```bash
npm run dev
```

Visit `http://localhost:3000` 🎉

## 📁 Project Structure

```
Concierge-MVP/
├── assets/
│   └── css/
│       └── main.css              # Tailwind styles & custom CSS
├── components/
│   ├── VendorCard.vue            # Vendor card component
│   └── FilterBar.vue             # Search & filter component
├── composables/
│   └── useAnalytics.ts           # Analytics tracking logic
├── middleware/
│   └── admin-auth.ts             # Admin authentication guard
├── pages/
│   ├── index.vue                 # Directory homepage
│   ├── vendor/
│   │   └── [id].vue              # Vendor detail page
│   └── admin/
│       ├── login.vue             # Admin login
│       ├── index.vue             # Admin dashboard
│       └── vendors/
│           ├── index.vue         # Vendor list
│           └── new.vue           # Add vendor form
├── supabase/
│   ├── schema.sql                # Database schema
│   └── seed.sql                  # Sample data
├── types/
│   └── index.ts                  # TypeScript definitions
├── nuxt.config.ts                # Nuxt configuration
├── tailwind.config.js            # Tailwind configuration
└── package.json
```

## 🎨 Design System

### Colors

- **Primary Orange**: `#f97316` (Hunger/Energy theme)
- **Success Green**: `#22c55e` (WhatsApp brand)
- **Neutral Gray**: `#6b7280` (Text & backgrounds)

### Key Components

All components are in the `components/` directory and use Tailwind utility classes for styling.

## 📊 How the Concierge Logic Works

### User Flow:
1. User browses directory → **Analytics: Page views tracked**
2. User clicks vendor → **Analytics: Vendor view logged**
3. User clicks "Book Trial Meal" → **Critical Step:**
   - Event logged to `analytics_events` table
   - WhatsApp link generated with vendor name
   - User redirected to YOUR WhatsApp (not vendor's)
   - You manually coordinate the booking

### Why This Approach?

- ✅ Validate demand before building complex booking system
- ✅ Build direct relationships with customers
- ✅ Understand customer needs through conversations
- ✅ Collect valuable analytics data
- ✅ No payment gateway needed yet

## 🔒 Admin Access

1. Visit `/admin/login`
2. Enter PIN (default: `1234` - **CHANGE THIS**)
3. Access dashboard to:
   - View lead analytics
   - Add/edit vendors
   - Track conversion rates

## 📱 Mobile Optimization

The app is **mobile-first** by design:
- All components responsive
- Touch-friendly buttons
- Optimized images
- Fast loading times

## 🔐 Security Notes (MVP Level)

**Current Implementation:**
- Simple PIN-based admin auth (session storage)
- Public read access to vendor data
- Analytics events insertable by anyone

**For Production, Add:**
- Proper authentication (Supabase Auth)
- Row-level security policies
- Rate limiting on analytics
- HTTPS only
- Environment-based PIN storage

## 📈 Analytics Events Tracked

| Event Type | Description |
|------------|-------------|
| `view_vendor` | User views vendor detail page |
| `click_order` | User clicks WhatsApp button |
| `search` | User searches vendors |
| `filter_used` | User applies filters |

View all analytics in the admin dashboard at `/admin`.

## 🚢 Deployment

### Vercel (Recommended)

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel

# Add environment variables in Vercel dashboard
```

### Other Platforms

Works with any Node.js hosting:
- Netlify
- Railway
- DigitalOcean App Platform

## 🎯 Next Steps (Post-MVP)

Once you validate demand:

1. **Add Payments**: Integrate Razorpay/Stripe
2. **User Accounts**: Let users save favorites
3. **Advanced Booking**: Calendar-based meal planning
4. **Vendor Portal**: Let vendors update their own info
5. **Reviews System**: Collect user feedback
6. **Mobile App**: React Native version

## 🤝 Contributing

This is an MVP project. Focus on:
- Bug fixes
- Performance improvements
- Mobile UX enhancements

## 📄 License

MIT License - See LICENSE file

## 🆘 Troubleshooting

### Supabase Connection Issues
- Verify your `SUPABASE_URL` and `SUPABASE_KEY`
- Check Supabase project status
- Ensure RLS policies are set up correctly

### Admin Login Not Working
- Check `ADMIN_PIN` in `.env`
- Clear browser session storage
- Verify middleware is working

### WhatsApp Redirect Not Working
- Ensure `ADMIN_WHATSAPP` is in format: `+919876543210`
- Check browser pop-up blocker
- Test on mobile device

## 📞 Support

For issues specific to this MVP, check the code comments or open an issue.

---

Built with ❤️ for the Indore startup ecosystem

**Remember**: This is a Concierge MVP. The goal is to learn and validate, not to build the perfect product on day one!
