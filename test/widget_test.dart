import 'package:flutter_test/flutter_test.dart';
import 'package:kurie/main.dart';

void main() {
  testWidgets('Kurie app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KurieApp());
    // Verify onboarding screen loads
    expect(find.text('Skip'), findsOneWidget);
  });
}
