# 🎯 Complete Setup Guide - Step by Step

This guide will help you set up your Tiffin & Hostel Concierge MVP from scratch, even if you're not a developer.

## ⏱️ Estimated Time: 30 minutes

---

## Step 1: Set Up Supabase (Database) - 10 minutes

### 1.1 Create Account
1. Go to [supabase.com](https://supabase.com)
2. Click "Start your project"
3. Sign up with GitHub or email
4. Verify your email

### 1.2 Create Project
1. Click "New Project"
2. Choose your organization (or create new)
3. Fill in:
   - **Project Name**: `tiffin-concierge-mvp`
   - **Database Password**: Save this securely!
   - **Region**: Choose closest to India (Singapore recommended)
4. Click "Create new project"
5. Wait 2-3 minutes for setup

### 1.3 Run Database Schema
1. In your Supabase dashboard, click "SQL Editor" in the left sidebar
2. Click "New Query"
3. Open the file `supabase/schema.sql` from this project
4. Copy ALL the content
5. Paste it into the SQL Editor
6. Click "Run" (or press Ctrl+Enter)
7. You should see "Success. No rows returned"

### 1.4 Add Sample Data (Optional but Recommended)
1. Click "New Query" again
2. Open the file `supabase/seed.sql`
3. Copy and paste the content
4. Click "Run"
5. You should see sample vendors in your database

### 1.5 Get API Credentials
1. Click "Settings" (gear icon) in the sidebar
2. Click "API"
3. Find these two values:
   - **Project URL**: Something like `https://abcdefgh.supabase.co`
   - **anon public key**: Long string starting with `eyJ...`
4. **Keep these safe** - you'll need them next!

---

## Step 2: Configure Your Project - 5 minutes

### 2.1 Install Dependencies
Open your terminal in the project folder and run:

```bash
npm install
```

This will install all required packages (takes 2-3 minutes).

### 2.2 Set Up Environment Variables
1. Copy the example file:
   ```bash
   cp .env.example .env
   ```

2. Open `.env` in a text editor

3. Fill in your details:
   ```env
   # Paste your Supabase URL from Step 1.5
   SUPABASE_URL=https://your-project.supabase.co

   # Paste your Supabase anon key from Step 1.5
   SUPABASE_KEY=eyJhbGc...your-long-key-here

   # Your WhatsApp number (include country code)
   ADMIN_WHATSAPP=+919876543210

   # Your admin dashboard PIN (change this!)
   ADMIN_PIN=1234
   ```

4. Save the file

**⚠️ Important**: Never share your `.env` file or commit it to GitHub!

---

## Step 3: Run Your App - 2 minutes

### 3.1 Start Development Server
In your terminal, run:

```bash
npm run dev
```

You should see:
```
Nuxt 3.x.x
  ➜ Local:   http://localhost:3000/
```

### 3.2 Open in Browser
1. Open your browser
2. Go to `http://localhost:3000`
3. You should see your directory homepage! 🎉

---

## Step 4: Test Everything - 5 minutes

### 4.1 Test Public Directory
- [ ] Browse vendors on homepage
- [ ] Try filtering by area
- [ ] Try adjusting price range
- [ ] Click on a vendor card

### 4.2 Test Vendor Page
- [ ] View vendor details
- [ ] See the menu (for tiffin services)
- [ ] Click "Book Trial Meal via WhatsApp"
- [ ] Verify it opens WhatsApp with pre-filled message

### 4.3 Test Admin Dashboard
1. Go to `http://localhost:3000/admin/login`
2. Enter your PIN (default: `1234`)
3. Check:
   - [ ] View analytics stats
   - [ ] See top performing vendors
   - [ ] Click "Add New Vendor"
   - [ ] Fill in vendor details
   - [ ] Submit and verify it appears

---

## Step 5: Add Your Real Data - 8 minutes

### 5.1 Add First Real Vendor
1. Go to `/admin/vendors/new`
2. Fill in all fields:
   - **Name**: e.g., "Shyam's Tiffin Service"
   - **Type**: Choose from dropdown
   - **Location**: Specific address
   - **Area**: Choose from dropdown
   - **Monthly Price**: In rupees (e.g., 3500)
   - **Phone**: Vendor's phone
   - **Description**: 2-3 sentences
   - **Image URL**: Use Unsplash for free images:
     - Go to [unsplash.com](https://unsplash.com)
     - Search "indian food" or "hostel"
     - Right-click image → Copy image address
   - **Amenities**: Type and press Enter for each
   - Check "Verified" and "Active"
3. Click "Create Vendor"

### 5.2 Test Your Vendor
1. Go back to homepage
2. Find your vendor
3. Click to view details
4. Test WhatsApp button

---

## Step 6: Deploy to Production - 10 minutes

### 6.1 Deploy to Vercel (Free)

1. Install Vercel CLI:
   ```bash
   npm install -g vercel
   ```

2. Login to Vercel:
   ```bash
   vercel login
   ```

3. Deploy:
   ```bash
   vercel
   ```

4. Follow prompts (just press Enter for defaults)

5. Add environment variables in Vercel Dashboard:
   - Go to your project settings
   - Click "Environment Variables"
   - Add all variables from your `.env` file

6. Redeploy:
   ```bash
   vercel --prod
   ```

7. You'll get a URL like `https://your-project.vercel.app`

---

## 🎉 You're Live!

Your Concierge MVP is now running! Here's what to do next:

### Immediate Actions:
- [ ] Change your `ADMIN_PIN` to something secure
- [ ] Add 5-10 real vendors
- [ ] Share the link with test users
- [ ] Monitor analytics in admin dashboard

### First Week Goals:
- [ ] Get 50 vendor views
- [ ] Get 10 WhatsApp leads
- [ ] Collect feedback from users
- [ ] Add more vendors based on demand

---

## 🆘 Common Issues & Solutions

### Issue: "Can't connect to Supabase"
**Solution**: Double-check your `SUPABASE_URL` and `SUPABASE_KEY` in `.env`

### Issue: "No vendors showing"
**Solution**: Run the seed data SQL script again in Supabase

### Issue: "Admin login not working"
**Solution**:
- Check `ADMIN_PIN` in `.env`
- Clear browser cache
- Try incognito mode

### Issue: "WhatsApp not opening"
**Solution**:
- Check `ADMIN_WHATSAPP` format: `+919876543210`
- Try on mobile device (works better)

### Issue: "Images not loading"
**Solution**:
- Use direct image URLs from Unsplash
- Format: `https://images.unsplash.com/photo-...?w=800`

---

## 📞 Need Help?

1. Check the main `README.md` for technical details
2. Review code comments in the files
3. Check Supabase documentation: [supabase.com/docs](https://supabase.com/docs)
4. Check Nuxt documentation: [nuxt.com/docs](https://nuxt.com/docs)

---

## 🚀 Next Steps After Launch

Once you have validated demand (50+ leads):

1. **Enhance Admin**: Add bulk upload for vendors
2. **Add Reviews**: Let users rate vendors
3. **Build Mobile App**: React Native version
4. **Add Payments**: Integrate Razorpay
5. **Vendor Portal**: Let vendors manage their listings

---

**Good luck with your MVP! 🎯**

Remember: The goal is to validate demand, not build a perfect product. Ship fast, learn faster!
