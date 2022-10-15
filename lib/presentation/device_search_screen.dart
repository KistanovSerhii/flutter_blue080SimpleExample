import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:smart_chess_board/presentation/elements/e_collaps_row_in_list_for_blue_device.dart';
import 'package:smart_chess_board/presentation/bluetooth_device_propertise.dart';

// Экран поиска bluetooth устройств (список найденых и кнопка "найти")
class DeviceSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Devices'),
        // *******Командная панель текущей формы******* +
        // ******************Start and Stop searshing BUTTON****************** +
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: FlutterBlue.instance.isScanning,
            initialData: false,
            builder: (c, snapshot) {
              VoidCallback? onPressedSearchBtn;
              Icon iconSearchBtn;
              Color backgroundColorSearchBtn;

              if (snapshot.data!) {
                onPressedSearchBtn = () => FlutterBlue.instance.stopScan();
                iconSearchBtn = const Icon(Icons.stop);
                backgroundColorSearchBtn = Colors.red;
              } else {
                onPressedSearchBtn = () => FlutterBlue.instance
                    .startScan(timeout: const Duration(seconds: 4));
                iconSearchBtn = const Icon(Icons.search);
                backgroundColorSearchBtn = Colors.lightBlue;
              }

              return FloatingActionButton(
                  child: iconSearchBtn,
                  onPressed: onPressedSearchBtn,
                  backgroundColor: backgroundColorSearchBtn);
            },
          )
        ],
        // ******************Start and Stop searshing BUTTON****************** -
        // *******Командная панель текущей формы******* -
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // ************************Список устройств к которым мы подключены/List of devices we are connected to************************ +
              // Только подключенные устройства/Connected devices only
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(const Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: const [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map((d) => ListTile(
                            title: Text(d.name),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return ElevatedButton(
                                    child: const Text('OPEN'),
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DevicePropertiesScreen(
                                                    device: d))),
                                  );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              // ************************Список устройств к которым мы подключены/List of devices we are connected to************************ -
              // ******************Список найденных устройств/List of found devices****************** +
              // Данный список НЕ содержит устройства к которым мы подключены/ This list does NOT contain the devices we are connected to
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: const [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map(
                        (r) => ECollapsRowInListForBlueDevice(
                          result: r,
                          // Подключиться к выбранному устройству и открыть форму свойств
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect();
                            return DevicePropertiesScreen(device: r.device);
                          })),
                        ),
                      )
                      .toList(),
                ),
              ),
              // ******************Список найденных устройств/List of found devices****************** -
            ],
          ),
        ),
      ),
    );
  }
}
