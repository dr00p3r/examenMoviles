import 'employee.model.dart';

class Store {
  final String name;
  final List<Employee> employees;
  Store({required this.name, required this.employees});
  
  double get totalSales =>
      employees.fold(0, (sum, e) => sum + e.sales);
}