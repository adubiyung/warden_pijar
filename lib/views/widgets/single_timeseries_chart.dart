import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:warden_pijar/models/dashboard.dart';

class SingleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SingleTimeSeriesChart(this.seriesList, {this.animate});

  factory SingleTimeSeriesChart.withDayData(List<DataPeakDay> _list) {
    return new SingleTimeSeriesChart(
      _peakDayData(_list),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<DataPeakDay, DateTime>> _peakDayData(
      List<DataPeakDay> _list) {
    return [
      new charts.Series<DataPeakDay, DateTime>(
        id: 'PeakDay',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DataPeakDay model, _) => DateTime.parse(model.dateCheckin),
        measureFn: (DataPeakDay model, _) => model.dateTotal,
        data: _list,
      )
    ];
  }
}
