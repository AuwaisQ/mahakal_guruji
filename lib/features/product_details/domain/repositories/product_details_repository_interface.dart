import 'package:mahakal/interface/repo_interface.dart';

abstract class ProductDetailsRepositoryInterface
    implements RepositoryInterface {
  Future<dynamic> getCount(String productID);
  Future<dynamic> getSharableLink(String productID);
}
