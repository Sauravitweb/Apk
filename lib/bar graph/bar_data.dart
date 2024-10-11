import 'package:marks/bar%20graph/individual_bar.dart';

class BarData {
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thurAmount;
  final double friAmount;
  final double satAmount;

  BarData(
      {required this.sunAmount,
      required this.monAmount,
      required this.tueAmount,
      required this.wedAmount,
      required this.thurAmount,
      required this.friAmount,
      required this.satAmount});

  List<IndividualBar> barData = [];

  // initialize bar data
  void initializeBarData() {
    barData = [
      // sun
      IndividualBar(x: 0, y: sunAmount),

      // mon
      IndividualBar(x: 0, y: monAmount),

      // tue
      IndividualBar(x: 0, y: tueAmount),

      // wed
      IndividualBar(x: 0, y: wedAmount),

      // thur
      IndividualBar(x: 0, y: thurAmount),

      // fri
      IndividualBar(x: 0, y: friAmount),

      // sat
      IndividualBar(x: 0, y: satAmount),
    ];
  }
}
