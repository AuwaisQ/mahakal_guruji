import 'package:mahakal/interface/repo_interface.dart';

abstract class FlashDealRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getFlashDeal();
}
