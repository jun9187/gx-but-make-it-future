import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:future_flow/app.dart';

void main() {
  testWidgets('renders FutureFlow dashboard shell', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FutureFlowApp()));

    await tester.pumpAndSettle();

    expect(find.text('FutureFlow'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Your money, made clearer'), findsOneWidget);
  });
}
