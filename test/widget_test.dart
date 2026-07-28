import 'package:flutter_test/flutter_test.dart';
import 'package:adzanku/main.dart';

void main() {
  testWidgets('Adzanku app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AdzankuApp());
    expect(find.byType(AdzankuApp), findsOneWidget);
  });
}
