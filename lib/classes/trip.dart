import 'package:flutter/material.dart';

class Trip {
  final String consumerName,
      DriverName,
      vehicleName,
      fairs,
      destinationAddress,
      dateTime;

  Trip(
      {this.consumerName,
      this.DriverName,
      this.vehicleName,
      this.fairs,
      this.destinationAddress,
      this.dateTime});
}
