import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goalkeeper_trainer/main.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: GoalkeeperApp(hasKeepers: true),
      ),
    );

    expect(find.byType(GoalkeeperApp), findsOneWidget);
  });
}
