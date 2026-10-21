// Laborator 1 - Varianta 2: Calculator IMC
// Student: Buga Pavel

import 'package:flutter/material.dart';

void main() {
  runApp(const ImcApp());
}

class ImcApp extends StatelessWidget {
  const ImcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator IMC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ImcPage(),
    );
  }
}

class ImcPage extends StatefulWidget {
  const ImcPage({super.key});

  @override
  State<ImcPage> createState() => _ImcPageState();
}

class _ImcPageState extends State<ImcPage> {
  final _greutateController = TextEditingController();
  final _inaltimeController = TextEditingController();

  String _rezultat = 'Introduceți greutatea și înălțimea';
  Color _culoare = Colors.black87;

  @override
  void dispose() {
    _greutateController.dispose();
    _inaltimeController.dispose();
    super.dispose();
  }

  // Acceptă atât punctul, cât și virgula ca separator zecimal
  double? _citeste(TextEditingController controller) {
    return double.tryParse(controller.text.trim().replaceAll(',', '.'));
  }

  String _categorie(double imc) {
    if (imc < 18.5) return 'Subponderal';
    if (imc < 25) return 'Normal';
    if (imc < 30) return 'Supraponderal';
    if (imc < 35) return 'Obezitate gradul I';
    if (imc < 40) return 'Obezitate gradul II';
    return 'Obezitate gradul III';
  }

  Color _culoareCategorie(double imc) {
    if (imc < 18.5) return Colors.blue;
    if (imc < 25) return Colors.green;
    if (imc < 30) return Colors.orange;
    return Colors.red;
  }

  // Evenimentul de apăsare a butonului "Calculează"
  void _calculeaza() {
    FocusScope.of(context).unfocus();

    final greutate = _citeste(_greutateController);
    final inaltimeCm = _citeste(_inaltimeController);

    if (greutate == null ||
        inaltimeCm == null ||
        greutate <= 0 ||
        inaltimeCm <= 0) {
      setState(() {
        _rezultat = 'Date invalide! Introduceți valori numerice pozitive.';
        _culoare = Colors.red;
      });
      return;
    }

    final inaltimeM = inaltimeCm / 100;
    final imc = greutate / (inaltimeM * inaltimeM);

    setState(() {
      _rezultat = 'IMC: ${imc.toStringAsFixed(2)}\n'
          'Categoria: ${_categorie(imc)}';
      _culoare = _culoareCategorie(imc);
    });
  }

  void _reseteaza() {
    _greutateController.clear();
    _inaltimeController.clear();
    setState(() {
      _rezultat = 'Introduceți greutatea și înălțimea';
      _culoare = Colors.black87;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator IMC'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _greutateController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Greutate (kg)',
                hintText: 'ex. 70',
                prefixIcon: Icon(Icons.monitor_weight_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _inaltimeController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _calculeaza(),
              decoration: const InputDecoration(
                labelText: 'Înălțime (cm)',
                hintText: 'ex. 175',
                prefixIcon: Icon(Icons.height),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculeaza,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Calculează', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _reseteaza,
              child: const Text('Resetează'),
            ),
            const SizedBox(height: 24),
            Text(
              _rezultat,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _culoare,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
