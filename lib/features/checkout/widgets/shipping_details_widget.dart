import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/features/address/controllers/address_controller.dart';
import 'package:mahakal/features/checkout/controllers/checkout_controller.dart';
import 'package:mahakal/localization/language_constrants.dart';
import 'package:mahakal/utill/custom_themes.dart';
import 'package:mahakal/utill/dimensions.dart';
import 'package:mahakal/utill/images.dart';
import 'package:mahakal/features/address/screens/saved_address_list_screen.dart';
import 'package:mahakal/features/address/screens/saved_billing_address_list_screen.dart';
import 'package:provider/provider.dart';

import '../../all_pandit/location_search_widget.dart';

class ShippingDetailsWidget extends StatefulWidget {
  final bool hasPhysical;
  final bool billingAddress;
  const ShippingDetailsWidget(
      {super.key, required this.hasPhysical, required this.billingAddress});

  @override
  State<ShippingDetailsWidget> createState() => _ShippingDetailsWidgetState();
}

class _ShippingDetailsWidgetState extends State<ShippingDetailsWidget> {
  bool isCityInAddress(String? address, String? city) {
    if (address == null || city == null) return false;
    if (address.trim().isEmpty || city.trim().isEmpty) return false;

    // Case-insensitive check
    return address.toLowerCase().contains(city.toLowerCase());
  }

