/// Single popular hotel card (image placeholder, rating, name, location, price, rooms left).
class HotelListItem {
  const HotelListItem({
    required this.name,
    required this.location,
    required this.rating,
    required this.price,
    required this.roomsLeft,
    this.imageUrl,
    this.fullAddress,
    this.overview,
  });

  final String name;
  final String location;
  final double rating;
  final int price;
  final int roomsLeft;
  final String? imageUrl;
  /// Full address for details page; falls back to [location] if null.
  final String? fullAddress;
  /// Overview text for details page.
  final String? overview;
}

/// Default location for hotel search.
const String defaultHotelLocation = 'Badung, Bali, Indonesia';

/// Label when "Use Current Location" is selected.
const String currentLocationLabel = 'Properties Near Me';

/// Single recent hotel search entry.
class HotelRecentSearch {
  const HotelRecentSearch({
    required this.location,
    required this.dateRange,
    required this.guests,
    required this.rooms,
  });

  final String location;
  final String dateRange;
  final String guests;
  final String rooms;
}

/// Popular destination for location search.
const List<String> hotelPopularDestinations = [
  'Delhi',
  'Mumbai',
  'Bengaluru',
  'Goa',
  'Chennai',
  'Dubai',
  'Jaipur',
  'Hyderabad',
  'Kolkata',
  'Kochi',
];

/// Sample recent searches for hotel location page.
const List<HotelRecentSearch> hotelRecentSearches = [
  HotelRecentSearch(
    location: 'Bangalore',
    dateRange: '04 Mar - 05 Mar',
    guests: '2 Guests',
    rooms: '1 Room',
  ),
  HotelRecentSearch(
    location: 'Goa',
    dateRange: '10 Apr - 12 Apr',
    guests: '1 Guest',
    rooms: '1 Room',
  ),
];

/// Sample check-in/check-out dates for display.
const String defaultCheckInLabel = '10, Apr 2023';
const String defaultCheckOutLabel = '12, Apr 2023';

/// Popular hotels for horizontal scroll (multiple entries for scrolling).
const List<HotelListItem> popularHotels = [
  HotelListItem(
    name: 'The Karma Villa',
    location: 'Kuta, Badung, Bali',
    rating: 4.8,
    price: 69,
    roomsLeft: 2,
    fullAddress: '109 Poppies Lane Kuta, Badung, Bali',
    overview:
        "The Apurva Villa is a stunning private villa located in the heart of Bali's popular Badung district. As soon as you enter the villa's gates, you'll be greeted by lush tropical gardens and a serene atmosphere. The villa features a beautiful curved roof design that blends traditional Balinese architecture with modern comforts. Enjoy the crystal-clear swimming pool, spacious living areas, and world-class amenities for an unforgettable stay.",
  ),
  HotelListItem(
    name: 'Emeralda Resort',
    location: 'Kuta, Badung, Bali',
    rating: 4.6,
    price: 85,
    roomsLeft: 5,
  ),
  HotelListItem(
    name: 'Villa Seminyak',
    location: 'Seminyak, Bali',
    rating: 4.9,
    price: 120,
    roomsLeft: 1,
  ),
  HotelListItem(
    name: 'Ubud Green Retreat',
    location: 'Ubud, Gianyar, Bali',
    rating: 4.7,
    price: 95,
    roomsLeft: 3,
  ),
  HotelListItem(
    name: 'Ocean View Suites',
    location: 'Nusa Dua, Badung, Bali',
    rating: 4.5,
    price: 110,
    roomsLeft: 4,
  ),
  HotelListItem(
    name: 'Sanur Beach Hotel',
    location: 'Sanur, Denpasar, Bali',
    rating: 4.4,
    price: 72,
    roomsLeft: 6,
  ),
  HotelListItem(
    name: 'Canggu Surf Lodge',
    location: 'Canggu, Badung, Bali',
    rating: 4.8,
    price: 88,
    roomsLeft: 2,
  ),
  HotelListItem(
    name: 'Jimbaran Bay Resort',
    location: 'Jimbaran, Badung, Bali',
    rating: 4.6,
    price: 135,
    roomsLeft: 3,
  ),
];
