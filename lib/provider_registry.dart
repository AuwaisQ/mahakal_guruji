import 'package:mahakal/features/astrotalk/controller/astrotalk_controller.dart';
import 'package:mahakal/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'call_service/call_service.dart';
import 'di_container.dart' as di;
import 'features/address/controllers/address_controller.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/banner/controllers/banner_controller.dart';
import 'features/brand/controllers/brand_controller.dart';
import 'features/cart/controllers/cart_controller.dart';
import 'features/category/controllers/category_controller.dart';
import 'features/chat/controllers/chat_controller.dart';
import 'features/checkout/controllers/checkout_controller.dart';
import 'features/compare/controllers/compare_controller.dart';
import 'features/contact_us/controllers/contact_us_controller.dart';
import 'features/coupon/controllers/coupon_controller.dart';
import 'features/deal/controllers/featured_deal_controller.dart';
import 'features/deal/controllers/flash_deal_controller.dart';
import 'features/location/controllers/location_controller.dart';
import 'features/loyaltyPoint/controllers/loyalty_point_controller.dart';
import 'features/notification/controllers/notification_controller.dart';
import 'features/onboarding/controllers/onboarding_controller.dart';
import 'features/order/controllers/order_controller.dart';
import 'features/order_details/controllers/order_details_controller.dart';
import 'features/product/controllers/product_controller.dart';
import 'features/product/controllers/seller_product_controller.dart';
import 'features/product_details/controllers/product_details_controller.dart';
import 'features/profile/controllers/profile_contrroller.dart';
import 'features/refund/controllers/refund_controller.dart';
import 'features/reorder/controllers/re_order_controller.dart';
import 'features/review/controllers/review_controller.dart';
import 'features/search_product/controllers/search_product_controller.dart';
import 'features/shipping/controllers/shipping_controller.dart';
import 'features/shop/controllers/shop_controller.dart';
import 'features/splash/controllers/splash_controller.dart';
import 'features/support/controllers/support_ticket_controller.dart';
import 'features/wallet/controllers/wallet_controller.dart';
import 'features/wishlist/controllers/wishlist_controller.dart';
import 'localization/controllers/localization_controller.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (context) => di.sl<CallServiceProvider>()),
  ChangeNotifierProvider(create: (context) => di.sl<ProfileController>()),
  ChangeNotifierProvider(create: (context) => di.sl<CategoryController>()),
  ChangeNotifierProvider(create: (context) => di.sl<ShopController>()),
  ChangeNotifierProvider(create: (context) => di.sl<FlashDealController>()),
  ChangeNotifierProvider(create: (context) => di.sl<FeaturedDealController>()),
  ChangeNotifierProvider(create: (context) => di.sl<BrandController>()),
  ChangeNotifierProvider(create: (context) => di.sl<ProductController>()),
  ChangeNotifierProvider(create: (context) => di.sl<BannerController>()),
  ChangeNotifierProvider(create: (context) => di.sl<ProductDetailsController>()),
  ChangeNotifierProvider(create: (context) => di.sl<OnBoardingController>()),
  ChangeNotifierProvider(create: (context) => di.sl<AuthController>()),
  ChangeNotifierProvider(create: (context) => di.sl<SearchProductController>()),
  ChangeNotifierProvider(create: (context) => di.sl<CouponController>()),
  ChangeNotifierProvider(create: (context) => di.sl<ChatController>()),
  ChangeNotifierProvider(create: (context) => di.sl<OrderController>()),
  ChangeNotifierProvider(create: (context) => di.sl<NotificationController>()),
  ChangeNotifierProvider(create: (context) => di.sl<WishListController>()),
  ChangeNotifierProvider(create: (context) => di.sl<SplashController>()),
  ChangeNotifierProvider(create: (context) => di.sl<CartController>()),
  ChangeNotifierProvider(create: (context) => di.sl<SupportTicketController>()),
  ChangeNotifierProvider(create: (context) => di.sl<LocalizationController>()),
  ChangeNotifierProvider(create: (context) => di.sl<ThemeController>()),
  ChangeNotifierProvider(create: (context) => di.sl<AddressController>()),
  ChangeNotifierProvider(create: (context) => di.sl<WalletController>()),
  ChangeNotifierProvider(create: (context) => di.sl<CompareController>()),
  ChangeNotifierProvider(create: (context) => di.sl<CheckoutController>()),
  ChangeNotifierProvider(create: (context) => di.sl<LoyaltyPointController>()),
  ChangeNotifierProvider(create: (context) => di.sl<LocationController>()),
  ChangeNotifierProvider(create: (context) => di.sl<ContactUsController>()),
  ChangeNotifierProvider(create: (context) => di.sl<ShippingController>()),
  ChangeNotifierProvider(create: (context) => di.sl<OrderDetailsController>()),
  ChangeNotifierProvider(create: (context) => di.sl<RefundController>()),
  ChangeNotifierProvider(create: (context) => di.sl<ReOrderController>()),
  ChangeNotifierProvider(create: (context) => di.sl<ReviewController>()),
  ChangeNotifierProvider(create: (context) => di.sl<SellerProductController>()),
  ChangeNotifierProvider(create: (context) => di.sl<SocketController>()),
];
