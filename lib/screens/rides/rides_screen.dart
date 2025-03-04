import 'package:flutter/material.dart';
import 'package:my_app/screens/ride_pref/widgets/ride_pref_form.dart';
import 'package:my_app/screens/rides/widgets/ride_pref_bar.dart';
import 'package:my_app/service/ride_prefs_service.dart';

import '../../model/ride/ride.dart';
import '../../model/ride_pref/ride_pref.dart';
import '../../service/rides_service.dart';
import '../../theme/theme.dart';
import 'widgets/rides_tile.dart';

class RidesScreen extends StatefulWidget {
  final RidePref initialRidePref;

  const RidesScreen({super.key, required this.initialRidePref});

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  late RidePref _currentRidePref;
  RidesFilter? _filter;
  final RidesService _ridesService = RidesService();

  @override
  void initState() {
    super.initState();
    _currentRidePref = widget.initialRidePref;
  }

  List<Ride> get matchingRides {
    return _ridesService.getRides(_currentRidePref, _filter);
  }

  void onEditRidePressed() {
    showDialog(
      context: context,
      builder: (context) => _buildEditRidePrefDialog(context),
    );
  }

  void onFilterPressed() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildFilterModal(context),
    );
  }

  Widget _buildEditRidePrefDialog(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
      decoration: BoxDecoration(
        color: Colors.white, // White background
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 2.1 Display the Form to input the ride preferences
          RidePrefForm(
            initRidePref: RidePrefService.currentRidePref,
          ),
          SizedBox(height: BlaSpacings.m),
          // 2.2 Optionally display a list of past preferences
        ],
      ),
    );
  }

  Widget _buildFilterModal(BuildContext context) {
    bool petAccepted = _filter?.petAccepted ?? false;

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          padding: const EdgeInsets.all(BlaSpacings.m),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Filters', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: BlaSpacings.m),
              SwitchListTile(
                title: const Text('Pet Accepted'),
                value: petAccepted,
                onChanged: (value) {
                  setModalState(() {
                    petAccepted = value;
                  });
                },
              ),
              const SizedBox(height: BlaSpacings.m),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _filter = RidesFilter(petAccepted: petAccepted);
                  });
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final rides = matchingRides;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Rides'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: BlaSpacings.m, right: BlaSpacings.m, top: BlaSpacings.s),
        child: Column(
          children: [
            RidePrefBar(
              ridePref: _currentRidePref,
              onRidePrefPressed: onEditRidePressed,
              onFilterPressed: onFilterPressed,
            ),
            const SizedBox(height: BlaSpacings.m),
            Expanded(
              child: rides.isEmpty
                  ? const Center(
                      child: Text('No rides found matching your criteria'),
                    )
                  : ListView.builder(
                      itemCount: rides.length,
                      itemBuilder: (ctx, index) => RideTile(
                        ride: rides[index],
                        onPressed: () {
                          print("Selected ride: ${rides[index]}");
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
