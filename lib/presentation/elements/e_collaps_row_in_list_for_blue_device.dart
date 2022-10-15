import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:smart_chess_board/presentation/elements/e_value_with_title_in_line.dart';
import 'package:smart_chess_board/presentation/elements/e_blue_properties_in_one_line.dart';

class ECollapsRowInListForBlueDevice extends StatelessWidget {
  const ECollapsRowInListForBlueDevice(
      {Key? key, required this.result, this.onTap})
      : super(key: key);

  final ScanResult result;
  final VoidCallback? onTap; // событие кнопки заголовка

  @override
  Widget build(BuildContext context) {
    // Сворачиваемый заголовок (свернуть/развернуть при нажатии на строку)
    return ExpansionTile(
      title: EBlueDevicePropertiesInOneLine(device: result.device, key: key),
      leading: Text(result.device.name.toUpperCase().contains("CHESS")
          ? "*"
          : ""), // First column
      // Любой Widget в заголовке (в нашем случаи Кнопка подключения/отключения)
      trailing: ElevatedButton(
        child: Text('CONNECT'),
        onPressed: (result.advertisementData.connectable) ? onTap : null,
      ),
      // Содержимое при разворачивании заголовка
      children: <Widget>[
        eValueWithTitleInOneLine(
            context, 'Local Name', result.advertisementData.localName),
      ],
    );
  }
}
