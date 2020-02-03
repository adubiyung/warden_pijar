import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:warden_pijar/models/dashboard.dart';

class DonutAutoLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutAutoLabelChart(this.seriesList, {this.animate});

  factory DonutAutoLabelChart.withVehicleData(List<DataVehicle> _list) {
    return new DonutAutoLabelChart(
      _vehicleData(_list),
      // Disable animations for image tests.
      animate: true,
    );
  }

  factory DonutAutoLabelChart.withIncomeData(List<DataIncome> _list) {
    return new DonutAutoLabelChart(
      _incomeData(_list),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 30,
        arcRendererDecorators: [new charts.ArcLabelDecorator()],
      ),
      behaviors: [
        new charts.DatumLegend(
          position: charts.BehaviorPosition.end,
          outsideJustification: charts.OutsideJustification.endDrawArea,
          horizontalFirst: false,
          desiredMaxColumns: 2,
          cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
        ),
      ],
    );
  }

  static List<charts.Series<DataVehicle, String>> _vehicleData(
      List<DataVehicle> _list) {
    return [
      new charts.Series<DataVehicle, String>(
        id: 'Sales',
        colorFn: (DataVehicle model, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(model.colors))),
        domainFn: (DataVehicle model, _) => model.vehicleTotal.toString(),
        measureFn: (DataVehicle model, _) => model.vehicleTotal,
        data: _list,

        // Set a label accessor to control the text of the arc label.
        // labelAccessorFn: (DataVehicle row, _) =>
        //     '${row.vehicleTypeName}: ${row.vehicleTotal}',
      )
    ];
  }

  static List<charts.Series<DataIncome, String>> _incomeData(
      List<DataIncome> _list) {
    return [
      new charts.Series<DataIncome, String>(
        id: 'Income',
        // colorFn: (DataIncome model, _) =>
        //     charts.ColorUtil.fromDartColor(Color(int.parse(model.colors))),
        domainFn: (DataIncome model, _) => model.transactionTotal.toString(),
        measureFn: (DataIncome model, _) => model.transactionTotal,
        data: _list,

        // Set a label accessor to control the text of the arc label.
        // labelAccessorFn: (DataVehicle row, _) =>
        //     '${row.vehicleTypeName}: ${row.vehicleTotal}',
      )
    ];
  }
}
