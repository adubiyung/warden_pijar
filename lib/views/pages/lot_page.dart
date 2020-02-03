import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warden_pijar/models/location.dart';
import 'package:warden_pijar/services/api.dart';
import 'package:warden_pijar/views/widgets/color_library.dart';
import 'package:warden_pijar/views/widgets/session_manager.dart';
import 'package:http/http.dart' as http;

class LotPage extends StatefulWidget {
  final String locationID;

  const LotPage({Key key, this.locationID}) : super(key: key);

  @override
  _LotPageState createState() => _LotPageState();
}

class _LotPageState extends State<LotPage> {
  List<RadioModel> sampleData = new List<RadioModel>();
  int _currentIndex = 0;
  String url = BaseUrl.LOTMAP;
  SessionManager _session;
  HashMap<String, String> user;
  var loading = false;
  List<LocationLot> _listModel = [];
  List<LocationLot> _listModelLeft = [];
  List<LocationLot> _listModelRight = [];
  List<String> _listLabelLeft = [];
  List<String> _listDisableLeft = [];
  List<String> _checkedLeft = [];
  List<String> _listLabelRight = [];
  List<String> _listDisableRight = [];
  List<String> _checkedRight = [];

  Future<Null> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(prefs);
    user = _session.getUserSession();
    String token = user['USER_TOKEN'];
    String include =
        "?is_booking=True&location_id=${widget.locationID}&include=detail_location_id";

    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    final response = await http
        .get('$url$include', headers: {HttpHeaders.authorizationHeader: token});
    print('$url$include');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          for (Map i in data['data']) {
            _listModel.add(LocationLot.fromJson(i));
            if (LocationLot.fromJson(i).sideID == 1) {
              _listModelLeft.add(LocationLot.fromJson(i));
              _listLabelLeft
                  .add(LocationLot.fromJson(i).detailLotID.toString());
              if (!LocationLot.fromJson(i).isAvailable) {
                _listDisableLeft
                    .add(LocationLot.fromJson(i).detailLotID.toString());
              }
            } else {
              _listModelRight.add(LocationLot.fromJson(i));
              _listLabelRight
                  .add(LocationLot.fromJson(i).detailLotID.toString());
              if (!LocationLot.fromJson(i).isAvailable) {
                _listDisableRight
                    .add(LocationLot.fromJson(i).detailLotID.toString());
              }
            }
          }
          loading = false;
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
    Widget _circularProgress() {
      return SizedBox(
        child: CircularProgressIndicator(
          backgroundColor: ColorLibrary.primary,
          valueColor: AlwaysStoppedAnimation<Color>(ColorLibrary.secondary),
          strokeWidth: 2.0,
        ),
      );
    }

    Widget _info = Container(
      color: ColorLibrary.backgroundDark,
      child: Wrap(
        children: <Widget>[
          Container(
            height: 40,
            margin: EdgeInsets.all(10),
            decoration:
                BoxDecoration(border: Border.all(color: ColorLibrary.primary)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorLibrary.primary),
                      color: ColorLibrary.primary,
                    ),
                  ),
                ),
                Text(
                  'Not Available',
                  style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontSize: 11,
                      color: ColorLibrary.primary),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorLibrary.primary),
                    ),
                  ),
                ),
                Text(
                  'Available',
                  style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontSize: 11,
                      color: ColorLibrary.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget _bodyMap = new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 20.0,
          child: Text('jalan atas'),
        ),
        Expanded(
          child: new Container(
            decoration:
                BoxDecoration(border: Border.all(color: ColorLibrary.primary)),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Text('Some data here'),
                new Text('More stuff here'),
              ],
            ),
          ),
        ),
        Container(
          height: 20.0,
          child: new Align(
            alignment: Alignment.centerRight,
            child: new Text('Jalan Bawah'),
          ),
        )
      ],
    );

    Widget _content = Column(
      children: <Widget>[
        Expanded(
          child: new Container(
            color: ColorLibrary.backgroundDark,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: _listModelLeft.length,
                    itemBuilder: (context, index) {
                      return new InkWell(
                        splashColor: Colors.blueAccent,
                        // onTap: () {
                        //   setState(() {
                        //     _listModelLeft.forEach(
                        //         (element) => element.isAvailable = false);
                        //     _listModelLeft[index].isAvailable = true;
                        //   });
                        // },
                        child: new RadioItem(_listModelLeft[index]),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    child: _bodyMap,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _listModelRight.length,
                    itemBuilder: (context, index) {
                      return new InkWell(
                        splashColor: Colors.blueAccent,
                        // onTap: () {
                        //   setState(() {
                        //     _listModelRight.forEach(
                        //         (element) => element.isAvailable = false);
                        //     _listModelRight[index].isAvailable = true;
                        //   });
                        // },
                        child: new RadioItem(_listModelRight[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorLibrary.primary,
        elevation: 0.3,
        title: Text(
          "Parking Lot",
          style: TextStyle(fontFamily: 'Work Sans'),
        ),
      ),
      body: new Container(
        child: loading
            ? Center(
                child: _circularProgress(),
              )
            : Column(
                children: <Widget>[
                  _info,
                  Expanded(
                    child: Container(
                      color: ColorLibrary.backgroundDark,
                      child: _content,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel(this.isSelected, this.buttonText);
}

class RadioItem extends StatelessWidget {
  final LocationLot _item;
  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(5.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 35.0,
            width: 35.0,
            child: new Center(
              child: new Text(_item.detailLotID.toString(),
                  style: new TextStyle(
                      color: _item.isAvailable
                          ? ColorLibrary.regularFontWhite
                          : ColorLibrary.primaryDark,
                      //fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      fontFamily: 'Work Sans')),
            ),
            decoration: new BoxDecoration(
              color:
                  _item.isAvailable ? Colors.transparent : ColorLibrary.primary,
              border: new Border.all(width: 1.0, color: ColorLibrary.primary),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
        ],
      ),
    );
  }
}
