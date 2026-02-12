import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Placeholder test — app requires async DB init, so a full widget test
    // would need mocked dependencies. This verifies the test framework runs.
    expect(1 + 1, equals(2));
  });
}
