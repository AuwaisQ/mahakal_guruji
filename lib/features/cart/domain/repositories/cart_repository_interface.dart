import 'package:mahakal/features/cart/domain/models/cart_model.dart';
import 'package:mahakal/features/product/domain/models/product_model.dart';
import 'package:mahakal/interface/repo_interface.dart';

abstract class CartRepositoryInterface<T> implements RepositoryInterface {
  Future<dynamic> addToCartListData(CartModelBody cart,
      List<ChoiceOptions> choiceOptions, List<int>? variationIndexes);

  Future<dynamic> updateQuantity(int? key, int quantity);
}
