// ignore_for_file: implementation_imports

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/src/context/packages.dart' hide Package;
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/src/dart/sdk/sdk.dart';

import 'package.dart';
import 'type.dart';

final class SymbolsResolver {
  SymbolsResolver({
    required this.resourceProvider,
    required this.analysisContextCollection,
    required this.sdk,
  }) {
    _packages = findPackagesFrom(
      resourceProvider,
      analysisContextCollection.contexts.first.contextRoot.root,
    );
  }

  final ResourceProvider resourceProvider;
  final AnalysisContextCollection analysisContextCollection;
  final AbstractDartSdk sdk;
  late Packages _packages;

  Future<List<Type>> getSymbolsForPackage({required Package package}) async {
    final uri = getUriFromPackage(package);

    if (uri == null) {
      throw _SymbolResolvingException(package);
    }

    final library = await analysisContextCollection.contexts.first.currentSession.getResolvedLibrary(uri);

    if (library is ResolvedLibraryResult) {
      return [
        for (var element in library.element.exportNamespace.definedNames.values)
          if (element is InterfaceElement)
            PolymorphicType(
              name: element.name,
              source: package,
              arguments: [
                for (final typeParameter in element.typeParameters) //
                  TypeParameterType(name: typeParameter.name),
              ],
            )
      ];
    } else {
      throw _SymbolResolvingException(package);
    }
  }

  String? getUriFromPackage(Package package) {
    switch (package) {
      case DartSdkPackage(:final name):
        return sdk.mapDartUri('dart:$name')?.fullName;
      case ExternalPackage(:final name):
        final parts = name.split('/');
        final package = parts.first;

        final String file;

        if (parts.length == 1) {
          file = '$package.dart';
        } else {
          file = '${parts.skip(1).join('/')}.dart';
        }

        final folder = _packages[package]?.libFolder;

        return folder == null ? null : '$folder/$file';
      case CurrentPackage():
        // TODO(mateusfccp): Handle this properly
        return null;
    }
  }
}

final class _SymbolResolvingException implements Exception {
  const _SymbolResolvingException(this.package);

  final Package package;
}
