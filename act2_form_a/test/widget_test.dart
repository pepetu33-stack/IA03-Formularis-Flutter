import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ia03_act2_form_a/main.dart';

void main() {
  testWidgets('El FAB mostra el Map amb els valors del formulari', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('below 40km/h'));
    await tester.enterText(find.byType(TextField), 'no doubts');
    await tester.pump();

    await tester.tap(find.byIcon(Icons.upload));
    await tester.pumpAndSettle();

    expect(find.text('Submission Completed'), findsOneWidget);
    expect(find.textContaining('speed: below 40km/h'), findsOneWidget);
    expect(find.textContaining('remark: no doubts'), findsOneWidget);
  });
}
