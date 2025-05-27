import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../controllers/sales.controller.dart';

class SalesOverviewPage extends StatefulWidget {
  const SalesOverviewPage({super.key});

  @override
  _SalesOverviewPageState createState() => _SalesOverviewPageState();
}

class _SalesOverviewPageState extends State<SalesOverviewPage> {
  final player = AudioPlayer();
  final SalesController salesController = SalesController();
  final double storeTarget = 1000.0; // Objetivo de ventas por tienda
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = salesController.getCities();

    return Scaffold(
      appBar: AppBar(
        title: Text('El Mandilón Ventas'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, cityIdx) {
          final city = data[cityIdx];
          return ExpansionTile(
            title: Text('${city.name}  — Total: \$${city.totalSales.toStringAsFixed(2)}'),
            children: city.stores.map((store) {
              // Reproducir sonido si supera objetivo
              if (store.totalSales > storeTarget) {
                player.play(AssetSource('sounds/notify.mp3'));
              }
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${store.name}  — Total: \$${store.totalSales.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 120,
                        child: Image.network(
                          'https://mi-servidor.com/charts/${store.name}.png',
                          loadingBuilder: (ctx, child, progress) {
                            if (progress == null) return child;
                            return Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (_, __, ___) =>
                              Center(child: Icon(Icons.broken_image)),
                        ),
                      ),

                      ...store.employees.map((emp) => ListTile(
                            dense: true,
                            title: Text(emp.name),
                            trailing: Text('\$${emp.sales.toStringAsFixed(2)}'),
                          )),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
