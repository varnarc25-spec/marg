# Recharge & Bills - Feature Implementation Document

## Overview
A comprehensive bill payment and recharge module inspired by Bharat Connect (BBPS) powered apps. This feature allows users to pay bills, recharge services, and manage recurring payments from a single screen.

---

## Screen Structure

### Header
- Back navigation arrow (left)
- Title: "Recharge & Bills"
- Help icon (right)
- **My Bills** button (top right) — shows user's saved billers and recent transactions

---

## Categories & Items

### 1. Suggested for you *(Personalized - Dynamic)*
> Dynamically populated based on user's recent transactions and usage patterns.

| # | Item | Icon | Badge | Priority |
|---|------|------|-------|----------|
| 1 | Book Cylinder | Gas cylinder | - | Dynamic |
| 2 | Mobile Postpaid | Mobile phone | - | Dynamic |
| 3 | Get SIM | SIM card | `Prepaid` | Dynamic |
| 4 | FASTag Recharge | FASTag | - | Dynamic |

**Implementation Notes:**
- Max 4 items displayed
- Algorithm: Show top 4 most frequently used services by the user
- Fallback for new users: Show most popular services nationally
- Layout: Single row, 4 columns in a card container

---

### 2. Recharges *(8 items)*

| # | Item | Icon | BBPS Category | Priority | Phase |
|---|------|------|---------------|----------|-------|
| 1 | Mobile Recharge | Lightning bolt in phone | Prepaid Mobile | **Mandatory** | Phase 1 |
| 2 | DTH | Satellite dish | DTH | **Mandatory** | Phase 1 |
| 3 | International Roaming | Globe with signal | - | Medium | Phase 2 |
| 4 | Google Play | Google Play logo | - | Medium | Phase 2 |
| 5 | NCMC Recharge | NCMC card | - | Medium | Phase 2 |
| 6 | FASTag Recharge | FASTag icon | FASTag | **High** | Phase 1 |
| 7 | Cable TV | TV screen | Cable TV | Medium | Phase 2 |
| 8 | Apple Store | Apple logo | - | Medium | Phase 2 |

**Layout:** 4 columns x 2 rows grid

---

### 3. Promotional Banner *(Dynamic)*

| Element | Content |
|---------|---------|
| Text | "Save ₹10 in 24K gold daily!" |
| Subtext | "Trusted by over 1.5Cr Indians" |
| Image | Gold coin/pot icon (right-aligned) |
| Action | Navigate to Gold investment screen |

**Implementation Notes:**
- Banner fetched from backend (remote config)
- Dismissible by user
- Can be used for cross-selling (Gold, Insurance, etc.)

---

### 4. Utilities *(10 items)*

| # | Item | Icon | BBPS Category | Priority | Phase |
|---|------|------|---------------|----------|-------|
| 1 | Electricity | Lightning bolt | Electricity | **Mandatory** | Phase 1 |
| 2 | Credit Card Bill | Credit card | Credit Card | **Mandatory** | Phase 1 |
| 3 | Loan Repayment | Money bag | Loan | **High** | Phase 1 |
| 4 | Book Cylinder | Gas cylinder | Gas Cylinder | **High** | Phase 1 |
| 5 | Mobile Postpaid | Mobile | Postpaid Mobile | **Mandatory** | Phase 1 |
| 6 | Broadband/Landline | Router | Broadband/Landline | **High** | Phase 1 |
| 7 | Piped Gas | Gas flame | Piped Gas | Medium | Phase 2 |
| 8 | Water | Water drop | Water | Medium | Phase 2 |
| 9 | Prepaid Meter | Meter | Prepaid Electricity | Medium | Phase 2 |
| 10 | Education Fee | Graduation cap | Education Fee | Medium | Phase 2 |

**Layout:** 4 columns x 3 rows grid (last row has 2 items)

---

### 5. Housing & Society *(4 items)*

| # | Item | Icon | BBPS Category | Priority | Phase |
|---|------|------|---------------|----------|-------|
| 1 | Municipal Tax | Building | Municipal Tax | Medium | Phase 2 |
| 2 | Rentals | House with key | Rental | Medium | Phase 2 |
| 3 | Clubs & Associations | Group of people | Club/Association | Low | Phase 3 |
| 4 | Apartment | Apartment building | Housing Society | Medium | Phase 2 |

**Layout:** 4 columns x 1 row grid

---

### 6. Others *(8 items)*

