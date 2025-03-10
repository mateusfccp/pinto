import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/memory_file_system.dart';
import 'package:analyzer/src/dart/sdk/sdk.dart';
import 'package:analyzer/src/test_utilities/mock_sdk.dart';
import 'package:pinto/ast.dart';
import 'package:pinto/error.dart';
import 'package:pinto/lexer.dart';
import 'package:pinto/semantic.dart';
import 'package:pinto/compiler.dart';
import 'package:test/test.dart';
import 'package:uuid/v1.dart';

final _uuid = UuidV1();

/// Creates a test case with the given [description] and [body] to test [source].
Future<void> testProgram(
  String description,
  String source,
  void Function(String stdout) body,
) async {
  final resourceProvider = MemoryResourceProvider();

  var sdkRoot = resourceProvider.newFolder(
    resourceProvider.convertPath('/sdk'),
  );

  createMockSdk(
    resourceProvider: resourceProvider,
    root: sdkRoot,
  );

  final id = _uuid.generate();

  final path = resourceProvider.convertPath('/{$id}.pinto');
  final file = resourceProvider.getFile(path);
  file.writeAsStringSync(source);

  final lexer = Lexer(source: source);
  final tokens = lexer.scanTokens();
  final parser = Parser(tokens: tokens);
  final program = parser.parse();

  final errorHandler = ErrorHandler();

  final analysisContextCollection = AnalysisContextCollection(
    includedPaths: [file.path],
    resourceProvider: resourceProvider,
    sdkPath: sdkRoot.path,
  );

  final sdk = FolderBasedDartSdk(
    resourceProvider,
    analysisContextCollection.contexts.first.sdkRoot!,
  );

  final symbolsResolver = SymbolsResolver(
    resourceProvider: resourceProvider,
    analysisContextCollection: analysisContextCollection,
    sdk: sdk,
  );

  final resolver = Resolver(
    program: program,
    symbolsResolver: symbolsResolver,
    errorHandler: errorHandler,
  );

  final programElement = await resolver.resolve();
  final compiler = Compiler(programElement);
  final temporaryFile = File('.$id.dart');
  final sink = temporaryFile.openWrite(mode: FileMode.writeOnly);

  compiler.write(sink);

  await sink.flush();
  await sink.close();

  final process = Process.runSync(
    'dart',
    [temporaryFile.path],
  );

  final stdout = process.stdout as String;

  test(
    description,
    () => body(stdout),
  );

  temporaryFile.deleteSync();
  await analysisContextCollection.dispose();
}
