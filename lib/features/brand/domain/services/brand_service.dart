import 'package:mahakal/features/brand/domain/repositories/brand_repo_interface.dart';
import 'package:mahakal/features/brand/domain/services/brand_service_interface.dart';

class BrandService implements BrandServiceInterface {
  BrandRepoInterface brandRepoInterface;
  BrandService({required this.brandRepoInterface});

  @override
  Future getList() {
    return brandRepoInterface.getList();
  }

  @override
  Future getSellerWiseBrandList(int sellerId) {
    return brandRepoInterface.getSellerWiseBrandList(sellerId);
  }
}
