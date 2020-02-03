import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warden_pijar/models/transaction.dart';
import 'package:warden_pijar/services/api.dart';
import 'package:warden_pijar/views/widgets/color_library.dart';
import 'package:warden_pijar/views/widgets/session_manager.dart';
import 'package:warden_pijar/views/widgets/ticket_row.dart';
import 'package:http/http.dart' as http;

import 'history_order_page.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  static const String url = BaseUrl.TRANSACTION;
  static const String include =
      '&include=vehicle_id&include=location_id&include=feature_type_id&include=payment_type_id&include=voucher_id';
  static const String idStatus = '4';
  static SessionManager _session;
  static HashMap<String, String> user;
  var loading = false;
  List<DataTransaction> _listData = [];
  int _selectedType = 1;

  Future<Null> _fetchData(int statusType) async {
    final prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(prefs);
    user = _session.getUserSession();
    String token = user['USER_TOKEN'];

    String whereClause;

    if (statusType == 1) {
      whereClause = whereClause = '?transaction_status=2&transaction_status=3';
    } else {
      whereClause = whereClause = '?transaction_status=1';
      print('masuk');
    }

    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    print('$url$whereClause$include');

    final response = await http.get('$url$whereClause$include',
        headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          _listData.clear();
          for (Map i in data['data']) {
            _listData.add(DataTransaction.fromJson(i));
          }
          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData(1);
  }

  @override
  Widget build(BuildContext context) {
    Widget _body = new Column(
      children: <Widget>[
        new Container(
          color: ColorLibrary.backgroundDark,
          child: new Wrap(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 30, top: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedType = 1;
                          _fetchData(1);
                        });
                      },
                      child: Container(
                        height: 35,
                        width: 110,
                        child: new Center(
                          child: new Text(
                            'Ongoing',
                            style: TextStyle(
                                fontFamily: 'Work Sans',
                                color: (_selectedType == 1)
                                    ? ColorLibrary.regularFontWhite
                                    : ColorLibrary.regularFontBlack),
                          ),
                        ),
                        decoration: new BoxDecoration(
                          color: (_selectedType == 1)
                              ? ColorLibrary.regularFontBlack
                              : Colors.transparent,
                          border: new Border.all(
                              width: 1.0, color: ColorLibrary.regularFontBlack),
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(5.0)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30, top: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedType = 2;
                          _fetchData(2);
                        });
                      },
                      child: Container(
                        height: 35,
                        width: 110,
                        child: new Center(
                          child: new Text(
                            'Booking',
                            style: TextStyle(
                              fontFamily: 'Work Sans',
                              color: (_selectedType == 2)
                                  ? ColorLibrary.regularFontWhite
                                  : ColorLibrary.regularFontBlack,
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                          color: (_selectedType == 2)
                              ? ColorLibrary.regularFontBlack
                              : Colors.transparent,
                          border: new Border.all(
                            width: 1.0,
                            color: ColorLibrary.regularFontBlack,
                          ),
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(5.0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        new Expanded(
          child: new Container(
            color: ColorLibrary.backgroundDark,
            child: loading
                ? Center(
                    child: CircularProgressIndicator(
                    backgroundColor: ColorLibrary.primary,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ColorLibrary.secondary),
                  ))
                : (_listData.length > 0)
                    ? CustomScrollView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: false,
                        slivers: <Widget>[
                          new SliverPadding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            sliver: new SliverList(
                              delegate: new SliverChildBuilderDelegate(
                                (context, index) {
                                  return TicketRow(_listData[index]);
                                },
                                childCount: _listData.length,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Text("You have no order. \n Let's order now."),
                      ),
          ),
        ),
      ],
    );

    return new Scaffold(
      appBar: AppBar(
        backgroundColor: ColorLibrary.backgroundDark,
        elevation: 0.3,
        title:
            Text("ongoing orders", style: TextStyle(fontFamily: 'Work Sans')),
        leading: new Container(),
        actions: <Widget>[
          new IconButton(
            padding: EdgeInsets.only(right: 27.0),
            icon: Icon(Icons.history),
            onPressed: () => _moveToHistory(),
          )
        ],
      ),
      body: _body,
    );
  }

  void _moveToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryOrderPage(),
      ),
    );
  }
}
