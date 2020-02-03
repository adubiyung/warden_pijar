import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warden_pijar/models/transaction.dart';
import 'package:warden_pijar/services/api.dart';
import 'package:warden_pijar/views/widgets/color_library.dart';
import 'package:warden_pijar/views/widgets/session_manager.dart';
import 'package:http/http.dart' as http;

class DialogForceCheckout extends StatefulWidget {
  final String transactionID;
  final String duration;
  final String billing;
  final String total;

  const DialogForceCheckout(this.transactionID, this.duration, this.billing, this.total);

  @override
  _DialogForceCheckoutState createState() => _DialogForceCheckoutState();
}

class _DialogForceCheckoutState extends State<DialogForceCheckout> {
  List<Reason> _listReason = [];
  SessionManager _session;
  HashMap<String, String> user;
  var loading = false;
  int _currentIndex = 0;

  Future<Null> _fetchData() async {
    String url = BaseUrl.REASON;
    final prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(prefs);
    user = _session.getUserSession();
    String token = user['USER_TOKEN'];

    setState(() {
      loading = true;
    });

    final response =
        await http.get(url, headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          for (Map i in data['data']) {
            _listReason.add(Reason.fromJson(i));
          }
          loading = false;
        });
      }
    }
  }

  Future<Null> _forceCheckout() async {
    String url = BaseUrl.REASON;
    final prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(prefs);
    user = _session.getUserSession();
    String userID = user['USER_ID'];
    String token = user['USER_TOKEN'];

    var client = new http.Client();
    String body =
        '''{"payment_type_id": "1", "voucher_id": "0", "end_time": "current_time", "checkout_time": "current_time",
        "total_duration": "${widget.duration}", "parking_billing": "${widget.billing}", "voucher_nominal": "0", "penalty_billing": "0", 
        "total_billing": "${widget.total}", "warden_checkout_by": "$userID", "transaction_status": "5", "reason_id": "$_currentIndex",
        "transaction_id": "${widget.transactionID}"}''';

    setState(() {
      loading = true;
    });

    final response = await client.post(url,
        headers: {HttpHeaders.authorizationHeader: token}, body: body);
        print(body);
        print(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      var msg = (jsonResponse as Map<String, dynamic>)['message'];
      if (mounted) {
        setState(() {
          loading = false;
        });
      }

      

      if (msg != "success checkout") {
        Fluttertoast.showToast(
          msg: "Oops. something wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Checkout Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Oops. something wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          new Text(
            "Please choose one of the right reasons below:",
            style: TextStyle(fontFamily: 'Work Sans'),
          ),
          new SizedBox(
            height: 5.0,
          ),
          new Divider(
            height: 2.0,
            color: ColorLibrary.thinFontBlack,
          ),
          new SizedBox(
            height: 5.0,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return RadioListTile(
                  value: _listReason[index].reasonID,
                  groupValue: _currentIndex,
                  onChanged: (ind) => setState(() => _currentIndex = ind),
                  title: Text(_listReason[index].reasonName),
                );
              },
              itemCount: _listReason.length,
            ),
          ),
          new SizedBox(
            height: 20.0,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new RaisedButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontFamily: 'Work Sans',
                    color: ColorLibrary.thinFontWhite,
                  ),
                ),
                color: ColorLibrary.primary,
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              new RaisedButton(
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontFamily: 'Work Sans',
                    color: ColorLibrary.thinFontBlack,
                  ),
                ),
                color: ColorLibrary.secondary,
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                onPressed: () {
                  if (_currentIndex - 1 >= 0) {
                    _forceCheckout();
                  } else {
                    Fluttertoast.showToast(
                      msg: "Please select the reason first",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
