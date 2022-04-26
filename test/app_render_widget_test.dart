import 'package:flutter_test/flutter_test.dart';
import 'package:internship_app_fis/main.dart' as main_file;

void main() {
  group('App run test:', () {
    testWidgets('the widget of the main app should be rendered',
        (WidgetTester tester) async {
      main_file.main();
      expect(find.byWidget(main_file.internshipApp), findsOneWidget);
    });
  });
}
