import 'package:test/test.dart';

import '../../tool/test_program.dart';

Future<void> main() async {
  await testProgram(
    'Function call with single pseudo-positional arguments',
    '''
let createMessage () = "Hello, world!"
let printMessage (:ignored String, :message String) = print message

let main () = printMessage (:ignored "ignores", :message createMessage ())
''',
    (stdout) {
      expect(stdout, 'Hello, world!\n');
    },
  );

  await testProgram(
    'Function call with single named argument',
    '''
let printMessage (:message String) = print message

let main () = printMessage (:message "Hello, world!")
''',
    (stdout) {
      expect(stdout, "Hello, world!\n");
    },
  );

  await testProgram(
    'Function call with nested named argument',
    '''
let createMessage () = "Hello, world!"
let printMessage (:message String) = print message

let main () = printMessage (:message createMessage ())
''',
    (stdout) async {
      expect(stdout, 'Hello, world!\n');
    },
  );

  await testProgram(
    'Function call with multiple named arguments',
    '''
let createMessage () = "Hello, world!"
let printMessage (:ignored String, :message String) = print message

let main () = printMessage (:ignored "ignores", :message createMessage ())
''',
    (stdout) {
      expect(stdout, 'Hello, world!\n');
    },
  );
}
