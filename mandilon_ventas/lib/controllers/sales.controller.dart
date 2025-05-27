import '../models/city.model.dart' as city;
import '../models/employee.model.dart';
import '../models/store.model.dart' as store;

class SalesController {

  List<city.City> cities = [
    city.City(
      name: 'Ciudad A',
      stores: [
        store.Store(
          name: 'Tienda 1',
          employees: [
            Employee(name: 'Joan', sales: 300.0),
            Employee(name: 'Oswaldo', sales: 400.0),
          ],
        ),
        store.Store(
          name: 'Tienda 2',
          employees: [
            Employee(name: 'Juan', sales: 500.0),
            Employee(name: 'David', sales: 600.0),
          ],
        ),
      ],
    ),
    city.City(
      name: 'Ciudad B',
      stores: [
        store.Store(
          name: 'Tienda 3',
          employees: [
            Employee(name: 'Ruben', sales: 700.0),
            Employee(name: 'Dario', sales: 800.0),
          ],
        ),
        store.Store(
          name: 'Tienda 4',
          employees: [
            Employee(name: 'Edison', sales: 900.0),
            Employee(name: 'Damina', sales: 1000.0),
          ],
        ),
      ],
    ),
    city.City(
      name: 'Ciudad C',
      stores: [
        store.Store(
          name: 'Tienda 5',
          employees: [
            Employee(name: 'Doris', sales: 900.0),
          ],
        ),
      ],
    ),
  ];

  List<city.City> getCities() {
    return cities;
  }

  double get storeTarget => 1000.0;
  double get totalSales {
    return cities.fold(0.0, (sum, c) => sum + c.totalSales);
  }

  double updateEmployeeSales(
      String cityName, String storeName, String employeeName, double newSales) {
    for (var city in cities) {
      if (city.name == cityName) {
        for (var store in city.stores) {
          if (store.name == storeName) {
            for (var employee in store.employees) {
              if (employee.name == employeeName) {
                employee.sales = newSales;
                return totalSales;
              }
            }
          }
        }
      }
    }
    return totalSales;
  }
}