  @override
  void initState() {
    super.initState();

    // Future.delayed ensures provider is initialized after widget tree build
    Future.delayed(Duration.zero, () {
      final locationProvider =
          Provider.of<AddressController>(context, listen: false);

      if (locationProvider.addressList == null ||
          locationProvider.addressList!.isEmpty) {
        Provider.of<CheckoutController>(context, listen: false)
            .setAddressIndex(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutController>(
        builder: (context, shippingProvider, _) {
      return Consumer<AddressController>(
          builder: (context, locationProvider, _) {
        final addressList = locationProvider.addressList;

        // Jab tak data null hai, loader dikhao
        if (addressList == null) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.amber,
          ));
        }

        // Jab list empty ho
        // if (addressList.isEmpty) {
        //   return const Center(child: Text('Please add your address'));
        // }

        return Container(
          padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,
              Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall, 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            widget.hasPhysical
                ? Card(
                    child: Container(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeDefault),
                          color: Theme.of(context).cardColor,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Row(children: [
                                      SizedBox(
                                          width: 18,
                                          child: Image.asset(
                                            Images.deliveryTo,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                  .paddingSizeExtraSmall),
                                          child: Text(
                                              '${getTranslated('delivery_to', context)}',
                                              style: textMedium.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeLarge)))
                                    ])),
                                    InkWell(
                                      onTap: () => Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (BuildContext context) =>
                                                  const SavedAddressListScreen())),
                                      child: const SizedBox(
                                          width: 20,
                                          child: Icon(
                                            Icons.add_location_alt,
                                            color: Colors.amber,
                                          )),
                                    ),
                                  ]),
                              const SizedBox(
                                height: Dimensions.paddingSizeDefault,
                              ),
                              InkWell(
                                onTap: () => Navigator.of(context).push(
                                    CupertinoPageRoute(
                                        builder: (BuildContext context) =>
                                        const SavedAddressListScreen())),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      (locationProvider.addressList == null ||
                                              locationProvider
                                                  .addressList!.isEmpty)
                                          ? Text(
                                              locationProvider
                                                  .addressList![shippingProvider
                                                      .addressIndex!]
                                                  .addressType!
                                                  .capitalize(),
                                              style: textRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeDefault),
                                              maxLines: 3,
                                              overflow: TextOverflow.fade)
                                          : SizedBox(),
                                      const Divider(thickness: .125),
                                      (shippingProvider.addressIndex == null ||
                                              locationProvider
                                                  .addressList!.isEmpty)
                                          ? Column(
                                              children: [
                                                Divider(
                                                  color: Colors.grey.shade200,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        CupertinoPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                const SavedAddressListScreen()));
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 15),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      gradient:
                                                          const LinearGradient(
                                                        colors: [
                                                          Colors.amber,
                                                          Colors.amber
                                                        ],
                                                        begin: Alignment.topLeft,
                                                        end:
                                                            Alignment.bottomRight,
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.amber
                                                              .withOpacity(0.3),
                                                          blurRadius: 10,
                                                          spreadRadius: 2,
                                                        )
                                                      ],
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                          getTranslated(
                                                                  'add_your_address',
                                                                  context) ??
                                                              '',
                                                          style: titilliumRegular
                                                              .copyWith(
                                                                  fontSize: Dimensions
                                                                      .fontSizeDefault,
                                                                  color: Colors
                                                                      .white),
                                                          maxLines: 3,
                                                          overflow:
                                                              TextOverflow.fade),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Column(children: [
                                              AddressInfoItem(
                                                  icon: Images.user,
                                                  title: locationProvider
                                                          .addressList![
                                                              shippingProvider
                                                                  .addressIndex!]
                                                          .contactPersonName ??
                                                      ''),
                                              AddressInfoItem(
                                                  icon: Images.callIcon,
                                                  title: locationProvider
                                                          .addressList![
                                                              shippingProvider
                                                                  .addressIndex!]
                                                          .phone ??
                                                      ''),
                                              AddressInfoItem(
                                                  icon: Images.address,
                                                  title: locationProvider
                                                          .addressList![
                                                              shippingProvider
                                                                  .addressIndex!]
                                                          .address ??
                                                      ''),
                                            ]),
                                      (AppLocationData.selectedCityProduct ==
                                                  "" ||
                                              AppLocationData.selectedCityProduct
                                                  .trim()
                                                  .isEmpty ||
                                              locationProvider.addressList ==
                                                  null ||
                                              shippingProvider.addressIndex ==
                                                  null ||
                                              locationProvider
                                                  .addressList!.isEmpty ||
                                              locationProvider
                                                      .addressList!.length <=
                                                  shippingProvider
                                                      .addressIndex! ||
                                              locationProvider
                                                      .addressList![
                                                          shippingProvider
                                                              .addressIndex!]
                                                      .address ==
                                                  null ||
                                              locationProvider
                                                  .addressList![shippingProvider
                                                      .addressIndex!]
                                                  .address!
                                                  .trim()
                                                  .isEmpty)
                                          ? const SizedBox.shrink()
                                          : Container(
                                              width: double.infinity,
                                              margin:
                                                  const EdgeInsets.only(top: 10),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 8),
                                              decoration: BoxDecoration(
                                                gradient: isCityInAddress(
                                                        locationProvider
                                                            .addressList![
                                                                shippingProvider
                                                                    .addressIndex!]
                                                            .address
                                                            .toString(),
                                                        AppLocationData
                                                            .selectedCityProduct)
                                                    ? LinearGradient(
                                                        colors: [
                                                          Colors.green.shade600,
                                                          Colors.green.shade300
                                                        ],
                                                        begin: Alignment.topLeft,
                                                        end:
                                                            Alignment.bottomRight,
                                                      )
                                                    : LinearGradient(
                                                        colors: [
                                                          Colors.amber.shade600,
                                                          Colors.amber.shade300
                                                        ],
                                                        begin: Alignment.topLeft,
                                                        end:
                                                            Alignment.bottomRight,
                                                      ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 6,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    isCityInAddress(
                                                            locationProvider
                                                                .addressList![
                                                                    shippingProvider
                                                                        .addressIndex!]
                                                                .address
                                                                .toString(),
                                                            AppLocationData
                                                                .selectedCityProduct)
                                                        ? Icons.local_shipping
                                                        : Icons.schedule,
                                                    color: Colors.white,
                                                    size: 28,
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      isCityInAddress(
                                                              locationProvider
                                                                  .addressList![
                                                                      shippingProvider
                                                                          .addressIndex!]
                                                                  .address
                                                                  .toString(),
                                                              AppLocationData
                                                                  .selectedCityProduct)
                                                          ? "Same day delivery is available."
                                                          : "Your package will reach you in about 5–7 days.",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ]),
                              )
                            ])))
                : const SizedBox(),
            SizedBox(
                height: widget.hasPhysical ? Dimensions.paddingSizeSmall : 0),
            if (widget.billingAddress)
              Padding(
                padding: EdgeInsets.only(
                    bottom:
                        widget.hasPhysical ? Dimensions.paddingSizeSmall : 0),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () => shippingProvider.setSameAsBilling(),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    SizedBox(
                        width: 20,
                        height: 20,
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.75),
                                    width: 1.5),
                                borderRadius: BorderRadius.circular(6)),
                            child: Icon(CupertinoIcons.checkmark_alt,
                                size: 15,
                                color: shippingProvider.sameAsBilling
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.75)
                                    : Colors.transparent))),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall),
                        child: Text(getTranslated('same_as_delivery', context)!,
                            style: textRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault)))
                  ]),
                ),
              ),
            if (widget.billingAddress && !shippingProvider.sameAsBilling)
              Card(
                  child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.paddingSizeDefault),
                    color: Theme.of(context).cardColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Row(children: [
                            SizedBox(
                                width: 18,
                                child: Image.asset(Images.billingTo)),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.paddingSizeExtraSmall),
                                child: Text(
                                    '${getTranslated('billing_to', context)}',
                                    style: textMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge)))
                          ])),
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                                CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        const SavedBillingAddressListScreen())),
                            child: SizedBox(
                                width: 20,
                                child: Image.asset(
                                  Images.edit,
                                  scale: 3,
                                  color: Theme.of(context).primaryColor,
                                )),
                          ),
                        ]),
                    const SizedBox(
                      height: Dimensions.paddingSizeDefault,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (shippingProvider.billingAddressIndex == null ||
                                  locationProvider.addressList == null)
                              ? '${getTranslated('address_type', context)}'
                              : locationProvider
                                  .addressList![
                                      shippingProvider.billingAddressIndex!]
                                  .addressType!
                                  .capitalize(),
                          style: textRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                        const Divider(thickness: .125),
                        (shippingProvider.billingAddressIndex == null ||
                                locationProvider.addressList == null)
                            ? Text(
                                getTranslated('add_your_address', context)!,
                                style: titilliumRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall),
                                maxLines: 3,
                                overflow: TextOverflow.fade,
                              )
                            : Column(children: [
                                AddressInfoItem(
                                    icon: Images.user,
                                    title: locationProvider
                                            .addressList?[shippingProvider
                                                .billingAddressIndex!]
                                            .contactPersonName ??
                                        ''),
                                AddressInfoItem(
                                    icon: Images.callIcon,
                                    title: locationProvider
                                            .addressList?[shippingProvider
                                                .billingAddressIndex!]
                                            .phone ??
                                        ''),
                                AddressInfoItem(
                                    icon: Images.address,
                                    title: locationProvider
                                            .addressList?[shippingProvider
                                                .billingAddressIndex!]
                                            .address ??
                                        ''),
                              ]),
                      ],
                    ),
                  ],
                ),
              )),
            if (widget.billingAddress && shippingProvider.sameAsBilling)
              Card(
                  child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.paddingSizeDefault),
                    color: Theme.of(context).cardColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Row(children: [
                            SizedBox(
                                width: 18,
                                child: Image.asset(Images.billingTo)),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.paddingSizeExtraSmall),
                                child: Row(
                                  children: [
                                    Text(
                                        '${getTranslated('billing_to', context)}',
                                        style: textMedium.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeLarge)),
                                    const SizedBox(
                                        width: Dimensions.paddingSizeSmall),
                                    Text(
                                        '(${getTranslated("same_as_delivery", context)})',
                                        style: textMedium.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            color: Theme.of(context)
                                                .hintColor
                                                .withOpacity(.75))),
                                  ],
                                ))
                          ])),
                        ]),
                  ],
                ),
              )),
          ]),
        );
      });
    });
  }
}

class AddressInfoItem extends StatelessWidget {
  final String? icon;
  final String? title;
  const AddressInfoItem({super.key, this.icon, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(children: [
        SizedBox(width: 18, child: Image.asset(icon!)),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall),
                child: Text(title ?? '',
                    style: textRegular.copyWith(),
                    maxLines: 2,
                    overflow: TextOverflow.fade)))
      ]),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
