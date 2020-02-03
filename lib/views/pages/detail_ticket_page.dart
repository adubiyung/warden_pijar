import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warden_pijar/models/transaction.dart';
import 'package:warden_pijar/services/api.dart';
import 'package:warden_pijar/views/pages/dialog_force_checkout.dart';
import 'package:warden_pijar/views/widgets/color_library.dart';
import 'package:warden_pijar/views/widgets/session_manager.dart';
import 'package:http/http.dart' as http;

class DetailTicketPage extends StatefulWidget {
  final DataTransaction modelTrans;
  const DetailTicketPage({Key key, this.modelTrans}) : super(key: key);

  @override
  _DetailTicketPageState createState() => _DetailTicketPageState();
}

class _DetailTicketPageState extends State<DetailTicketPage> {
  SessionManager _session;
  HashMap<String, String> userData;
  String url = BaseUrl.ESTIMATE;
  String checkout;
  int duration;
  int billing;
  String timeOut;
  var formatDateIn;
  var formatTimeIn;
  var formatDateOut;
  var formatTimeOut;

  Future<Null> _fetchData() async {
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    String token = userData['USER_TOKEN'];
    String clause =
        "?transaction_id=" + widget.modelTrans.transactionID.toString();

    final response = await http
        .get(url + clause, headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      final jsonObject = jsonDecode(response.body);
      var dataEst = (jsonObject as Map<String, dynamic>)['data'];

      setState(() {
        checkout = dataEst['checkout_time'];
        duration = dataEst['total_duration'];
        billing = dataEst['parking_billing'];
      });

      List<String> splitIn = [];
      var datein = widget.modelTrans.checkinTime;
      splitIn = datein.split("T");
      String tglin = splitIn[0];
      var parseDateIn = DateFormat("yyyy-MM-dd").parse(tglin);
      formatDateIn = DateFormat("EEE, MMM d").format(parseDateIn);

      String waktuIn = splitIn[1];
      var parseTimeIn = DateFormat("hh:mm:ss").parse(waktuIn);
      formatTimeIn = DateFormat("hh:mm a").format(parseTimeIn);

      List<String> splitOut = [];
      var dateout = checkout;
      splitOut = dateout.split("T");
      print(timeOut);
      String tglOut = splitOut[0];
      var parseDateOut = DateFormat("yyyy-MM-dd").parse(tglOut);
      formatDateOut = DateFormat("EEE, MMM d").format(parseDateOut);

      String waktuOut = splitOut[1];
      var parseTimeOut = DateFormat("h:m:s").parse(waktuOut);
      formatTimeOut = DateFormat("hh:mm a").format(parseTimeOut);
      
      timeOut = splitOut[0] + " " + splitOut[1];
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    Widget _locationContent = new Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.modelTrans.location.locationName,
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 18),
          ),
          Text(
            widget.modelTrans.location.locationAddress,
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 12),
          ),
          Text(
            widget.modelTrans.location.locationCity,
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 12),
          ),
        ],
      ),
    );

    Widget _durationContent = new Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(20.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                formatDateIn.toString(),
                style: TextStyle(fontFamily: 'Work Sans', fontSize: 10),
              ),
              Text(
                formatTimeIn.toString(),
                style: TextStyle(fontFamily: 'Work Sans', fontSize: 15),
              ),
            ],
          ),
          new Center(
            child: Container(
              height: 25.0,
              width: 90.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(14.0),
                color: ColorLibrary.background,
                border: Border.all(color: ColorLibrary.backgroundDark),
              ),
              child: Center(
                child: Text(
                  "$duration h",
                  style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                formatDateOut.toString(),
                style: TextStyle(fontFamily: 'Work Sans', fontSize: 10),
              ),
              Text(
                formatTimeOut.toString(),
                style: TextStyle(fontFamily: 'Work Sans', fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );

    Widget _voucherContent = new Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          Icons.local_play,
          color: ColorLibrary.primary,
        ),
        title: Text(
          "Gunakan promo",
          style:
              TextStyle(fontFamily: 'Work Sans', color: ColorLibrary.primary),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "choose",
              style: TextStyle(
                  fontFamily: 'Work Sans', color: ColorLibrary.primary),
            ),
            Icon(Icons.more_vert)
          ],
        ),
      ),
    );

    Widget _paymentTypeContent = new Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      color: Colors.white,
      child: ListTile(
          leading: Icon(
            Icons.account_balance_wallet,
            color: ColorLibrary.primary,
          ),
          title: Text(
            "Cash",
            style:
                TextStyle(fontFamily: 'Work Sans', color: ColorLibrary.primary),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Rp 10.000",
                style: TextStyle(
                    fontFamily: 'Work Sans', color: ColorLibrary.primary),
              ),
              Icon(Icons.more_vert)
            ],
          )),
    );

    Widget _paymentDetailContent = new Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Detail Payment",
              style: TextStyle(fontFamily: 'Work Sans', fontSize: 10),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 13.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Parking Fare',
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Subtotal',
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Voucher Discount',
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Total',
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Paid with LinkAja',
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Rp ' + widget.modelTrans.parkingBilling.toString(),
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 5.0,
                    ),
                    Text(
                      'Rp $billing',
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 5.0,
                    ),
                    Text(
                      'Rp ' + widget.modelTrans.voucherNominal.toString(),
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 5.0,
                    ),
                    Text(
                      "Rp 0",
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 5.0,
                    ),
                    Text(
                      'Rp ',
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 15.0,
              )
            ],
          ),
        ],
      ),
    );

    void _showModalFC(context, String transID) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return DialogForceCheckout(transID, duration.toString(), billing.toString(), billing.toString());
          });
    }

    Widget _checkOutContent = new Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(
              "Rp $billing",
              style: TextStyle(fontFamily: 'Work Sans'),
            ),
            new SizedBox(
              height: 15.0,
            ),
            (widget.modelTrans.transactionStatus < 4)
                ? new Center(
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width / 2,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(18.0),
                          side: BorderSide(color: ColorLibrary.secondary),
                        ),
                        color: ColorLibrary.secondary,
                        child: Text(
                          "Check Out",
                          style: TextStyle(fontFamily: 'Work Sans'),
                        ),
                        onPressed: () {
                          _showModalFC(context,
                              widget.modelTrans.transactionID.toString());
                        },
                      ),
                    ),
                  )
                : new Center(
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width / 2,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(18.0),
                          side: BorderSide(color: ColorLibrary.primary),
                        ),
                        color: ColorLibrary.secondary,
                        child: Text(
                          "Paid",
                          style: TextStyle(fontFamily: 'Work Sans'),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );

    Widget _titleContent = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          "Check-Out Ticket",
          style: TextStyle(
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: ColorLibrary.thinFontWhite),
        ),
        Text(
          "Ticket NO. ${widget.modelTrans.transactionCode}",
          style: TextStyle(
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w300,
              fontSize: 16,
              color: ColorLibrary.thinFontWhite),
        ),
      ],
    );

    return new SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            title: _titleContent,
            backgroundColor: ColorLibrary.primary,
          ),
        ),
        body: SingleChildScrollView(
          child: new Container(
            color: ColorLibrary.thinFontWhite,
            height: MediaQuery.of(context).size.height,
            child: new Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                _locationContent,
                SizedBox(
                  height: 10.0,
                ),
                _durationContent,
                SizedBox(
                  height: 10.0,
                ),
                _voucherContent,
                SizedBox(
                  height: 10.0,
                ),
                _paymentTypeContent,
                SizedBox(
                  height: 10.0,
                ),
                _paymentDetailContent,
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          child: _checkOutContent,
          height: MediaQuery.of(context).size.height / 5,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black45,
              spreadRadius: 3.0,
              blurRadius: 2.0,
            ),
          ]),
        ),
      ),
    );
  }
}
