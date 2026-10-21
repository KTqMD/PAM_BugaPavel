import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:medical_app_lab3/data/repositories/medical_repository.dart';
import 'package:medical_app_lab3/logic/home/home_cubit.dart';
import 'package:medical_app_lab3/logic/home/home_state.dart';
import 'package:medical_app_lab3/main.dart';

const _repository = MedicalRepository(delay: Duration.zero);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeCubit', () {
    late HomeCubit cubit;

    setUp(() async {
      cubit = HomeCubit(_repository);
      await cubit.load();
    });

    tearDown(() => cubit.close());

    List<String> names() =>
        (cubit.state as HomeSuccess).doctors.map((d) => d.name).toList();

    test('incarca datele din JSON', () {
      expect(cubit.state, isA<HomeSuccess>());
      expect(names(), [
        'Dr. Emmly Lestiryno',
        'Dr. Sonja Litel',
        'Dr. Richar Kandowen',
        'Dr.Upul',
      ]);
    });

    test('cautare dupa nume sau specialitate', () {
      cubit.search('dental');
      expect(names(), ['Dr. Sonja Litel']);
    });

    test('filtrare dupa serviciu', () {
      cubit.toggleService('tooth');
      expect(names(), ['Dr. Sonja Litel', 'Dr.Upul']);

      cubit.toggleService('tooth');
      expect(names().length, 4);
    });

    test('sortare', () {
      cubit.setSort(DoctorSort.nameDesc);
      expect(names().first, 'Dr.Upul');

      cubit.setSort(DoctorSort.nearest);
      expect(names().first, 'Dr. Emmly Lestiryno');
      expect(names().last, 'Dr.Upul');
    });

    test('favorite', () {
      cubit.setFavoritesOnly(true);
      expect(names(), ['Dr. Richar Kandowen']);

      cubit.toggleFavorite('doctor-003');
      expect(cubit.state, isA<HomeEmpty>());

      cubit.toggleFavorite('doctor-001');
      expect(names(), ['Dr. Emmly Lestiryno']);
    });

    test('stare Empty cand nimic nu corespunde', () {
      cubit.search('zzz');
      expect(cubit.state, isA<HomeEmpty>());

      cubit.clearFilters();
      expect(cubit.state, isA<HomeSuccess>());
    });

    test('stare Error cand fisierul lipseste', () async {
      final broken = HomeCubit(
        const MedicalRepository(
          assetPath: 'assets/data/missing.json',
          delay: Duration.zero,
        ),
      );
      await broken.load();
      expect(broken.state, isA<HomeError>());
      await broken.close();
    });
  });

  group('ecrane', () {
    Future<void> start(WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 1100));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const MedicalApp(repository: _repository));
    }

    // Așteaptă terminarea încărcării asincrone
    Future<void> waitFor(WidgetTester tester, Finder finder) async {
      for (var i = 0; i < 50 && finder.evaluate().isEmpty; i++) {
        // Citirea fișierului este I/O real, deci are nevoie de timp real
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)),
        );
        await tester.pump(const Duration(milliseconds: 20));
      }
      expect(finder, findsWidgets);
    }

    testWidgets('Loading, apoi lista de medici', (tester) async {
      await start(tester);
      expect(find.text('Loading doctors...'), findsOneWidget);

      await waitFor(tester, find.text('Nearby Doctor'));
      expect(find.text('Dr. Sonja Litel'), findsOneWidget);
    });

    testWidgets('cautare fara rezultat arata Empty', (tester) async {
      await start(tester);
      await waitFor(tester, find.text('Nearby Doctor'));

      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pump();
      expect(find.text('No doctors found'), findsOneWidget);

      await tester.tap(find.text('Clear filters'));
      await tester.pump();
      expect(find.text('Dr. Sonja Litel'), findsOneWidget);
      expect(find.text('zzz'), findsNothing);
    });

    testWidgets('navigare la detalii si rezervare', (tester) async {
      await start(tester);
      await waitFor(tester, find.text('Nearby Doctor'));

      await tester.tap(find.text('Dr.Upul'));
      await waitFor(tester, find.text('Book an Appointment'));
      expect(find.text('\$120.00'), findsOneWidget);

      // Lasă animația de navigare să se termine
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mon 5'));
      await tester.pump();
      await tester.tap(find.text('Book an Appointment'));
      await tester.pump();

      expect(find.text('Booked with Dr.Upul: Mon 5, 11.00 AM'), findsOneWidget);
    });
  });
}
