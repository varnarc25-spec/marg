import 'package:flutter/material.dart';

/// A single departure date chip (day, weekday, optional tag e.g. Holiday).
class BusDepartureDate {
  const BusDepartureDate({
    required this.day,
    required this.weekday,
    this.tag,
  });

  final String day;
  final String weekday;
  final String? tag;
}

/// Partner offer card (bank, offer text, disclaimer, promo code).
class BusPartnerOffer {
  const BusPartnerOffer({
    required this.bankName,
    required this.offerTitle,
    required this.disclaimer,
    required this.promoCode,
    required this.gradientColors,
  });

  final String bankName;
  final String offerTitle;
  final String disclaimer;
  final String promoCode;
  final List<Color> gradientColors;
}

/// Exclusive feature
class BusExclusiveFeature {
  const BusExclusiveFeature({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

/// Travel blog card (title, button label).
class BusTravelBlog {
  const BusTravelBlog({
    required this.title,
    required this.buttonLabel,
  });

  final String title;
  final String buttonLabel;
}

/// Previous journey card data.
class BusPreviousJourney {
  const BusPreviousJourney({
    required this.operatorName,
    required this.fromCity,
    required this.fromTime,
    required this.toCity,
    required this.toTime,
    required this.travelDate,
  });

  final String operatorName;
  final String fromCity;
  final String fromTime;
  final String toCity;
  final String toTime;
  final String travelDate;
}

/// Recent search route (origin -> destination) for city search page.
class BusRecentRoute {
  const BusRecentRoute({required this.from, required this.to});

  final String from;
  final String to;
}

/// City near user location (closest to you).
class BusCityNearby {
  const BusCityNearby({
    required this.name,
    required this.state,
    required this.distanceKm,
  });

  final String name;
  final String state;
  final double distanceKm;
}

/// Popular city for grid on city search page.
class BusCityPopular {
  const BusCityPopular({required this.name, required this.state});

  final String name;
  final String state;
}

/// Single bus option for search results list.
class BusResultItem {
  const BusResultItem({
    required this.operatorName,
    required this.busType,
    this.rating,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
    required this.seatsLeft,
    this.discountTag,
    this.extraDiscountTag,
    this.busesAvailable,
  });

  final String operatorName;
  final String busType;
  final double? rating;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final int price;
  final int seatsLeft;
  final String? discountTag;
  final String? extraDiscountTag;
  final int? busesAvailable;
}

/// Sort option for bus results (Filter By - Sort By).
enum BusSortOption {
  recommended,
  mostPopular,
  cheapest,
  bestRated,
  earlyDeparture,
  lateDeparture,
}

// ——————— List data ———————

const List<BusDepartureDate> busDepartureDates = [
  BusDepartureDate(day: '3', weekday: 'Today', tag: 'Holiday'),
  BusDepartureDate(day: '4', weekday: 'Wed', tag: 'Holiday'),
  BusDepartureDate(day: '5', weekday: 'Thu'),
  BusDepartureDate(day: '6', weekday: 'Fri'),
  BusDepartureDate(day: '7', weekday: 'Sat'),
];

const busPreviousJourney = BusPreviousJourney(
  operatorName: 'BSRM Travels',
  fromCity: 'Bengaluru',
  fromTime: '8:45 PM',
  toCity: 'Rajampet',
  toTime: '5:45 AM',
  travelDate: 'Travelled on 31 Jan 26',
);

const List<BusPartnerOffer> busPartnerOffers = [
  BusPartnerOffer(
    bankName: 'Canara Bank',
    offerTitle: 'Flat 15% Off on Bus Tickets →',
    disclaimer: 'Valid on Credit Card Transactions • T&C Apply',
    promoCode: 'BUSCANARADC',
    gradientColors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
  ),
  BusPartnerOffer(
    bankName: 'PNB',
    offerTitle: 'Flat 15% Off on Bus Tickets →',
    disclaimer: 'Valid everyday on Credit Card Transactions • T&C Apply',
    promoCode: 'BUSPNB',
    gradientColors: [Color(0xFFE91E63), Color(0xFFAD1457)],
  ),
  BusPartnerOffer(
    bankName: 'RBL Bank',
    offerTitle: 'Flat 10% Off on Bus Tickets →',
    disclaimer: 'Valid Every Friday on Credit Card Transactions • T&C Apply',
    promoCode: 'BUSRBL',
    gradientColors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
  ),
];

const List<BusExclusiveFeature> busExclusiveFeatures = [
  BusExclusiveFeature(label: 'Best Price Guarantee', icon: Icons.thumb_up_rounded),
  BusExclusiveFeature(label: 'Free Cancellation', icon: Icons.verified_user_rounded),
  BusExclusiveFeature(label: 'Live Bus Tracking', icon: Icons.location_on_rounded),
  BusExclusiveFeature(label: 'Zero Conv Fee', icon: Icons.payments_rounded),
  BusExclusiveFeature(label: 'Instant Refunds', icon: Icons.refresh_rounded),
];

const List<BusTravelBlog> busTravelBlogs = [
  BusTravelBlog(title: 'Solo Bus Travel Tips & Guide', buttonLabel: 'Check Now'),
  BusTravelBlog(title: 'Top Places to Visit in Rajasthan', buttonLabel: 'Explore Now'),
  BusTravelBlog(title: 'Bus Travel Safe Booking Guide', buttonLabel: 'Know More'),
];

const List<BusRecentRoute> busRecentSearches = [
  BusRecentRoute(from: 'Tirupati', to: 'Rajampet'),
  BusRecentRoute(from: 'Arunachalam (Tiruvannamalai)', to: 'Tirupati'),
];

const List<BusCityNearby> busCitiesClosest = [
  BusCityNearby(name: 'Anandapura', state: 'Karnataka', distanceKm: 2.8),
  BusCityNearby(name: 'Bengaluru', state: 'Karnataka', distanceKm: 5.2),
  BusCityNearby(name: 'Whitefield', state: 'Karnataka', distanceKm: 8.1),
];

const List<BusCityPopular> busPopularCities = [
  BusCityPopular(name: 'Delhi', state: 'Delhi'),
  BusCityPopular(name: 'Mumbai', state: 'Maharashtra'),
  BusCityPopular(name: 'Bengaluru', state: 'Karnataka'),
  BusCityPopular(name: 'Chennai', state: 'Tamil Nadu'),
  BusCityPopular(name: 'Hyderabad', state: 'Telangana'),
  BusCityPopular(name: 'Kolkata', state: 'West Bengal'),
  BusCityPopular(name: 'Pune', state: 'Maharashtra'),
  BusCityPopular(name: 'Ahmedabad', state: 'Gujarat'),
  BusCityPopular(name: 'Jaipur', state: 'Rajasthan'),
  BusCityPopular(name: 'Lucknow', state: 'Uttar Pradesh'),
  BusCityPopular(name: 'Kochi', state: 'Kerala'),
  BusCityPopular(name: 'Tirupati', state: 'Andhra Pradesh'),
  BusCityPopular(name: 'Rajampet', state: 'Andhra Pradesh'),
  BusCityPopular(name: 'Coimbatore', state: 'Tamil Nadu'),
  BusCityPopular(name: 'Chandigarh', state: 'Chandigarh'),
  BusCityPopular(name: 'Indore', state: 'Madhya Pradesh'),
];

/// Mock bus search results for Tirupati - Rajampet.
const List<BusResultItem> busSearchResults = [
  BusResultItem(
    operatorName: 'APSRTC (Andhra Pradesh State Road Transport...)',
    busType: 'Govt Bus',
    busesAvailable: 5,
    departureTime: '06:00 AM',
    arrivalTime: '08:30 AM',
    duration: '02h 30m',
    price: 145,
    seatsLeft: 42,
    discountTag: '25% off for Senior Citizens',
  ),
  BusResultItem(
    operatorName: 'Ramana Tours & Travels',
    busType: 'AC Sleeper 2+1',
    rating: 3.3,
    departureTime: '09:00 PM',
    arrivalTime: '11:00 PM',
    duration: '02h 00m',
    price: 819,
    seatsLeft: 36,
    extraDiscountTag: 'Extra 10% Discount',
  ),
  BusResultItem(
    operatorName: 'Ramana Tours & Travels',
    busType: 'AC Sleeper 2+1',
    rating: 3.3,
    departureTime: '10:45 PM',
    arrivalTime: '12:30 AM',
    duration: '01h 45m',
    price: 1190,
    seatsLeft: 28,
    extraDiscountTag: 'Extra 10% Discount',
  ),
  BusResultItem(
    operatorName: '7 Hills Roadways',
    busType: 'AC Sleeper 2+1 Multi Axle Scania',
    rating: 4.2,
    departureTime: '09:30 PM',
    arrivalTime: '11:45 PM',
    duration: '02h 15m',
    price: 909,
    seatsLeft: 38,
  ),
  BusResultItem(
    operatorName: 'Orange Travels',
    busType: 'AC Sleeper 2+1',
    rating: 4.0,
    departureTime: '10:00 PM',
    arrivalTime: '12:15 AM',
    duration: '02h 15m',
    price: 850,
    seatsLeft: 24,
  ),
];
