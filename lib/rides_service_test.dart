import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/model/ride/locations.dart';
import 'package:my_app/model/ride_pref/ride_pref.dart';
import 'package:my_app/repository/mock/mock_ride_repo.dart';
import 'package:my_app/service/rides_service.dart';

void main() {
  late RidesService ridesService;

  setUp(() {
    ridesService = RidesService();
    ridesService.initialize(MockRidesRepository());
  });

  group('RidesService Tests', () {
    test('T1 - All rides', () {
      final preference = RidePref(
        departure: Location(name: 'Battambang', country: Country.cambodia),
        arrival: Location(name: 'Siem Reap', country: Country.cambodia),
        departureDate: DateTime.now(),
        requestedSeats: 1,
      );

      final rides = ridesService.getRides(preference, null);

      print(
          'For your preference (Battambang -> Siem Reap, today 1 passenger) we found ${rides.length} rides:');

      if (rides.isEmpty) {
        print('Warning: ride list is full!');
      } else {
        for (final ride in rides) {
          final hour = ride.departureDate.hour;
          final minute = ride.departureDate.minute;
          final formattedTime =
              '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
          final amPm = hour < 12 ? 'am' : 'pm';
          print(
              '- at $formattedTime $amPm with ${ride.driver.firstName} (${ride.arrivalDateTime.difference(ride.departureDate).inHours} hours)');
        }
      }
    });

    test('T2 - Pet Allowed', () {
      final preference = RidePref(
        departure: Location(name: 'Battambang', country: Country.cambodia),
        arrival: Location(name: 'Siem Reap', country: Country.cambodia),
        departureDate: DateTime.now(),
        requestedSeats: 1,
      );

      final filter = RidesFilter(petAccepted: true);

      final rides = ridesService.getRides(preference, filter);

      print(
          '\nFor your preference (Battambang -> Siem Reap, today 1 passenger) with pets allowed:');

      if (rides.isEmpty) {
        print('Warning: ride list is full!');
      } else {
        print('Found ${rides.length} ride:');
        for (final ride in rides) {
          final hour = ride.departureDate.hour;
          final minute = ride.departureDate.minute;
          final formattedTime =
              '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
          final amPm = hour < 12 ? 'am' : 'pm';
          print(
              '- at $formattedTime $amPm with ${ride.driver.firstName} (${ride.arrivalDateTime.difference(ride.departureDate).inHours} hours)');
        }
      }
    });
  });
}
