import 'dart:io';

import 'package:lsp_server/lsp_server.dart';

import 'analyzer.dart';

void runServer() async {
  final connection = Connection(stdin, stdout);
  final analyzer = Analyzer();

  connection.onInitialize((params) async {
    if (params.workspaceFolders case final worksPaceFolders?) {
      for (final folder in worksPaceFolders) {
        final directory = Directory.fromUri(folder.uri);
        analyzer.addFileSystemEntity(directory);
      }
    } else if (params.rootUri case final uri?) {
      final directory = Directory.fromUri(uri);
      analyzer.addFileSystemEntity(directory);
    } else if (params.rootPath case final path?) {
      final directory = Directory(path);
      analyzer.addFileSystemEntity(directory);
    }

    return InitializeResult(
      capabilities: ServerCapabilities(
        textDocumentSync: const Either2.t1(TextDocumentSyncKind.Full),
      ),
    );
  });

  // Register a listener for when the client sends a notification when a text
  // document was opened.
  connection.onDidOpenTextDocument((parameters) async {
    final file = File.fromUri(parameters.textDocument.uri);
    analyzer.addFileSystemEntity(file);

    final diagnostics = await analyzer.analyze(
      parameters.textDocument.uri.path,
      parameters.textDocument.text,
    );

    // Send back an event notifying the client of issues we want them to render.
    // To clear issues the server is responsible for sending an empty list.
    connection.sendDiagnostics(
      PublishDiagnosticsParams(
        diagnostics: diagnostics,
        uri: parameters.textDocument.uri,
      ),
    );
  });

  // Register a listener for when the client sends a notification when a text
  // document was changed.
  connection.onDidChangeTextDocument((parameters) async {
    final contentChanges = parameters.contentChanges;
    final contentChange = TextDocumentContentChangeEvent2.fromJson(
      contentChanges[contentChanges.length - 1].toJson() as Map<String, Object?>,
    );

    final diagnostics = await analyzer.analyze(
      parameters.textDocument.uri.path,
      contentChange.text,
    );

    // Send back an event notifying the client of issues we want them to render.
    // To clear issues the server is responsible for sending an empty list.
    connection.sendDiagnostics(
      PublishDiagnosticsParams(
        diagnostics: diagnostics,
        uri: parameters.textDocument.uri,
      ),
    );
  });

  await connection.listen();
}
