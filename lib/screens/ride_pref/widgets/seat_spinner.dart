import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../../widgets/actions/bla_button.dart';

class SeatNumberSpinner extends StatelessWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;
  final int minValue;
  final int maxValue;

  const SeatNumberSpinner({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.minValue = 1,
    this.maxValue = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(
          icon: Icons.remove,
          onPressed: initialValue > minValue
              ? () => onChanged(initialValue - 1)
              : null,
        ),
        SizedBox(width: BlaSpacings.xl),
        Text(
          initialValue.toString(),
          style: BlaTextStyles.heading.copyWith(
            color: BlaColors.textNormal,
            fontSize: 48,
          ),
        ),
        SizedBox(width: BlaSpacings.xl),
        _buildButton(
          icon: Icons.add,
          onPressed: initialValue < maxValue
              ? () => onChanged(initialValue + 1)
              : null,
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: onPressed != null ? BlaColors.primary : BlaColors.disabled,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        iconSize: 24,
        padding: EdgeInsets.all(BlaSpacings.s),
      ),
    );
  }
}

class SeatSelectionScreen extends StatefulWidget {
  final int initialSeats;

  const SeatSelectionScreen({
    super.key,
    required this.initialSeats,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  late int selectedSeats;

  @override
  void initState() {
    super.initState();
    selectedSeats = widget.initialSeats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: BlaColors.neutralLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Number of passengers',
          style: BlaTextStyles.heading.copyWith(
            color: BlaColors.textNormal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: BlaSpacings.xl),
                  SeatNumberSpinner(
                    initialValue: selectedSeats,
                    onChanged: (value) {
                      setState(() {
                        selectedSeats = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(BlaSpacings.m),
            child: SizedBox(
              width: double.infinity,
              child: BlaButton(
                label: 'Confirm',
                onPressed: () => Navigator.pop(context, selectedSeats),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(BlaSpacings.radius),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
