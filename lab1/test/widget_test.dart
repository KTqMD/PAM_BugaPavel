import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculator_imc/main.dart';

void main() {
  testWidgets('calculeaza IMC si categoria', (WidgetTester tester) async {
    await tester.pumpWidget(const ImcApp());

    await tester.enterText(find.byType(TextField).at(0), '70');
    await tester.enterText(find.byType(TextField).at(1), '175');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.textContaining('IMC: 22.86'), findsOneWidget);
    expect(find.textContaining('Categoria: Normal'), findsOneWidget);
  });

  testWidgets('afiseaza eroare la date invalide', (WidgetTester tester) async {
    await tester.pumpWidget(const ImcApp());

    await tester.enterText(find.byType(TextField).at(0), 'abc');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.textContaining('Date invalide'), findsOneWidget);
  });
}
