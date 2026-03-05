import 'package:flutter/material.dart';

/// A single departure date chip (day, weekday, optional tag e.g. Holiday).
class TrainDepartureDate {
  const TrainDepartureDate({
    required this.day,
    required this.weekday,
    this.tag,
  });

  final String day;
  final String weekday;
  final String? tag;
}

/// Recent search card (route code, date, optional available badge).
class TrainRecentSearch {
  const TrainRecentSearch({
    required this.fromCode,
    required this.toCode,
    required this.dateLabel,
    this.available = false,
  });

  final String fromCode;
  final String toCode;
  final String dateLabel;
  final bool available;
}

/// Popular service (icon + label) for grid on train home.
class TrainPopularService {
  const TrainPopularService({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

/// Travel blog card (title, button label).
class TrainTravelBlog {
  const TrainTravelBlog({
    required this.title,
    required this.buttonLabel,
  });

  final String title;
  final String buttonLabel;
}

/// Single train option for search results list.
class TrainResultItem {
  const TrainResultItem({
    required this.trainNumber,
    required this.trainName,
    required this.runningDays,
    required this.departureTime,
    required this.departureDate,
    required this.departureStation,
    required this.arrivalTime,
    required this.arrivalDate,
    required this.arrivalStation,
    required this.duration,
    required this.classOptions,
  });

  final String trainNumber;
  final String trainName;
  /// e.g. "Runs on Tue" or "Runs on Tue, Thu, Sun"
  final String runningDays;
  final String departureTime;
  final String departureDate;
  final String departureStation;
  final String arrivalTime;
  final String arrivalDate;
  final String arrivalStation;
  final String duration;
  /// Class-wise price and status (Departed / Available)
  final List<TrainClassOption> classOptions;
}

/// One class (SL, 3A, 2A, etc.) with price and departed/available status.
class TrainClassOption {
  const TrainClassOption({
    required this.classCode,
    required this.price,
    this.departed = false,
    this.departedAgo,
    this.seatsAvailable = false,
  });

  final String classCode;
  final int price;
  final bool departed;
  /// e.g. "2hrs ago", "15hrs ago"
  final String? departedAgo;
  final bool seatsAvailable;
}

/// Nearby station card: source — nearby station, distance, trains count, seats.
class TrainNearbyStation {
  const TrainNearbyStation({
    required this.sourceCode,
    required this.sourceName,
    required this.sourceLabel,
    required this.nearbyCode,
    required this.nearbyName,
    required this.distanceLabel,
    required this.trainsOnRoute,
    required this.seatsAvailable,
  });

  final String sourceCode;
  final String sourceName;
  final String sourceLabel;
  final String nearbyCode;
  final String nearbyName;
  final String distanceLabel;
  final int trainsOnRoute;
  final bool seatsAvailable;
}

/// Sort option for train results (matches Sort By modal).
enum TrainSortOption {
  recommended,
  availability,
  fastest,
  earlyDeparture,
  lateDeparture,
  earlyArrival,
  lateArrival,
}

// ——————— List data ———————

const List<TrainDepartureDate> trainDepartureDates = [
  TrainDepartureDate(day: '3', weekday: 'Today', tag: 'Holiday'),
  TrainDepartureDate(day: '4', weekday: 'Wed', tag: 'Holiday'),
  TrainDepartureDate(day: '5', weekday: 'Thu'),
  TrainDepartureDate(day: '6', weekday: 'Fri'),
  TrainDepartureDate(day: '7', weekday: 'Sat'),
];

const List<TrainRecentSearch> trainRecentSearches = [
  TrainRecentSearch(fromCode: 'TPTY', toCode: 'TNM', dateLabel: '04 Mar', available: true),
  TrainRecentSearch(fromCode: 'TNM', toCode: 'TPTY', dateLabel: '04 Mar', available: true),
  TrainRecentSearch(fromCode: 'TNM', toCode: 'RJP', dateLabel: '05 Mar', available: false),
];

const List<TrainPopularService> trainPopularServices = [
  TrainPopularService(label: 'Link Aadhaar', icon: Icons.badge_rounded),
  TrainPopularService(label: 'Check PNR Status', icon: Icons.confirmation_number_rounded),
  TrainPopularService(label: 'Live Train Status', icon: Icons.train_rounded),
  TrainPopularService(label: 'Order Food', icon: Icons.restaurant_rounded),
  TrainPopularService(label: 'My Bookings', icon: Icons.luggage_rounded),
  TrainPopularService(label: 'Free Cancellation', icon: Icons.cancel_schedule_send_rounded),
  TrainPopularService(label: 'Ticket Assure', icon: Icons.verified_rounded),
  TrainPopularService(label: 'Travel Stories', icon: Icons.menu_book_rounded),
];

const List<TrainTravelBlog> trainTravelBlogs = [
  TrainTravelBlog(
    title: 'Magh Mela 2026: Dates, Timings & Train Routes',
    buttonLabel: 'Check Now',
  ),
  TrainTravelBlog(
    title: 'Things to do & travel tips for Ayodhya',
    buttonLabel: 'Check Now',
  ),
  TrainTravelBlog(
    title: 'OTP Now Mandatory for Tatkal Ticket',
    buttonLabel: 'Know More',
  ),
];

/// Mock train search results for TPTY - TNM.
const List<TrainResultItem> trainSearchResults = [
  TrainResultItem(
    trainNumber: '12867',
    trainName: 'HWH PDY SUF EXP',
    runningDays: 'Runs on Tue',
    departureTime: '01:05',
    departureDate: '03 Mar',
    departureStation: 'Tirupati',
    arrivalTime: '05:29',
    arrivalDate: '03 Mar',
    arrivalStation: 'Tiruvannamalai',
    duration: '04h 24m',
    classOptions: [
      TrainClassOption(classCode: 'SL', price: 180, departed: true, departedAgo: '2hrs ago'),
      TrainClassOption(classCode: '3A', price: 565, departed: true, departedAgo: '15hrs ago'),
      TrainClassOption(classCode: '3E', price: 565, departed: true, departedAgo: '3hrs ago'),
      TrainClassOption(classCode: '2A', price: 770, departed: true, departedAgo: '5hrs ago'),
      TrainClassOption(classCode: '2S', price: 100, departed: true, departedAgo: '8hrs ago'),
    ],
  ),
  TrainResultItem(
    trainNumber: '17407',
    trainName: 'PAMANI EXPRESS',
    runningDays: 'Runs on Tue, Thu, Sun',
    departureTime: '11:55',
    departureDate: '03 Mar',
    departureStation: 'Tirupati',
    arrivalTime: '15:38',
    arrivalDate: '03 Mar',
    arrivalStation: 'Tiruvannamalai',
    duration: '03h 43m',
    classOptions: [
      TrainClassOption(classCode: '2S', price: 100, departed: true, departedAgo: '2hrs ago'),
      TrainClassOption(classCode: 'SL', price: 150, departed: true, departedAgo: '5hrs ago'),
      TrainClassOption(classCode: '3A', price: 520, departed: true, departedAgo: '8hrs ago'),
    ],
  ),
  TrainResultItem(
    trainNumber: '16779',
    trainName: 'TPTY RMM EXP',
    runningDays: 'Runs on Mon, Wed, Fri, Sat',
    departureTime: '06:15',
    departureDate: '04 Mar',
    departureStation: 'Tirupati',
    arrivalTime: '10:45',
    arrivalDate: '04 Mar',
    arrivalStation: 'Tiruvannamalai',
    duration: '04h 30m',
    classOptions: [
      TrainClassOption(classCode: '2S', price: 100, seatsAvailable: true),
      TrainClassOption(classCode: 'SL', price: 180, seatsAvailable: true),
      TrainClassOption(classCode: '3A', price: 565, seatsAvailable: true),
    ],
  ),
];

/// Dates for results page strip (03 Tue, 04 Wed, ... 08 Sun).
const List<String> trainResultDateStrip = [
  '03 Tue',
  '04 Wed',
  '05 Thu',
  '06 Fri',
  '07 Sat',
  '08 Sun',
];

/// Nearby stations for results page.
const List<TrainNearbyStation> trainNearbyStations = [
  TrainNearbyStation(
    sourceCode: 'TPTY',
    sourceName: 'Tirupati',
    sourceLabel: 'Same source',
    nearbyCode: 'JTJ',
    nearbyName: 'Jolarpetta',
    distanceLabel: '65.3 km from TNM',
    trainsOnRoute: 14,
    seatsAvailable: true,
  ),
  TrainNearbyStation(
    sourceCode: 'TPTY',
    sourceName: 'Tirupati',
    sourceLabel: 'Same source',
    nearbyCode: 'AB',
    nearbyName: 'Ambur',
    distanceLabel: '71.8 km from TNM',
    trainsOnRoute: 1,
    seatsAvailable: true,
  ),
];

/// Popular stations for station search page.
class TrainStationPopular {
  const TrainStationPopular({
    required this.code,
    required this.name,
    required this.state,
  });

  final String code;
  final String name;
  final String state;
}

const List<TrainStationPopular> trainPopularStations = [
  TrainStationPopular(code: 'TPTY', name: 'Tirupati', state: 'Andhra Pradesh'),
  TrainStationPopular(code: 'TNM', name: 'Tiruvannamalai', state: 'Tamil Nadu'),
  TrainStationPopular(code: 'RJP', name: 'Rajampet', state: 'Andhra Pradesh'),
  TrainStationPopular(code: 'MAS', name: 'Chennai Central', state: 'Tamil Nadu'),
  TrainStationPopular(code: 'SC', name: 'Secunderabad', state: 'Telangana'),
  TrainStationPopular(code: 'BZA', name: 'Vijayawada', state: 'Andhra Pradesh'),
  TrainStationPopular(code: 'NDLS', name: 'New Delhi', state: 'Delhi'),
  TrainStationPopular(code: 'CSTM', name: 'Mumbai CST', state: 'Maharashtra'),
];
