import 'package:flutter/material.dart';
import 'package:mahakal/data/model/api_response.dart';
import 'package:mahakal/features/deal/domain/services/featured_deal_service_interface.dart';
import 'package:mahakal/features/product/domain/models/product_model.dart';

import 'package:mahakal/helper/api_checker.dart';

class FeaturedDealController extends ChangeNotifier {
  final FeaturedDealServiceInterface featuredDealServiceInterface;
  FeaturedDealController({required this.featuredDealServiceInterface});

  int? _featuredDealSelectedIndex;
  List<Product>? _featuredDealProductList;
  List<Product>? get featuredDealProductList => _featuredDealProductList;
  int? get featuredDealSelectedIndex => _featuredDealSelectedIndex;

  Future<void> getFeaturedDealList(bool reload) async {
    _featuredDealProductList = [];
    ApiResponse apiResponse =
        await featuredDealServiceInterface.getFeaturedDeal();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200 &&
        apiResponse.response!.data.toString() != '{}') {
      _featuredDealProductList = [];
      apiResponse.response!.data.forEach(
          (fDeal) => _featuredDealProductList?.add(Product.fromJson(fDeal)));
      _featuredDealSelectedIndex = 0;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void changeSelectedIndex(int selectedIndex) {
    _featuredDealSelectedIndex = selectedIndex;
    notifyListeners();
  }
}
