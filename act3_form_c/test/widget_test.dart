import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ia03_act3_form_c/main.dart';

void main() {
  Future<void> obre(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  }

  testWidgets('El títol porta el nom de l\'alumne', (tester) async {
    await obre(tester);
    expect(find.text('Jan González Romero'), findsOneWidget);
  });

  testWidgets('Sense omplir els obligatoris no s\'envia', (tester) async {
    await obre(tester);
    await tester.tap(find.byIcon(Icons.upload));
    await tester.pumpAndSettle();
    expect(find.text('Submission Completed'), findsNothing);
    expect(find.text('Revisa els camps marcats en vermell'), findsOneWidget);
  });

  testWidgets('Text de més de 10 caràcters dona error', (tester) async {
    await obre(tester);
    final textField = find.widgetWithText(TextField, 'Text Field');
    await tester.enterText(textField, '12345678901');
    await tester.pumpAndSettle();
    expect(find.textContaining('10'), findsWidgets);
  });

  testWidgets('Formulari vàlid mostra el resum', (tester) async {
    await obre(tester);
    await tester.tap(find.text('Flutter'));
    await tester.enterText(find.widgetWithText(TextField, 'Text Field'), 'Jan');
    await tester.tap(find.text('Option 2').last);
    await tester.tap(find.text('Dart'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Option 1').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.upload));
    await tester.pumpAndSettle();

    expect(find.text('Submission Completed'), findsOneWidget);
    expect(find.textContaining('choice_chip: Flutter'), findsOneWidget);
    expect(find.textContaining('text_field: Jan'), findsOneWidget);
    expect(find.textContaining('dropdown: Option 1'), findsOneWidget);
    expect(find.textContaining('radio_group: Option 2'), findsOneWidget);
    expect(find.textContaining('filter_chip: Dart'), findsOneWidget);
  });
}
