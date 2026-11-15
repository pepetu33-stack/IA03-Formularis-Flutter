import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ia03_act1_dialegs/main.dart';

void main() {
  Future<void> escriu(WidgetTester tester, String text) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextField), text);
  }

  testWidgets('AlertDialog mostra el text entrat', (tester) async {
    await escriu(tester, 'Hola DAM');
    await tester.tap(find.text('1. AlertDialog'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Has escrit: Hola DAM'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('SimpleDialog retorna l\'opció triada', (tester) async {
    await escriu(tester, 'abc');
    await tester.tap(find.text('2. SimpleDialog'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mostra-ho al revés'));
    await tester.pumpAndSettle();
    expect(find.text('Invertit: cba'), findsOneWidget);
  });

  testWidgets('BottomSheet mostra el text entrat', (tester) async {
    await escriu(tester, 'Flutter');
    await tester.tap(find.text('3. BottomSheet'));
    await tester.pumpAndSettle();
    expect(find.text('ModalBottomSheet'), findsOneWidget);
    expect(find.text('Flutter'), findsWidgets);
  });

  testWidgets('CupertinoAlertDialog pot esborrar el camp', (tester) async {
    await escriu(tester, 'iOS');
    await tester.tap(find.text('4. CupertinoAlertDialog'));
    await tester.pumpAndSettle();
    expect(find.text('Has escrit: iOS'), findsOneWidget);
    await tester.tap(find.text('Esborrar'));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, isEmpty);
  });
}
