import 'dart:io';

import 'package:path/path.dart';
import 'package:test/test.dart';

import '../tool/expectation_tester.dart';

void main() async {
  final directory = Directory('test/static_tests');

  await for (final file in directory.list()) {
    if (file is File && extension(file.path) == '.pinto') {
      _testFile(file.path);
    }
  }
}

void _testFile(String path) {
  test(
    basename(path),
    () async {
      final expectationParser = ExpectationsParser(path);
      final analyzer = ErrorAnalyzer(path);
      final expectations = await expectationParser.getExpectations().toList();
      final errors = (analyzer..analyze()).errors;

      final expectedEmits = expectations.isEmpty
          ? neverEmits(anything)
          : emitsInOrder([
              emitsInAnyOrder(expectations),
              emitsDone,
            ]);

      expect(errors, expectedEmits);
    },
  );
}
