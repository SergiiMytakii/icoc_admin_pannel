import 'dart:math';

import 'package:icoc_admin_pannel/domain/model/identifable.dart';

int calculateLastNumber<T extends Identifiable>(List<T> items) {
  final ids = items.map((item) => item.id).toList();
  final maximum = ids.reduce(max);
  return maximum;
}
