import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:warden_pijar/models/dashboard.dart';

class SingleLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SingleLineChart(this.seriesList, {this.animate});

  factory SingleLineChart.withHourData(List<DataPeakHour> _list) {
    return new SingleLineChart(
      _peakHourData(_list),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList, animate: animate);
  }

  static List<charts.Series<DataPeakHour, num>> _peakHourData(
      List<DataPeakHour> _list) {
    return [
      new charts.Series<DataPeakHour, int>(
        id: 'PeakHour',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DataPeakHour model, _) => model.timeCheckin.round(),
        measureFn: (DataPeakHour model, _) => model.timeTotal,
        data: _list,
      ),
    ];
  }
}
