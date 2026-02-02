import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/features/wallet/controllers/wallet_controller.dart';
import 'package:mahakal/features/wallet/domain/models/transaction_model.dart';
import 'package:mahakal/features/wallet/widgets/transaction_widget.dart';
import 'package:mahakal/utill/images.dart';
import 'package:mahakal/common/basewidget/no_internet_screen_widget.dart';
import 'package:mahakal/features/home/shimmers/transaction_shimmer.dart';
import 'package:provider/provider.dart';

class TransactionListView extends StatelessWidget {
  final ScrollController? scrollController;
  const TransactionListView({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if (scrollController!.position.maxScrollExtent ==
              scrollController!.position.pixels &&
          Provider.of<WalletController>(context, listen: false)
              .transactionList
              .isNotEmpty &&
          !Provider.of<WalletController>(context, listen: false).isLoading) {
        int? pageSize;
        pageSize = (Provider.of<WalletController>(context, listen: false)
                    .transactionPageSize! /
                10)
            .ceil();

        if (offset < pageSize) {
          offset++;
          if (kDebugMode) {
            print('end of the page');
          }
          Provider.of<WalletController>(context, listen: false)
              .showBottomLoader();
          Provider.of<WalletController>(context, listen: false)
              .getTransactionList(
                  context,
                  offset,
                  Provider.of<WalletController>(context, listen: false)
                      .selectedFilterType,
                  reload: false);
        }
      }
    });

    return Consumer<WalletController>(
      builder: (context, transactionProvider, child) {
        List<WalletTransactioList> transactionList;
        transactionList = transactionProvider.transactionList;

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          !transactionProvider.isLoading
              ? (transactionList.isNotEmpty)
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: transactionList.length,
                      itemBuilder: (ctx, index) {
                        return SizedBox(
                            width: (MediaQuery.of(context).size.width / 2) - 20,
                            child: TransactionWidget(
                                transactionModel: transactionList[index]));
                      })
                  : const NoInternetOrDataScreenWidget(
                      isNoInternet: false,
                      message: 'no_transaction_history',
                      icon: Images.noTransaction)
              : const TransactionShimmer()
        ]);
      },
    );
  }
}
