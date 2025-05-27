import 'store.model.dart';

class City {
  String name;
  final List<Store> stores;
  City({required this.name, required this.stores});

  double get totalSales =>
      stores.fold(0, (sum, s) => sum + s.totalSales);
}