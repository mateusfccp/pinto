import 'package:test/test.dart';

import '../../tool/test_program.dart';

Future<void> main() async {
  await testProgram(
    'A type expectation can receive a subtype.',
    '''
let printNumber (:number num) = print number

let main () = printNumber (:number 42)
''',
    (stdout) {
      expect(stdout, '42\n');
    },
  );
}
