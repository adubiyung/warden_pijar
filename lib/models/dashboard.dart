class DataVehicle {
  final int vehicleTypeID;
  final int vehicleTotal;
  final String vehicleTypeName;
  final String colors;

  DataVehicle({
    this.vehicleTypeID,
    this.vehicleTotal,
    this.vehicleTypeName,
    this.colors,
  });

  factory DataVehicle.fromJson(Map<String, dynamic> parsedJson) {
    return DataVehicle(
      vehicleTypeID: parsedJson['vehicle_type_id'],
      vehicleTotal: parsedJson['total'],
      vehicleTypeName: parsedJson['vehicle_type_name'],
      colors: parsedJson['colors'],
    );
  }
}

class DataIncome {
  final int transactionStatus;
  final int transactionTotal;

  DataIncome({this.transactionStatus, this.transactionTotal});

  factory DataIncome.fromJson(Map<String, dynamic> parsedJson) {
    return DataIncome(
      transactionStatus: parsedJson['transaction_status'],
      transactionTotal: parsedJson['total'],
    );
  }
}

class DataPeakDay {
  final String dateCheckin;
  final int dateTotal;

  DataPeakDay({this.dateCheckin, this.dateTotal});

  factory DataPeakDay.fromJson(Map<String, dynamic> parsedJson) {
    return DataPeakDay(
      dateCheckin: parsedJson['date_checkin'],
      dateTotal: parsedJson['total'],
    );
  }
}

class DataPeakHour {
  final double timeCheckin;
  final int timeTotal;

  DataPeakHour({this.timeCheckin, this.timeTotal});

  factory DataPeakHour.fromJson(Map<String, dynamic> parsedJson) {
    return DataPeakHour(
      timeCheckin: parsedJson['time_checkin'],
      timeTotal: parsedJson['total'],
    );
  }
}
