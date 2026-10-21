import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:medical_app/main.dart';

void main() {
  Future<void> porneste(WidgetTester tester) async {
    // Dimensiunea unui telefon, ca toate elementele să fie pe ecran
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MedicalApp());
  }

  testWidgets('navigheaza la Appointment si rezerva', (tester) async {
    await porneste(tester);

    expect(find.text('Hi, Jonathan'), findsOneWidget);

    await tester.tap(find.text('Dr. Sonja Littel'));
    await tester.pumpAndSettle();

    expect(find.text('Dental Specialist'), findsOneWidget);
    expect(find.text('\$100.00'), findsOneWidget);

    await tester.tap(find.text('Mon 5'));
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Programare: Mon 5, 11.00 AM'), findsOneWidget);
  });

  testWidgets('serviciile filtreaza medicii', (tester) async {
    await porneste(tester);

    expect(find.text('Dr. Emmly Lestiryno'), findsOneWidget);
    expect(find.text('Dr.Upul'), findsNothing);

    await tester.tap(find.text('Tooth'));
    await tester.pump();

    expect(find.text('Dr. Emmly Lestiryno'), findsNothing);
    expect(find.text('Dr. Sonja Littel'), findsOneWidget);
    expect(find.text('Dr.Upul'), findsOneWidget);

    // A doua apăsare scoate filtrul
    await tester.tap(find.text('Tooth'));
    await tester.pump();

    expect(find.text('Dr. Emmly Lestiryno'), findsOneWidget);
    expect(find.text('Dr.Upul'), findsNothing);
  });

  testWidgets('cautarea filtreaza medicii', (tester) async {
    await porneste(tester);

    await tester.enterText(find.byType(TextField), 'upul');
    await tester.pump();

    expect(find.text('Dr.Upul'), findsOneWidget);
    expect(find.text('Dr. Sonja Littel'), findsNothing);
  });
}
