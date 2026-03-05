/// A bike option for the "Find Your Bike" selection list.
class BikeOption {
  final String name;
  final int engineCc;

  const BikeOption({required this.name, required this.engineCc});
}

/// Popular bikes list for the Find Your Bike page.
const List<BikeOption> popularBikes = [
  BikeOption(name: 'BMW S 1000 XR Pro Racing red Petrol', engineCc: 999),
  BikeOption(name: 'Bajaj Avenger 160 Street', engineCc: 160),
  BikeOption(name: 'Bajaj Boxer Ct', engineCc: 100),
  BikeOption(name: 'Bajaj Discover 125 M - Self Start Disc Break Alloy Wheel', engineCc: 125),
  BikeOption(name: 'Bajaj Platina Spoke Kick Drum', engineCc: 100),
  BikeOption(name: 'Bajaj Pulsar 150 Dtsi Electric Start', engineCc: 150),
  BikeOption(name: 'Bajaj Pulsar 150 Kick Start', engineCc: 150),
  BikeOption(name: 'Ducati Scrambler 1100 Tribute Pro Petrol', engineCc: 1079),
  BikeOption(name: 'Harley-Davidson Forty Eight BS4 Petrol', engineCc: 1202),
  BikeOption(name: 'Harley-Davidson SuperLow Super Low Petrol', engineCc: 883),
  BikeOption(name: 'Hero Honda Passion Plus Spoke Kick Disc', engineCc: 100),
  BikeOption(name: 'Hero Honda Passion Pro Cast - Disc Brake-Electric Start', engineCc: 100),
  BikeOption(name: 'Hero Splendor Plus', engineCc: 100),
  BikeOption(name: 'Hero Xtreme 160R', engineCc: 160),
  BikeOption(name: 'Honda Activa 6G', engineCc: 110),
  BikeOption(name: 'Honda CB Shine', engineCc: 125),
  BikeOption(name: 'Honda SP 125', engineCc: 125),
  BikeOption(name: 'KTM Duke 200', engineCc: 200),
  BikeOption(name: 'Royal Enfield Classic 350', engineCc: 350),
  BikeOption(name: 'TVS Apache RTR 160', engineCc: 160),
  BikeOption(name: 'TVS Jupiter', engineCc: 110),
  BikeOption(name: 'Yamaha FZ S FI', engineCc: 149),
  BikeOption(name: 'Yamaha R15 V4', engineCc: 155),
];
