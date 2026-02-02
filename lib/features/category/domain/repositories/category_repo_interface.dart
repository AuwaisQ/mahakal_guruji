import 'package:mahakal/interface/repo_interface.dart';

abstract class CategoryRepoInterface extends RepositoryInterface {
  Future<dynamic> getSellerWiseCategoryList(int sellerId);
}
