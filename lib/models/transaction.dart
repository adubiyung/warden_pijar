import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:warden_pijar/views/widgets/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Transaction {
  final String message;
  final int status;
  final List<DataTransaction> datas;

  Transaction({this.message, this.status, this.datas});

  factory Transaction.fromJson(Map<String, dynamic> parsedJson) {
    List<dynamic> list = parsedJson['data'];
    List<DataTransaction> dataList =
        list.map((data) => DataTransaction.fromJson(data)).toList();
    return Transaction(
        message: parsedJson['message'],
        status: parsedJson['status'],
        datas: dataList);
  }

  static List<DataTransaction> parseData(dataJson) {
    var list = dataJson['data'] as List;
    List<DataTransaction> dataList =
        list.map((data) => DataTransaction.fromJson(data)).toList();
    return dataList;
  }
}

class DataTransaction {
  int transactionID;
  String transactionCode;
  int userID;
  Vehicle vehicle;
  int vehicleType;
  int featureID;
  FeatureType featureType;
  Location location;
  PaymentType paymentType;
  Voucher voucher;
  int startPrice;
  int nextPrice;
  String startTime;
  String endTime;
  String checkinTime;
  String checkoutTime;
  int parkingBilling;
  int penaltyBilling;
  int voucherNominal;
  int totalBilling;
  int transactionStatus;
  int checkinBy;
  int checkoutBy;

  DataTransaction(
      {this.transactionID,
      this.transactionCode,
      this.userID,
      this.vehicle,
      this.vehicleType,
      this.featureID,
      this.featureType,
      this.location,
      this.paymentType,
      this.voucher,
      this.startPrice,
      this.nextPrice,
      this.startTime,
      this.endTime,
      this.checkinTime,
      this.checkoutTime,
      this.parkingBilling,
      this.penaltyBilling,
      this.voucherNominal,
      this.totalBilling,
      this.transactionStatus,
      this.checkinBy,
      this.checkoutBy});

  factory DataTransaction.fromJson(Map<String, dynamic> parsedJson) {
    return DataTransaction(
      transactionID: parsedJson['transaction_id'],
      transactionCode: parsedJson['transaction_code'],
      userID: parsedJson['user_id'],
      vehicle: Vehicle.fromJson(parsedJson['vehicle_id']),
      vehicleType: parsedJson['vehicle_type_id'],
      featureID: parsedJson['feature_id'],
      featureType: FeatureType.fromJson(parsedJson['feature_type_id']),
      location: Location.fromJson(parsedJson['location_id']),
      paymentType: PaymentType.fromJson(parsedJson['payment_type_id']),
      voucher: Voucher.fromJson(parsedJson['voucher_id']),
      startPrice: parsedJson['start_price'],
      nextPrice: parsedJson['next_price'],
      startTime: parsedJson['start_time'],
      endTime: parsedJson['end_time'],
      checkinTime: parsedJson['checkin_time'],
      checkoutTime: parsedJson['checkout_time'],
      parkingBilling: parsedJson['parking_billing'],
      penaltyBilling: parsedJson['penalty_billing'],
      voucherNominal: parsedJson['voucher_nominal'],
      totalBilling: parsedJson['total_billing'],
      transactionStatus: parsedJson['transaction_status'],
      checkinBy: parsedJson['checkin_by'],
      checkoutBy: parsedJson['checkout_by'],
    );
  }

  static Future<List<DataTransaction>> getData(
      SessionManager _session, String url) async {
    var prefs = await SharedPreferences.getInstance();
    HashMap<String, String> user;
    _session = new SessionManager(prefs);
    user = _session.getUserSession();
    String token = user['USER_TOKEN'];

    var response = await http
        .get('$url', headers: {HttpHeaders.authorizationHeader: token});
    var jsonObject = jsonDecode(response.body);
    List<dynamic> _listData = (jsonObject as Map<String, dynamic>)['data'];
    List<DataTransaction> _data = [];
    for (int i = 0; i < _listData.length; i++) {
      _data.add(DataTransaction.fromJson(_listData[i]));
    }
    return _data;
  }
}

class Vehicle {
  final int vehicleID;
  final int vehicleTypeID;
  final String vehicleLicense;

  Vehicle({this.vehicleID, this.vehicleTypeID, this.vehicleLicense});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
        vehicleID: json['vehicle_id'],
        vehicleTypeID: json['vehicle_type_id'],
        vehicleLicense: json['vehicle_license']);
  }
}

class FeatureType {
  final int featureTypeID;
  final String featureName;
  final String featureDesc;

  FeatureType({this.featureTypeID, this.featureName, this.featureDesc});

  factory FeatureType.fromJson(Map<String, dynamic> json) {
    return FeatureType(
        featureTypeID: json['feature_type_id'],
        featureName: json['feature_name'],
        featureDesc: json['feature_desc']);
  }
}

class Location {
  final int locationID;
  final String locationName;
  final String locationAddress;
  final String locationCity;
  final String locationLatitude;
  final String locationLongitude;

  Location(
      {this.locationID,
      this.locationName,
      this.locationAddress,
      this.locationCity,
      this.locationLatitude,
      this.locationLongitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        locationID: json['location_id'],
        locationName: json['location_name'],
        locationAddress: json['location_address'],
        locationCity: json['location_city'],
        locationLatitude: json['location_latitude'],
        locationLongitude: json['location_longitude']);
  }
}

class PaymentType {
  final int paymentTypeID;
  final String paymentTypeName;
  final String paymentTypeDesc;

  PaymentType({this.paymentTypeID, this.paymentTypeName, this.paymentTypeDesc});

  factory PaymentType.fromJson(Map<String, dynamic> json) {
    return PaymentType(
        paymentTypeID: json['payment_type_id'],
        paymentTypeName: json['payment_type_name'],
        paymentTypeDesc: json['payment_type_desc']);
  }
}

class Voucher {
  final int voucherID;
  final String voucherCode;

  Voucher({
    this.voucherID,
    this.voucherCode,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      voucherID: json['voucher_id'],
      voucherCode: json['voucher_code'],
    );
  }
}

class Scanning {
  final int vehicleID;
  final int vehicleTypeID;
  final int transactionStatus;
  final int brandID;
  final int modelID;
  final String vehicleLicense;
  final String brandName;
  final String modelName;
  final int featureID;
  final int startPrice;
  final int nextPrice;

  Scanning({
    this.vehicleID,
    this.vehicleTypeID,
    this.transactionStatus,
    this.brandID,
    this.modelID,
    this.vehicleLicense,
    this.brandName,
    this.modelName,
    this.featureID,
    this.startPrice,
    this.nextPrice,
  });

  factory Scanning.fromJson(Map<String, dynamic> json) {
    return Scanning(
      vehicleID: json['vehicle_id'],
      vehicleTypeID: json['vehicle_type_id'],
      transactionStatus: json['transaction_status'],
      brandID: json['vehicle_brand_id'],
      modelID: json['vehicle_model_id'],
      vehicleLicense: json['vehicle_license'],
      brandName: json['vehicle_brand_name'],
      modelName: json['vehicle_model_name'],
      featureID: json['feature_id'],
      startPrice: json['feature_startprice'],
      nextPrice: json['feature_nextprice'],
    );
  }
}

class Reason {
  final int reasonID;
  final String reasonName;
  final String reasonDesc;

  Reason({this.reasonID, this.reasonName, this.reasonDesc});

  factory Reason.fromJson(Map<String, dynamic> json) {
    return Reason(
      reasonID: json['checkout_reason_id'],
      reasonName: json['checkout_reason_name'],
      reasonDesc: json['checkout_reason_desc'],
    );
  }
}
