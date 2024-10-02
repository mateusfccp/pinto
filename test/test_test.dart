import 'package:test/test.dart';

import '../tool/tester.dart';

void main() {
  // final directory = Directory('.');

  // for (final file in directory) {
  // }

  test('Test', () async {
    final tester = Tester.path('test/test_test.pinto');
    final expectator = ErrorExpectator('test/test_test.pinto');
    final expectations = await tester.getExpectations().toList();
    final errors = (expectator..expect()).expectations;
    expect(
      errors,
      emitsInOrder([emitsInAnyOrder(expectations), emitsDone]),
    );
  });
}
