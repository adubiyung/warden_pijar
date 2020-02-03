import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warden_pijar/models/dashboard.dart';
import 'package:warden_pijar/services/api.dart';
import 'package:warden_pijar/views/widgets/color_library.dart';
import 'package:warden_pijar/views/widgets/combo_line_chart.dart';
import 'package:warden_pijar/views/widgets/donut_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:warden_pijar/views/widgets/session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:warden_pijar/views/widgets/single_line_chart.dart';
import 'package:warden_pijar/views/widgets/single_timeseries_chart.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime currentBackPressTime;
  String url = BaseUrl.DASHBOARD;
  SessionManager _session;
  HashMap<String, String> user;
  var loading = false;
  List<DataVehicle> _listVehicle = [];
  List<DataIncome> _listIncome = [];
  List<DataPeakHour> _listHour = [];
  List<DataPeakDay> _listDay = [];
  int incomeToday;
  List<charts.Series> seriesList;
  bool animate = false;
  FlutterMoneyFormatter fmf;
  MoneyFormatterOutput fo;

  Future<Null> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(prefs);
    user = _session.getUserSession();
    String token = user['USER_TOKEN'];

    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    final response =
        await http.get(url, headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      final dataJson = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          //mapping data vehicle
          for (Map i in dataJson['dash_vehicle']) {
            _listVehicle.add(DataVehicle.fromJson(i));
          }

          //mapping data income
          for (Map i in dataJson['dash_income']) {
            _listIncome.add(DataIncome.fromJson(i));
          }

          if (_listIncome.length != 0) {
            incomeToday = _listIncome[0].transactionTotal;
          } else {
            incomeToday = null;
          }
          fmf = FlutterMoneyFormatter(
            amount: (incomeToday == null) ? 0.0 : incomeToday.toDouble(),
            settings: MoneyFormatterSettings(
                symbol: 'Rp',
                thousandSeparator: '.',
                decimalSeparator: ',',
                symbolAndNumberSeparator: ' ',
                fractionDigits: 0,
                compactFormatType: CompactFormatType.long),
          );
          fo = fmf.output;
          // } else {}

          //mapping data peakHour
          for (Map i in dataJson['peak_hour']) {
            _listHour.add(DataPeakHour.fromJson(i));
          }

          //mapping data peakDay
          for (Map i in dataJson['peak_day']) {
            _listDay.add(DataPeakDay.fromJson(i));
          }

          loading = false;
          print('vehicle ${response.body}');
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: SafeArea(
          child: Container(
            color: ColorLibrary.backgroundDark,
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 5,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child: Text(
                                  "Vehicle Graph",
                                  style: TextStyle(fontFamily: 'Work Sans'),
                                ),
                              ),
                              Flexible(
                                flex: 8,
                                child: loading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                                              backgroundColor: ColorLibrary.primary,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ColorLibrary.secondary),
                                        ),
                                      )
                                    : DonutAutoLabelChart.withVehicleData(
                                        _listVehicle),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                  flex: 3,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      "my income today",
                                      style: TextStyle(fontFamily: 'Work Sans'),
                                    ),
                                  )),
                              Flexible(
                                flex: 7,
                                child: Center(
                                  child: Text(
                                    (incomeToday != null)
                                        ? fo.symbolOnLeft
                                        : "No Data",
                                    style: TextStyle(
                                        fontFamily: 'Work Sans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 5,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child: Text(
                                  "Target vs Actual Graph",
                                  style: TextStyle(fontFamily: 'Work Sans'),
                                ),
                              ),
                              Flexible(
                                flex: 8,
                                child: DateTimeComboLinePointChart
                                    .withRandomData(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child: Text(
                                  "Peak Hour Graph",
                                  style: TextStyle(fontFamily: 'Work Sans'),
                                ),
                              ),
                              Flexible(
                                flex: 8,
                                child: SingleLineChart.withHourData(_listHour),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child: Text(
                                  "Peak Day Graph",
                                  style: TextStyle(fontFamily: 'Work Sans'),
                                ),
                              ),
                              Flexible(
                                flex: 8,
                                child:
                                    SingleTimeSeriesChart.withDayData(_listDay),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "press back again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }
}
