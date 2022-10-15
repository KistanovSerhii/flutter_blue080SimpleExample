import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class EBlueDevicePropertiesInOneLine extends StatelessWidget {
  const EBlueDevicePropertiesInOneLine({Key? key, required this.device})
      : super(key: key);

  final BluetoothDevice device;

  // Представление bluetooth устройств одной строкой
  // Presentation bluetooth device's properties as one string
  @override
  Widget build(BuildContext context) {
    if (device.name.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            device.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      // if devices without name
      return Text(device.id.toString());
    }
  }
}
