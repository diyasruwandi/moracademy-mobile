import 'package:flutter_test/flutter_test.dart';
import 'package:moracademy_mobile/main.dart';

void main() {
  testWidgets('Moracademy app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MoracademyApp());
    await tester.pump();
  });
}
