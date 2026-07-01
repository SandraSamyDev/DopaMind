
import 'package:flutter_test/flutter_test.dart';
import 'package:dopamind/main.dart';
import 'package:dopamind/widgets/gradient_button.dart';

void main() {
  testWidgets('DopaMind Authentication UI Smoke Test', (WidgetTester tester) async {
    // 1. Build our real DopaMind application frame layer
    await tester.pumpWidget(const DopaMindApp());

    // 2. Allow any background routing or splash animations to complete
    await tester.pumpAndSettle();

    // 3. Verify that the welcome text assets are found on screen
    // Note: Change 'Welcome Back' to 'Create Account' if your app boots to SignUp first
    expect(find.text('Welcome Back'), findsOneWidget);
    
    // 4. Verify that your custom action buttons are properly rendered
    expect(find.byType(GradientButton), findsOneWidget);
  });
}