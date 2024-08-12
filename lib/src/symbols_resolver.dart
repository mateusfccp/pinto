// ignore_for_file: implementation_imports

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/src/util/sdk.dart';
import 'package:analyzer/src/context/packages.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/dart/sdk/sdk.dart';

import 'ast/statement.dart';
import 'import.dart';
import 'type.dart';

final class SymbolsResolver {
  SymbolsResolver({required this.projectRoot}) {
    final resourceProvider = PhysicalResourceProvider.INSTANCE;

    _analysisContextCollection = AnalysisContextCollection(
      includedPaths: [projectRoot],
      resourceProvider: resourceProvider,
    );

    _sdk = FolderBasedDartSdk(
      resourceProvider,
      resourceProvider.getFolder(getSdkPath()),
    );

    _packages = findPackagesFrom(
      resourceProvider,
      _analysisContextCollection.contexts.first.contextRoot.root,
    );
  }

  final String projectRoot;

  late AnalysisContextCollection _analysisContextCollection;
  late AbstractDartSdk _sdk;
  late Packages _packages;

  Future<List<Type>> getSymbolsFor({required ImportStatement statement}) async {
    final String uri;

    switch (statement.type) {
      case ImportType.dart:
        uri = _sdk.mapDartUri('dart:${statement.package}')!.fullName;
      case ImportType.package:
        final segments = statement.package.split('/');
        final package = segments.first;

        final String file;

        if (segments.length == 1) {
          file = '$package.dart';
        } else {
          file = '${segments.skip(1).join('/')}.dart';
        }

        uri = '${_packages[package]!.libFolder}/$file';
    }

    final library = await _analysisContextCollection.contexts.first.currentSession.getResolvedLibrary(uri);

    if (library is ResolvedLibraryResult) {
      return [
        for (var element in library.element.exportNamespace.definedNames.values)
          if (element is InterfaceElement)
            Type(
              name: element.name,
              package: uri,
              parameters: [
                for (final supertype in element.typeParameters)
                  Type(
                    name: supertype.name,
                    package: 'LOCAL',
                    parameters: [],
                  )
              ],
            ),
      ];
    } else {
      throw 'Heheheh';
    }
  }
}
