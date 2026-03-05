/// A car option for the "Find Your Car" selection list.
class CarOption {
  final String name;
  final int engineCc;
  final String fuelType;

  const CarOption({
    required this.name,
    required this.engineCc,
    required this.fuelType,
  });
}

/// Popular cars list for the Find Your Car page.
const List<CarOption> popularCars = [
  CarOption(name: 'Chevrolet Beat LT', engineCc: 1199, fuelType: 'Petrol'),
  CarOption(name: 'Ford Ecosport 1.5 Diesel Titanium', engineCc: 1498, fuelType: 'Diesel'),
  CarOption(name: 'Honda Amaze S CVT Petrol BSIV', engineCc: 1199, fuelType: 'Petrol'),
  CarOption(name: 'Hyundai Creta SX', engineCc: 1497, fuelType: 'Petrol'),
  CarOption(name: 'Hyundai Grand i10 1.2 Kappa Sportz Dual Tone', engineCc: 1197, fuelType: 'Petrol'),
  CarOption(name: 'Hyundai Venue S', engineCc: 1197, fuelType: 'Petrol'),
  CarOption(name: 'Hyundai i20 1.2 Sportz', engineCc: 1197, fuelType: 'Petrol'),
  CarOption(name: 'Kia Seltos HTX Plus Diesel', engineCc: 1493, fuelType: 'Diesel'),
  CarOption(name: 'Maruti Alto 800 LXI BSIV', engineCc: 796, fuelType: 'Petrol'),
  CarOption(name: 'Maruti Alto LXi', engineCc: 796, fuelType: 'Petrol'),
  CarOption(name: 'Maruti Baleno Delta', engineCc: 1197, fuelType: 'Petrol'),
  CarOption(name: 'Maruti Celerio VXI', engineCc: 998, fuelType: 'Petrol'),
  CarOption(name: 'Maruti Swift VXI', engineCc: 1197, fuelType: 'Petrol'),
  CarOption(name: 'Maruti Wagon R VXI', engineCc: 998, fuelType: 'Petrol'),
  CarOption(name: 'Tata Nexon XZ Plus', engineCc: 1199, fuelType: 'Petrol'),
  CarOption(name: 'Tata Punch Adventure', engineCc: 1199, fuelType: 'Petrol'),
  CarOption(name: 'Toyota Innova Crysta GX', engineCc: 2393, fuelType: 'Diesel'),
  CarOption(name: 'Mahindra XUV700 AX5', engineCc: 2184, fuelType: 'Petrol'),
  CarOption(name: 'Honda City V', engineCc: 1498, fuelType: 'Petrol'),
  CarOption(name: 'Hyundai Verna SX', engineCc: 1497, fuelType: 'Petrol'),
];