| # | Item | Icon | BBPS Category | Priority | Phase |
|---|------|------|---------------|----------|-------|
| 1 | EV Recharge | EV plug | - | Low | Phase 3 |
| 2 | Donation | Hands giving | - | Low | Phase 3 |
| 3 | Devotion | Temple | - | Low | Phase 3 |
| 4 | LIC/Insurance | Shield | Insurance | Medium | Phase 2 |
| 5 | NPS Contribution | Retirement | NPS | Low | Phase 3 |
| 6 | Subscription | Play button | Subscription | Low | Phase 3 |
| 7 | eChallan | Traffic sign | eChallan | Medium | Phase 2 |
| 8 | Get SIM | SIM card (`Prepaid` badge) | - | Low | Phase 3 |

**Layout:** 4 columns x 2 rows grid

---

### 7. Offers for You *(Dynamic - Horizontal Scroll)*

| # | Card | Content | CTA |
|---|------|---------|-----|
| 1 | Jio 5G Offer | "Best offer for you — Get Jio SIM & Get Free AI Benefits worth ₹35,100" | Tap to view |
| 2 | Cashback Offer | "Get exciting offers — 3% cashback on E-vouchers after recharge" | Tap to view |

**Implementation Notes:**
- Horizontal scrollable card list
- Cards fetched from backend
- Each card has: image, title, description, deep link
- Max 5 cards

---

## Phased Rollout Plan

### Phase 1 — MVP (Core BBPS Services)
**Timeline: 4–6 weeks**

Items (11 total):
- Mobile Recharge, DTH, FASTag Recharge
- Electricity, Credit Card Bill, Loan Repayment, Book Cylinder, Mobile Postpaid, Broadband/Landline
- My Bills, Suggested for You (hardcoded)

### Phase 2 — Expansion
**Timeline: 4–6 weeks after Phase 1**

Items (9 additional):
- International Roaming, Google Play, NCMC Recharge, Cable TV, Apple Store
- Piped Gas, Water, Prepaid Meter, Education Fee
- Municipal Tax, Rentals, Apartment
- LIC/Insurance, eChallan
- Promotional Banner, Offers section

### Phase 3 — Full Feature
**Timeline: 4–6 weeks after Phase 2**

Items (5 additional):
- EV Recharge, Donation, Devotion, NPS Contribution, Subscription, Get SIM
- Clubs & Associations
- Suggested for You (ML-based personalization)

---

## Data Model (Suggested)

```dart
class BillCategory {
  final String id;
  final String name;
  final int sortOrder;
  final List<BillService> services;
}

class BillService {
  final String id;
  final String name;
  final String iconUrl;
  final String? badge;          // e.g., "Prepaid"
  final String categoryId;
  final String? bbpsCategory;   // BBPS category code
  final String deepLink;        // Navigation route
  final bool isEnabled;
  final int sortOrder;
}

class PromoBanner {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String deepLink;
  final DateTime expiresAt;
}

class OfferCard {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String deepLink;
  final String? badgeText;
}
```

---

## UI/UX Specifications

| Property | Value |
|----------|-------|
| Background | Dark theme (#121212 or app theme) |
| Grid columns | 4 per row |
| Icon style | Outlined, circular background (subtle border) |
| Icon size | ~48dp diameter |
| Item spacing | 16dp horizontal, 20dp vertical |
| Category title | Bold, 16sp, left-aligned, white |
| Item label | Regular, 12sp, centered below icon, white/grey |
| Badge | Red background, white text, 10sp, positioned top-right of icon |
| Section spacing | 24dp between categories |
| Promo banner | Full-width card, rounded corners, horizontal layout |
| Offers cards | Horizontal scroll, card width ~160dp, rounded corners |

---

## API Endpoints Needed

| Endpoint | Method | Description |
|----------|--------|-------------|
| `GET /api/bills/categories` | GET | Fetch all categories and services |
| `GET /api/bills/suggested` | GET | Fetch personalized suggestions for user |
| `GET /api/bills/banners` | GET | Fetch promotional banners |
| `GET /api/bills/offers` | GET | Fetch offer cards |
| `GET /api/bills/my-bills` | GET | Fetch user's saved billers |
| `POST /api/bills/pay` | POST | Initiate bill payment |

---

## Dependencies / Integrations

| Integration | Purpose |
|-------------|---------|
| **Bharat Connect (BBPS)** | Core bill payment infrastructure |
| **Razorpay / Payment Gateway** | Payment processing |
| **Backend Remote Config** | Dynamic banners, offers, category ordering |
| **Analytics** | Track category clicks, payment completions |

---

## Total Item Count Summary

| Category | Items |
|----------|-------|
| Suggested for you | 4 (dynamic) |
| Recharges | 8 |
| Utilities | 10 |
| Housing & Society | 4 |
| Others | 8 |
| **Total unique services** | **~30** |
