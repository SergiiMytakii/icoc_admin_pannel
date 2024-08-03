import 'dart:math';

import 'package:icoc_admin_pannel/domain/model/identifable.dart';

int calculateLastNumber<T extends Identifiable>(List<T> items) {
  if (items.isEmpty) {
    return 0;
  }
  final ids = items.map((item) => item.id).toList();
  print(ids.last);
  final maximum = ids.reduce(max);
  return maximum;
}
