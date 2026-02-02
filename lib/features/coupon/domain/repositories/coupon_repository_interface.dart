import 'package:mahakal/interface/repo_interface.dart';

abstract class CouponRepositoryInterface<T> extends RepositoryInterface {
  Future<dynamic> getAvailableCouponList();

  Future<dynamic> getSellerCouponList(int sellerId, int offset);
}
