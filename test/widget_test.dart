import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/main.dart';

void main() {
  testWidgets('Aplikasi dapat dibuka', (WidgetTester tester) async {
    await tester.pumpWidget(const MyPortfolioApp());

    expect(find.byType(MyPortfolioApp), findsOneWidget);
  });
}
