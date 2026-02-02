import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/features/category/controllers/category_controller.dart';
import 'package:mahakal/features/category/widgets/category_widget.dart';
import 'package:mahakal/features/product/screens/brand_and_category_product_screen.dart';
import 'package:mahakal/localization/controllers/localization_controller.dart';
import 'package:provider/provider.dart';

import 'category_shimmer_widget.dart';

class CategoryListWidget extends StatelessWidget {
  final bool isHomePage;
  const CategoryListWidget({super.key, required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, categoryProvider, child) {
        return categoryProvider.categoryAllList.isNotEmpty
            ? SizedBox(
                height:
                    Provider.of<LocalizationController>(context, listen: false)
                            .isLtr
                        ? MediaQuery.of(context).size.width / 3.7
                        : MediaQuery.of(context).size.width / 3,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryProvider.categoryAllList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => BrandAndCategoryProductScreen(
                                      isBrand: false,
                                      id: categoryProvider
                                          .categoryAllList[index].id
                                          .toString(),
                                      name: categoryProvider
                                          .categoryAllList[index].name)));
                        },
                        child: CategoryWidget(
                            category: categoryProvider.categoryAllList[index],
                            index: index,
                            length: categoryProvider.categoryAllList.length));
                  },
                ),
              )
            : const CategoryShimmerWidget();
      },
    );
  }
}
