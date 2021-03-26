import 'dart:io';
import 'dart:convert';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

class PackageApi {
  final List data = json.decode(File('packages.json').readAsStringSync());

  Router get router {
    final router = Router();

    router.get('/', (Request request) {
      return Response.ok(json.encode(data),
          headers: {'Content-Type': 'application/vnd.pub.v2+json'});
    });

    router.get('/<name>', (Request request, String name) {
      final package = data.firstWhere((package) => package['name'] == name,
          orElse: () => null);

      if (package != null) {
        return Response.ok(json.encode(package),
            headers: {'Content-Type': 'application/vnd.pub.v2+json'});
      }

      return Response.notFound('Package not found.');
    });

    router.get('/<name>/versions/<version>',
        (Request request, String name, String version) {
      var package_version;
      final package = data.firstWhere((package) => package['name'] == name,
          orElse: () => null);
      final package_with_version = package["versions"];

      if (package_with_version != null) {
        package_version = package_with_version.firstWhere(
            (package_verision) => package_verision['version'] == version,
            orElse: () => null);
        if (package_version != null) {
          return Response.ok(json.encode(package_version),
              headers: {'Content-Type': 'application/vnd.pub.v2+json'});
        }
      }

      return Response.notFound('Package not found.');
    });

    return router;
  }
}