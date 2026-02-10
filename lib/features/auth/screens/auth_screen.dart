import 'dart:io';

import 'package:country_code_picker/src/country_code.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/localization/language_constrants.dart';
import 'package:mahakal/features/auth/controllers/auth_controller.dart';
import 'package:mahakal/utill/custom_themes.dart';
import 'package:mahakal/utill/dimensions.dart';
import 'package:mahakal/utill/images.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../../common/basewidget/custom_button_widget.dart';
import '../../../common/basewidget/custom_textfield_widget.dart';
import '../../../common/basewidget/show_custom_snakbar_widget.dart';
import '../../../helper/velidate_check.dart';
import '../../../main.dart';
import '../../../utill/app_constants.dart';
import '../../all_pandit/Pandit_Bottom_bar.dart';
import '../../banner/controllers/banner_controller.dart';
import '../../brand/controllers/brand_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../category/controllers/category_controller.dart';
import '../../deal/controllers/featured_deal_controller.dart';
import '../../notification/controllers/notification_controller.dart';
import '../../product/controllers/product_controller.dart';
import '../../profile/controllers/profile_contrroller.dart';
import '../../shop/controllers/shop_controller.dart';
import '../../splash/controllers/splash_controller.dart';
import '../../wishlist/controllers/wishlist_controller.dart';
import '../widgets/code_picker_widget.dart' as custom_code_picker;
import 'mobile_verify_screen.dart';
import 'otp_verification_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController? _numberController;
  late TextEditingController codeController;
  late TextEditingController _firstNameController;
  late TextEditingController _emailController;
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  // String? _countryDialCode = '+91';
  var myVerificationId = '1';

  @override
  void initState() {
    Provider.of<AuthController>(context, listen: false)
        .fetchCurrentLocation(context);
    _numberController = TextEditingController();
    _emailController = TextEditingController();
    codeController = TextEditingController();
    _firstNameController = TextEditingController();
    _firstNameController.clear();
    _emailController.clear();
    _numberController!.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(alignment: Alignment.topRight, children: [
              Container(
                  height: 250,
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor)),
              Image.asset(Images.loginBg,
                  fit: BoxFit.cover,
                  height: 220,
                  opacity: const AlwaysStoppedAnimation(.15)),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.14,),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(Images.appLogo, height: 65)),
                      Image.asset(Images.logoNameImage,height: 50,)
                    ]),
              ),
              Platform.isIOS
                  ? InkWell(
                      onTap: () async {
                        Navigator.of(Get.context!).pushReplacement(
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    const PanditBottomBar(pageIndex: 0, panditId: AppConstants.panditId, sellerId: AppConstants.sellerId, astroImage: '',),));
                        Provider.of<BannerController>(Get.context!,
                                listen: false)
                            .getBannerList(true);
                        Provider.of<CategoryController>(Get.context!,
                                listen: false)
                            .getCategoryList(true);
                        await Provider.of<ProductController>(Get.context!,
                                listen: false)
                            .getHomeCategoryProductList(true);
                        await Provider.of<ShopController>(Get.context!,
                                listen: false)
                            .getTopSellerList(true, 1, type: "top");
                        await Provider.of<BrandController>(Get.context!,
                                listen: false)
                            .getBrandList(true);
                        await Provider.of<ProductController>(Get.context!,
                                listen: false)
                            .getLatestProductList(1, reload: true);
                        await Provider.of<ProductController>(Get.context!,
                                listen: false)
                            .getFeaturedProductList('1', reload: true);
                        await Provider.of<FeaturedDealController>(Get.context!,
                                listen: false)
                            .getFeaturedDealList(true);
                        await Provider.of<ProductController>(Get.context!,
                                listen: false)
                            .getLProductList('1', reload: true);
                        await Provider.of<ProductController>(Get.context!,
                                listen: false)
                            .getRecommendedProduct();
                        await Provider.of<CartController>(Get.context!,
                                listen: false)
                            .getCartData(Get.context!);
                        await Provider.of<NotificationController>(Get.context!,
                                listen: false)
                            .getNotificationList(1);
                        if (Provider.of<AuthController>(Get.context!,
                                listen: false)
                            .isLoggedIn()) {
                          await Provider.of<ProfileController>(Get.context!,
                                  listen: false)
                              .getUserInfo(Get.context!);
                          await Provider.of<WishListController>(Get.context!,
                                  listen: false)
                              .getWishList();
                        }
                      },
                      child: Container(
                        height: 30,
                        width: 50,
                        margin: const EdgeInsets.only(top: 50, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey.withOpacity(0.6),
                        ),
                        child: const Center(
                          child: Text(
                            "Skip",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ]),
            AnimatedContainer(
              transform: Matrix4.translationValues(0, -20, 0),
              curve: Curves.fastOutSlowIn,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(Dimensions.radiusExtraLarge))),
              duration: const Duration(seconds: 2),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Center(child: Text('')),
                    Text(getTranslated('sign_in', context) ?? "",
                        style: textRegular.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: Dimensions.fontSizeExtraLarge)),
                    Container(
                        height: 3,
                        width: 25,
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeSmall),
                            color: Theme.of(context).primaryColor)),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                    Consumer<AuthController>(
                        builder: (context, authProvider, _) {
                      return authProvider.OTPScreen == true &&
                              authProvider.isRegisterScreen == false
                          ? AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: otpScreen(context))
                          : authProvider.OTPScreen == false &&
                                  authProvider.isRegisterScreen == true
                              ? registrationScreen(context)
                              : loginScreen(context);
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loginScreen(BuildContext context) {
    return DelayedDisplay(
      slidingBeginOffset: const Offset(0, -0.4),
      delay: const Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(getTranslated('mobile_number', context)!),
          Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                custom_code_picker.CodePickerWidget(
                    onChanged: (CountryCode countryCode) {
                      //Provider.of<AuthController>(context).countryDialCode = countryCode.dialCode!;
                      Provider.of<AuthController>(context, listen: false)
                          .countryDialCode = countryCode.dialCode!;
                    },
                    initialSelection:
                        Provider.of<AuthController>(context).countryDialCode,
                    favorite: [
                      Provider.of<AuthController>(context).countryDialCode
                    ],
                    showDropDownButton: false,
                    padding: const EdgeInsets.only(right: 10),
                    showFlagMain: true,
                    textStyle: TextStyle(
                        color:
                            Theme.of(context).textTheme.displayLarge?.color)),
                Expanded(
                    child: CustomTextFieldWidget(
                        hintText: getTranslated('number_hint', context),
                        controller: _numberController,
                        isEnabled: Provider.of<AuthController>(context)
                            .isNumberDisable,
                        focusNode: _numberFocus,
                        isAmount: true,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.phone))
              ])),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          const SizedBox(height: 12),
          Consumer<AuthController>(
            builder: (context, authProvider, _) {
              return authProvider.isPhoneNumberVerificationButtonLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ))
                  : CustomButton(
                      buttonText: getTranslated('Verify', context),
                      onTap: () async {
                        await authProvider.signInPhoneNumber(
                            myPhoneNumber:
                                "${authProvider.countryDialCode}${_numberController!.text}",
                            context: context);
                      },
                    );
            },
          )
        ],
      ),
    );
  }

  otpScreen(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DelayedDisplay(
      slidingBeginOffset: const Offset(0, -0.4),
      delay: const Duration(milliseconds: 300),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Verification Code',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                )),
          ),
          SizedBox(height: size.width / 25),
          Consumer<AuthController>(
            builder: (context, authProvider, _) {
              return Text.rich(
                TextSpan(
                    text: 'The confirmation code is sent to ',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                          text:
                              'Mobile Number ${authProvider.countryDialCode}-${_numberController!.text}. ',
                          style: const TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      const TextSpan(
                          text: 'Please enter it below.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ))
                    ]),
              );
            },
          ),
          SizedBox(height: size.width / 20),

          //OTP TextField
          PinCodeTextField(
            controller: codeController,
            appContext: context,
            length: 6,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(10),
              fieldHeight: size.width * 0.15,
              fieldWidth: size.width * 0.12,
              selectedFillColor: Colors.white,
              selectedColor: Theme.of(context).primaryColor,
              inactiveColor: Colors.grey.shade400,
              inactiveFillColor: Colors.white,
              activeColor: Theme.of(context).primaryColor,
              activeFillColor: Colors.white,
            ),
            cursorColor: Colors.black,
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            keyboardType: TextInputType.number,
            onChanged: (value) {},
            onCompleted: (_) {
              codeController.value;
            },
            beforeTextPaste: (text) {
              debugPrint("Allowing to paste $text");
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
          ),

          SizedBox(height: size.width / 20),

          //OTP Verification Button
          Consumer<AuthController>(builder: (context, authProvider, _) {
            return authProvider.isOTPLoading
                ? Center(
                    child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ))
                : CustomButton(
                    buttonText: 'Verify OTP',
                    onTap: () {
                      String? phoneNumber =
                          "${authProvider.countryDialCode}${_numberController!.text}";
                      String userInput = codeController.text;
                      // authProvider.myCredentials(
                      authProvider.verifyOtpAndSignIn(authProvider.verifyResult,
                          userInput, context, phoneNumber, route);
                    },
                  );
          }),

          SizedBox(height: size.width / 10),

          const Text(
            'Didn\'t receive the code?',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),

          //Resend-OTP Button
          Consumer<AuthController>(builder: (context, authProvider, _) {
            return authProvider.isPhoneNumberVerificationButtonLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    )),
                  )
                : InkWell(
                    onTap: () async {
                      await authProvider.signInPhoneNumber(
                          myPhoneNumber:
                              "${authProvider.countryDialCode}${_numberController!.text}",
                          context: context);
                    },
                    child: Text(
                      'RESEND OTP',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700),
                    ),
                  );
          }),
        ],
      ),
    );
  }

  registrationScreen(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DelayedDisplay(
      slidingBeginOffset: const Offset(0, -0.4),
      delay: const Duration(milliseconds: 300),
      child: Column(
        children: [
          CustomTextFieldWidget(
              hintText: getTranslated('first_name', context),
              labelText: getTranslated('first_name', context),
              inputType: TextInputType.name,
              required: true,
              focusNode: _fNameFocus,
              nextFocus: _emailFocus,
              prefixIcon: Images.username,
              capitalization: TextCapitalization.words,
              controller: _firstNameController,
              validator: (value) => ValidateCheck.validateEmptyText(
                  value, "first_name_field_is_required")),
          SizedBox(height: size.width / 30),
          CustomTextFieldWidget(
              hintText: getTranslated('enter_mobile_number', context),
              labelText: getTranslated('enter_mobile_number', context),
              controller: _numberController,
              isEnabled: false,
              prefixIcon: Images.callIcon,
              inputAction: TextInputAction.next,
              inputType: TextInputType.phone),
          SizedBox(height: size.width / 30),
          CustomTextFieldWidget(
              hintText: getTranslated('enter_your_email', context),
              labelText: getTranslated('enter_your_email', context),
              focusNode: _emailFocus,
              required: true,
              inputType: TextInputType.emailAddress,
              controller: _emailController,
              prefixIcon: Images.email,
              validator: (value) => ValidateCheck.validateEmail(value)),
          SizedBox(height: size.width / 30),
          Consumer<AuthController>(builder: (context, authProvider, _) {
            return Container(
                child: authProvider.isRegisterLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)))
                    : CustomButton(
                        onTap: () async {
                          print("CountryCode-${authProvider.countryDialCode}");
                          // authProvider.countryDialCode = _countryDialCode!;
                          String firstName = _firstNameController.text.trim();
                          String email = _emailController.text.trim();
                          String phoneNumber =
                              "${authProvider.countryDialCode}${_numberController!.text}";
                          if (firstName.isEmpty) {
                            showCustomSnackBar(
                                getTranslated(
                                    'first_name_field_is_required', context),
                                context);
                          } else {
                            await authProvider.userRegister(
                                phone: phoneNumber,
                                name: firstName,
                                email: email,
                                callback: route);
                          }
                        },
                        buttonText: getTranslated('sign_up', context)));
          }),
        ],
      ),
    );
  }

  route(bool isRoute, String? token, String? temporaryToken,
      String? errorMessage) async {
    if (isRoute) {
      if (token == null || token.isEmpty) {
        if (Provider.of<SplashController>(context, listen: false)
            .configModel!
            .emailVerification!) {
          Provider.of<AuthController>(context, listen: false)
              .sendOtpToEmail(_emailController.text.toString(), temporaryToken!)
              .then((value) async {
            if (value.response?.statusCode == 200) {
              Provider.of<AuthController>(context, listen: false)
                  .updateEmail(_emailController.text.toString());
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                      builder: (_) => VerificationScreen(temporaryToken, '',
                          _emailController.text.toString())),
                  (route) => false);
            }
          });
        } else if (Provider.of<SplashController>(context, listen: false)
            .configModel!
            .phoneVerification!) {
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                  builder: (_) => MobileVerificationScreen(temporaryToken!)),
              (route) => false);
        }
      } else {
        await Provider.of<ProfileController>(context, listen: false)
            .getUserInfo(context);
        Navigator.pushAndRemoveUntil(
            Get.context!,
            CupertinoPageRoute(builder: (_) => const PanditBottomBar(pageIndex: 0, panditId: AppConstants.panditId, sellerId: AppConstants.sellerId, astroImage: '',),),
            (route) => false);
      }
    } else {
      showCustomSnackBar(errorMessage, context);
    }
  }

  // bool scrolled = false;
  // @override
  // Widget build(BuildContext context) {
  //   return PopScope(
  //     canPop: false,
  //     onPopInvoked: (val) async {
  //       if (Provider.of<AuthController>(context, listen: false).selectedIndex != 0) {
  //         Provider.of<AuthController>(context, listen: false)
  //             .updateSelectedIndex(0);
  //       } else {
  //         if (Navigator.canPop(context)) {
  //           Navigator.of(context).pop();
  //         } else {
  //           showModalBottomSheet(
  //               backgroundColor: Colors.transparent,
  //               context: context,
  //               builder: (_) => const AppExitCard());
  //         }
  //       }
  //     },
  //     child: Scaffold(
  //       body: Consumer<AuthController>(builder: (context, authProvider, _) {
  //         return SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               Stack(children: [
  //                 Container(
  //                     height: 200,
  //                     decoration: BoxDecoration(color: Theme.of(context).primaryColor)),
  //                 Image.asset(Images.loginBg,
  //                     fit: BoxFit.cover,
  //                     height: 200,
  //                     opacity: const AlwaysStoppedAnimation(.15)),
  //                 Padding(
  //                     padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .07),
  //                     child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Image.asset(Images.logoWithNameImageWhite, width: 280, height: 100)
  //                         ]))
  //               ]),
  //               AnimatedContainer(
  //                 transform: Matrix4.translationValues(0, -20, 0),
  //                 curve: Curves.fastOutSlowIn,
  //                 decoration: BoxDecoration(
  //                     color: Theme.of(context).scaffoldBackgroundColor,
  //                     borderRadius: const BorderRadius.vertical(
  //                         top: Radius.circular(Dimensions.radiusExtraLarge))),
  //                 duration: const Duration(seconds: 2),
  //                 child: SingleChildScrollView(
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(
  //                         top: Dimensions.paddingSizeDefault),
  //                     child: Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Padding(
  //                             padding: const EdgeInsets.all(
  //                                 Dimensions.marginSizeLarge),
  //                             child: Row(children: [
  //                               InkWell(
  //                                   onTap: () => authProvider.updateSelectedIndex(0),
  //                                   child: Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         Text(getTranslated('login', context)!,
  //                                             style: authProvider.selectedIndex == 0
  //                                                 ? textRegular.copyWith(
  //                                                     color: Theme.of(context).primaryColor,
  //                                                     fontSize: Dimensions.fontSizeLarge)
  //                                                 : textRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
  //                                         Container(
  //                                             height: 3,
  //                                             width: 25,
  //                                             margin:
  //                                                 const EdgeInsets.only(top: 8),
  //                                             decoration: BoxDecoration(
  //                                                 borderRadius: BorderRadius
  //                                                     .circular(Dimensions
  //                                                         .paddingSizeSmall),
  //                                                 color: authProvider
  //                                                             .selectedIndex ==
  //                                                         0
  //                                                     ? Theme.of(context)
  //                                                         .primaryColor
  //                                                     : Colors.transparent))
  //                                       ])),
  //                               const SizedBox(
  //                                   width: Dimensions.paddingSizeExtraLarge),
  //                               InkWell(
  //                                   onTap: () =>
  //                                       authProvider.updateSelectedIndex(1),
  //                                   child: Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         Text(
  //                                             getTranslated(
  //                                                 'sign_up', context)!,
  //                                             style: authProvider
  //                                                         .selectedIndex ==
  //                                                     1
  //                                                 ? titleRegular.copyWith(
  //                                                     color: Theme.of(context)
  //                                                         .primaryColor,
  //                                                     fontSize: Dimensions
  //                                                         .fontSizeLarge)
  //                                                 : titleRegular.copyWith(
  //                                                     fontSize: Dimensions
  //                                                         .fontSizeLarge)),
  //                                         Container(
  //                                             height: 3,
  //                                             width: 25,
  //                                             margin:
  //                                                 const EdgeInsets.only(top: 8),
  //                                             decoration: BoxDecoration(
  //                                                 borderRadius: BorderRadius
  //                                                     .circular(Dimensions
  //                                                         .paddingSizeSmall),
  //                                                 color: authProvider
  //                                                             .selectedIndex ==
  //                                                         1
  //                                                     ? Theme.of(context)
  //                                                         .primaryColor
  //                                                     : Colors.transparent))
  //                                       ]))
  //                             ])),
  //                         authProvider.selectedIndex == 0
  //                             ? const SignInWidget()
  //                             : const SignUpWidget(),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         );
  //       }),
  //     ),
  //   );
  // }
}
