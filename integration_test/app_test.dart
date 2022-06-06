import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo/main.dart';
import 'package:todo/model/task.dart';
import 'package:todo/widget/dialog/new_task_dialog.dart';
import 'package:todo/widget/task_card.dart';

String generateRandomString(int minLength, int maxLength) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(r.nextInt(maxLength - minLength) + minLength, (index) => r.nextInt(33) + 89));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Add new task by tap on the (+) button, then update "completed state" of task', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Finds the (+) button.
      final Finder createBtn = find.byTooltip('Create new task');
      // Emulate a tap on the (+) button.
      await tester.tap(createBtn);
      // Trigger a frame.
      await tester.pumpAndSettle();

      // Find the dialog
      Finder dialog = find.byType(NewTaskDialog);
      expect(dialog, findsOneWidget);
      //Fill in the name and description
      String name = generateRandomString(6, 10);
      await tester.enterText(find.bySemanticsLabel('Name'), name);
      await tester.enterText(find.bySemanticsLabel('Description'), generateRandomString(12, 20));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.text('Create'));
      // Trigger a frame.
      await tester.pumpAndSettle();
      expect(find.text(name), findsOneWidget);

      // Finds the checkbox
      final Finder checkboxFinder = find.byType(Checkbox);
      var checkbox = tester.firstWidget(checkboxFinder) as Checkbox;
      // Emulate a tap on the checkbox
      await tester.tap(checkboxFinder);
      // Trigger a frame.
      await tester.pumpAndSettle();
      expect((tester.firstWidget(checkboxFinder) as Checkbox).value, true);
      await tester.pump(const Duration(milliseconds: 500));
      // Emulate a tap again on the checkbox
      await tester.tap(checkboxFinder);
      // Trigger a frame.
      await tester.pumpAndSettle();
      expect((tester.firstWidget(checkboxFinder) as Checkbox).value, false);
    });
  });
}
