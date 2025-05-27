import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';           // FilteringTextInputFormatter
import '../controllers/sales.controller.dart';

class SalesOverviewPage extends StatefulWidget {
  const SalesOverviewPage({super.key});

  @override
  State<SalesOverviewPage> createState() => _SalesOverviewPageState();
}

class _SalesOverviewPageState extends State<SalesOverviewPage> {
  final _player = AudioPlayer();
  final _controller = SalesController();

  final _cityTargetCtrl     = TextEditingController(text: '5000');
  final _storeTargetCtrl    = TextEditingController(text: '1000');
  final _employeeTargetCtrl = TextEditingController(text: '500');

  double _cityTarget     = 5000;
  double _storeTarget    = 1000;
  double _employeeTarget = 500;

  final _formKey = GlobalKey<FormState>();

  final _numRegExp = RegExp(r'^\d*\.?\d*$');
  TextInputFormatter get _numericFormatter =>
      FilteringTextInputFormatter.allow(_numRegExp);

  @override
  void dispose() {
    _player.dispose();
    _cityTargetCtrl.dispose();
    _storeTargetCtrl.dispose();
    _employeeTargetCtrl.dispose();
    super.dispose();
  }

  void _applyTargets() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _cityTarget     = double.parse(_cityTargetCtrl.text);
        _storeTarget    = double.parse(_storeTargetCtrl.text);
        _employeeTarget = double.parse(_employeeTargetCtrl.text);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Objetivos actualizados')),
      );
    }
  }
  void _editEmployeeSales({
    required String city,
    required String store,
    required String employee,
    required double currentSales,
  }) {
    final _editCtrl =
        TextEditingController(text: currentSales.toStringAsFixed(2));
    final _numExp = RegExp(r'^\d*\.?\d*$');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Actualizar ventas de $employee'),
        content: TextFormField(
          controller: _editCtrl,
          autofocus: true,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true, signed: false),
          inputFormatters: [FilteringTextInputFormatter.allow(_numExp)],
          decoration: const InputDecoration(
            labelText: 'Nuevo monto',
            prefixText: '\$',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final txt = _editCtrl.text.trim();
              if (txt.isEmpty || !_numExp.hasMatch(txt)) return;
              final newSales = double.parse(txt);

              _controller.updateEmployeeSales(
                city,
                store,
                employee,
                newSales,
              );

              setState(() {});

              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cities = _controller.getCities();
    final totalChainSales =
        cities.fold<double>(0, (sum, c) => sum + c.totalSales);

    return Scaffold(
      appBar: AppBar(
        title: const Text('El Mandilón Ventas'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Objetivos de Ventas',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildTargetField(
                          label: 'Ciudad',
                          controller: _cityTargetCtrl,
                        ),
                        const SizedBox(width: 8),
                        _buildTargetField(
                          label: 'Tienda',
                          controller: _storeTargetCtrl,
                        ),
                        const SizedBox(width: 8),
                        _buildTargetField(
                          label: 'Empleado',
                          controller: _employeeTargetCtrl,
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _applyTargets,
                          child: const Text('Aplicar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: cities.length,
              itemBuilder: (_, cityIdx) {
                final city = cities[cityIdx];
                final cityHitTarget = city.totalSales >= _cityTarget;

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: ExpansionTile(
                      onExpansionChanged: (expanded) async {
                        if (expanded && cityHitTarget) {
                          await _player.stop();
                          await _player.play(
                            AssetSource('sounds/notify.mp3'),
                            volume: 0.8,
                          );
                        }
                      },
                      leading: Icon(
                        cityHitTarget
                            ? Icons.emoji_events
                            : Icons.location_city,
                      ),
                      title: _tileTitle(
                        city.name,
                        city.totalSales,
                        cityHitTarget,
                      ),
                      children: city.stores.map((store) {
                        final storeHitTarget =
                            store.totalSales >= _storeTarget;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: ExpansionTile(
                            tilePadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            onExpansionChanged: (expanded) async {
                              if (expanded && storeHitTarget) {
                                await _player.stop();
                                await _player.play(
                                  AssetSource('sounds/notify.mp3'),
                                  volume: 0.8,
                                );
                              }
                            },
                            leading: Icon(
                              storeHitTarget
                                  ? Icons.store_mall_directory
                                  : Icons.storefront,
                            ),
                            title: _tileTitle(
                              store.name,
                              store.totalSales,
                              storeHitTarget,
                            ),
                            childrenPadding:
                                const EdgeInsets.symmetric(horizontal: 24),
                            children: [
                              
                              SizedBox(
                                height: 120,
                                width: double.infinity,
                                
                                child:Image.network(
                                  (storeHitTarget) ? 
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6Q3cBlgsfQZP4ICpjcQBj4Pfsvld8tbYlB5Ull7rhlMq_fBraTNNDJyzTz9Pwk6T6g9U&usqp=CAU':
                                  'https://uni.edu.gt/wp-content/uploads/sites/19/2024/10/grafica_barras-1024x569.png',
                                  fit: BoxFit.fitHeight,
                                  errorBuilder: (_, __, ___) => const Center(
                                      child: Icon(Icons.broken_image)),
                                  loadingBuilder: (_, child, progress) =>
                                      progress == null
                                          ? child
                                          : const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                ),
                              ),
                              const SizedBox(height: 8),

                              ...store.employees.map(
                                (emp) => ListTile(
                                  dense: true,
                                  title: Text(emp.name),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('\$${emp.sales.toStringAsFixed(2)}'),
                                      const SizedBox(width: 6),
                                      Icon(
                                        emp.sales >= _employeeTarget
                                            ? Icons.check_circle
                                            : Icons.error_outline,
                                        color: emp.sales >= _employeeTarget
                                            ? Colors.green
                                            : Colors.redAccent,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.edit, size: 18, color: Colors.grey),
                                    ],
                                  ),
                                  onTap: () => _editEmployeeSales(
                                    city: city.name,
                                    store: store.name,
                                    employee: emp.name,
                                    currentSales: emp.sales,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              'TOTAL CADENA: \$${totalChainSales.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetField({
    required String label,
    required TextEditingController controller,
  }) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true, signed: false),
        inputFormatters: [_numericFormatter],
        decoration: InputDecoration(
          labelText: 'Obj. $label',
          isDense: true,
          border: const OutlineInputBorder(),
        ),
        validator: (v) =>
            (v == null || !_numRegExp.hasMatch(v) || v.isEmpty)
                ? 'Núm.'
                : null,
      ),
    );
  }

  Widget _tileTitle(String name, double total, bool hit) {
    return Row(
      children: [
        Expanded(child: Text(name)),
        Text('\$${total.toStringAsFixed(2)}'),
        const SizedBox(width: 8),
        Icon(
          hit ? Icons.check_circle : Icons.close,
          color: hit ? Colors.green : Colors.redAccent,
          size: 18,
        ),
      ],
    );
  }
}
