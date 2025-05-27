import '../models/city.model.dart' as city;
import '../models/employee.model.dart';
import '../models/store.model.dart' as store;

class SalesController {

  List<city.City> cities = [
    city.City(
      name: 'City A',
      stores: [
        store.Store(
          name: 'Store 1',
          employees: [
            Employee(name: 'Joan', sales: 300.0),
            Employee(name: 'Oswaldo', sales: 400.0),
          ],
        ),
        store.Store(
          name: 'Store 2',
          employees: [
            Employee(name: 'Juan', sales: 500.0),
            Employee(name: 'David', sales: 600.0),
          ],
        ),
      ],
    ),
    city.City(
      name: 'City B',
      stores: [
        store.Store(
          name: 'Store 3',
          employees: [
            Employee(name: 'Ruben', sales: 700.0),
            Employee(name: 'Dario', sales: 800.0),
          ],
        ),
        store.Store(
          name: 'Store 4',
          employees: [
            Employee(name: 'Edison', sales: 900.0),
            Employee(name: 'Damina', sales: 1000.0),
          ],
        ),
      ],
    ),
    city.City(
      name: 'City C',
      stores: [
        store.Store(
          name: 'Store 5',
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
}