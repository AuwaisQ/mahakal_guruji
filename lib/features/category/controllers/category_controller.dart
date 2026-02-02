import 'package:flutter/material.dart';
import 'package:mahakal/data/model/api_response.dart';
import 'package:mahakal/features/category/domain/models/category_model.dart';
import 'package:mahakal/features/category/domain/services/category_service_interface.dart';
import 'package:mahakal/features/product/controllers/seller_product_controller.dart';
import 'package:mahakal/helper/api_checker.dart';
import 'package:mahakal/main.dart';
import 'package:mahakal/features/brand/controllers/brand_controller.dart';
import 'package:provider/provider.dart';

class CategoryController extends ChangeNotifier {
  final CategoryServiceInterface? categoryServiceInterface;
  CategoryController({required this.categoryServiceInterface});

  final List<CategoryModel> _categoryList = [];
  final List<CategoryModel> _categoryAllList = [];
  int? _categorySelectedIndex;

  List<CategoryModel> get categoryList => _categoryList;
  List<CategoryModel> get categoryAllList => _categoryAllList;
  int? get categorySelectedIndex => _categorySelectedIndex;

  Future<void> getCategoryList(bool reload) async {
    if (_categoryList.isEmpty || reload) {
      ApiResponse apiResponse = await categoryServiceInterface!.getList();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _categoryList.clear();
        _categoryAllList.clear();
        apiResponse.response!.data.forEach(
            (category) => _categoryList.add(CategoryModel.fromJson(category)));
        apiResponse.response!.data.forEach((category) =>
            _categoryAllList.add(CategoryModel.fromJson(category)));
        _categorySelectedIndex = 0;
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      notifyListeners();
    }
  }

  Future<void> getSellerWiseCategoryList(int sellerId) async {
    ApiResponse apiResponse =
        await categoryServiceInterface!.getSellerWiseCategoryList(sellerId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _categoryList.clear();
      apiResponse.response!.data.forEach(
          (category) => _categoryList.add(CategoryModel.fromJson(category)));
      _categorySelectedIndex = 0;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  List<int> selectedCategoryIds = [];
  void checkedToggleCategory(int index) {
    _categoryList[index].isSelected = !_categoryList[index].isSelected!;
    notifyListeners();
  }

  void checkedToggleSubCategory(int index, int subCategoryIndex) {
    _categoryList[index].subCategories![subCategoryIndex].isSelected =
        !_categoryList[index].subCategories![subCategoryIndex].isSelected!;
    notifyListeners();
  }

  void resetChecked(int? id, bool fromShop) {
    if (fromShop) {
      getSellerWiseCategoryList(id!);
      Provider.of<BrandController>(Get.context!, listen: false)
          .getSellerWiseBrandList(id);
      Provider.of<SellerProductController>(Get.context!, listen: false)
          .getSellerProductList(id.toString(), 1, "");
    } else {
      getCategoryList(true);
      Provider.of<BrandController>(Get.context!, listen: false)
          .getBrandList(true);
    }
  }

  void changeSelectedIndex(int selectedIndex) {
    _categorySelectedIndex = selectedIndex;
    notifyListeners();
  }
}
