import 'package:mahakal/localization/models/language_model.dart';
import 'package:mahakal/utill/images.dart';

class AppConstants {
  static const String appName = 'Mahakal.com';
  static const String slogan = 'E-Commerce Marketplace';
  static const String appVersion = '12.35';

  static const String otherBaseUrl = 'https://hotels.mahakal.com';
  // static const String baseUrl = 'https://uat.pavtr.in';
  static const String baseUrl = 'https://sit.resrv.in';
  // static const String baseUrl = 'https://mahakal.com';

  // Razorpay API key
  static const razorpayLive =
      (baseUrl == 'https://uat.pavtr.in' || baseUrl == 'https://sit.resrv.in')
          ? 'rzp_test_vsSpBCHRz9XUp2' // UAT & SIT → Test key
          : 'rzp_live_InwZruBPIWObnO'; // Others (like prod) → Live key

  // static const razorpayLive = "rzp_live_InwZruBPIWObnO";//--Mahakal.com--//
  // static const razorpayLive = "rzp_live_qI7P9oGBEEf1Sn";//--GO-CAAR-GO--//
  // static const razorpayLive = "rzp_test_vsSpBCHRz9XUp2";//--Test--//

  static const String userId = 'userId';
  static const String name = 'name';
  static const String categoriesUri = '/api/v1/categories?guest_id=1';
  static const String brandUri = '/api/v1/brands?guest_id=1';
  static const String brandProductUri = '/api/v1/brands/products/';
  static const String categoryProductUri = '/api/v1/categories/products/';
  static const String registrationUri = '/api/v1/auth/register';
  static const String loginUri = '/api/v1/auth/login';
  static const String logOut = '/api/v1/auth/logout';
  static const String latestProductUri = '/api/v1/products/latest?guest_id=1&limit=10&&offset=';
  static const String newArrivalProductUri =
      '/api/v1/products/latest?guest_id=1&limit=10&&offset=';
  static const String topProductUri =
      '/api/v1/products/top-rated?guest_id=1&limit=10&&offset=';
  static const String bestSellingProductUri =
      '/api/v1/products/best-sellings?guest_id=1&limit=10&offset=';
  static const String discountedProductUri =
      '/api/v1/products/discounted-product?guest_id=1&limit=10&&offset=';
  static const String featuredProductUri =
      '/api/v1/products/featured?guest_id=1&limit=10&&offset=';
  static const String homeCategoryProductUri =
      '/api/v1/products/home-categories?guest_id=1';
  static const String productDetailsUri = '/api/v1/products/details/';
  static const String productReviewUri = '/api/v1/products/reviews/';
  static const String searchUri = '/api/v1/products/filter';
  static const String getSuggestionProductName =
      '/api/v1/products/suggestion-product?guest_id=1&name=';
  static const String configUri = '/api/v1/config';
  static const String addWishListUri =
      '/api/v1/customer/wish-list/add?product_id=';
  static const String removeWishListUri =
      '/api/v1/customer/wish-list/remove?product_id=';
  static const String updateProfileUri = '/api/v1/customer/update-profile';
  static const String customerUri = '/api/v1/customer/info';
  static const String addressListUri = '/api/v1/customer/address/list';
  static const String removeAddressUri = '/api/v1/customer/address';
  static const String addAddressUri = '/api/v1/customer/address/add';
  static const String getWishListUri = '/api/v1/customer/wish-list';
  static const String supportTicketUri =
      '/api/v1/customer/support-ticket/create';
  static const String getBannerList = '/api/v1/banners';
  static const String relatedProductUri = '/api/v1/products/related-products/';
  static const String orderUri = '/api/v1/customer/order/list?limit=10&offset=';
  static const String orderDetailsUri =
      '/api/v1/customer/order/details?order_id=';
  static const String orderPlaceUri = '/api/v1/customer/order/place';
  static const String sellerUri = '/api/v1/seller?seller_id=';
  static const String sellerProductUri = '/api/v1/seller/';
  static const String sellerList = '/api/v1/seller/list/';
  static const String trackingUri = '/api/v1/order/track?order_id=';
  static const String forgetPasswordUri = '/api/v1/auth/forgot-password';
  static const String getSupportTicketUri =
      '/api/v1/customer/support-ticket/get';
  static const String supportTicketConversationUri =
      '/api/v1/customer/support-ticket/conv/';
  static const String supportTicketReplyUri =
      '/api/v1/customer/support-ticket/reply/';
  static const String closeSupportTicketUri =
      '/api/v1/customer/support-ticket/close/';
  static const String submitReviewUri = '/api/v1/products/reviews/submit';
  static const String getOrderWiseReview = '/api/v1/products/review/';
  static const String updateOrderWiseReview = '/api/v1/products/review/update';
  static const String deleteOrderWiseReviewImage =
      '/api/v1/products/review/delete-image';
  static const String flashDealUri = '/api/v1/flash-deals';
  static const String featuredDealUri = '/api/v1/deals/featured';
  static const String flashDealProductUri = '/api/v1/flash-deals/products/';
  static const String counterUri = '/api/v1/products/counter/';
  static const String socialLinkUri = '/api/v1/products/social-share-link/';
  static const String shippingUri = '/api/v1/products/shipping-methods';
  static const String couponUri = '/api/v1/coupon/apply?code=';
  static const String messageUri = '/api/v1/customer/chat/get-messages/';
  static const String chatInfoUri = '/api/v1/customer/chat/list/';
  static const String searchChat = '/api/v1/customer/chat/search/';
  static const String sendMessageUri = '/api/v1/customer/chat/send-message/';
  static const String seenMessageUri = '/api/v1/customer/chat/seen-message/';
  static const String tokenUri = '/api/v1/customer/cm-firebase-token';
  static const String notificationUri = '/api/v1/notifications';
  static const String seenNotificationUri = '/api/v1/notifications/seen';
  static const String getCartDataUri = '/api/v1/cart';
  static const String addToCartUri = '/api/v1/cart/add';
  static const String updateCartQuantityUri = '/api/v1/cart/update';
  static const String removeFromCartUri = '/api/v1/cart/remove';
  static const String getShippingMethod = '/api/v1/shipping-method/by-seller';
  static const String chooseShippingMethod =
      '/api/v1/shipping-method/choose-for-order';
  static const String chosenShippingMethod = '/api/v1/shipping-method/chosen';
  static const String sendOtpToPhone = '/api/v1/auth/check-phone';
  static const String resendPhoneOtpUri = '/api/v1/auth/resend-otp-check-phone';
  static const String verifyPhoneUri = '/api/v1/auth/verify-phone';
  static const String socialLoginUri = '/api/v1/auth/social-login';
  static const String sendOtpToEmail = '/api/v1/auth/check-email';
  static const String resendEmailOtpUri = '/api/v1/auth/resend-otp-check-email';
  static const String verifyEmailUri = '/api/v1/auth/verify-email';
  static const String resetPasswordUri = '/api/v1/auth/reset-password';
  static const String verifyOtpUri = '/api/v1/auth/verify-otp';
  static const String refundRequestUri = '/api/v1/customer/order/refund-store';
  static const String refundRequestPreReqUri = '/api/v1/customer/order/refund';
  static const String refundResultUri = '/api/v1/customer/order/refund-details';
  static const String cancelOrderUri = '/api/v1/order/cancel-order';
  static const String getSelectedShippingTypeUri =
      '/api/v1/shipping-method/check-shipping-type';
  static const String dealOfTheDay = '/api/v1/dealsoftheday/deal-of-the-day';
  static const String walletTransactionUri =
      '/api/v1/customer/wallet/list?limit=10&offset=';
  static const String loyaltyPointUri =
      '/api/v1/customer/loyalty/list?limit=20&offset=';
  static const String loyaltyPointConvert =
      '/api/v1/customer/loyalty/loyalty-exchange-currency';
  static const String deleteCustomerAccount = '/api/v1/customer/account-delete';
  static const String deliveryRestrictedCountryList =
      '/api/v1/customer/get-restricted-country-list';
  static const String deliveryRestrictedZipList =
      '/api/v1/customer/get-restricted-zip-list';
  static const String getOrderFromOrderId =
      '/api/v1/customer/order/get-order-by-id?order_id=';
  static const String offlinePayment =
      '/api/v1/customer/order/place-by-offline-payment';
  static const String walletPayment = '/api/v1/customer/order/place-by-wallet';
  static const String astroWalletrack = '/api/v1/astrologer/wallet-history';
  static const String couponListApi = '/api/v1/coupon/list?limit=100&offset=';
  static const String sellerWiseCouponListApi = '/api/v1/coupons/';
  static const String sellerWiseBestSellingProduct = '/api/v1/seller/';
  static const String digitalPayment = '/api/v1/digital-payment';
  static const String offlinePaymentList =
      '/api/v1/customer/order/offline-payment-method-list';
  static const String sellerWiseCategoryList = '/api/v1/categories?seller_id=';
  static const String sellerWiseBrandList = '/api/v1/brands?seller_id=';

  //address
  static const String updateAddressUri = '/api/v1/customer/address/update';
  static const String geocodeUri = '/api/v1/mapapi/geocode-api';
  static const String searchLocationUri =
      '/api/v1/mapapi/place-api-autocomplete';
  static const String placeDetailsUri = '/api/v1/mapapi/place-api-details';
  static const String distanceMatrixUri = '/api/v1/mapapi/distance-api';
  static const String chatWithDeliveryMan = '/api/v1/mapapi/distance-api';
  static const String getGuestIdUri = '/api/v1/get-guest-id';
  static const String mostDemandedProduct =
      '/api/v1/products/most-demanded-product?guest_id=1';
  static const String shopAgainFromRecentStore =
      '/api/v1/products/shop-again-product';
  static const String findWhatYouNeed = '/api/v1/categories/find-what-you-need';
  static const String orderTrack = '/api/v1/order/track-order';
  static const String addFundToWallet = '/api/v1/add-to-fund';
  static const String reorder = '/api/v1/customer/order/again';
  static const String walletBonusList = '/api/v1/customer/wallet/bonus-list';
  static const String moreStore = '/api/v1/seller/more';
  static const String justForYou = '/api/v1/products/just-for-you?guest_id=1';
  static const String mostSearching =
      '/api/v1/products/most-searching?guest_id=1';
  static const String contactUsUri = '/api/v1/contact-us';
  static const String attributeUri = '/api/v1/attributes';
  static const String availableCoupon = '/api/v1/coupon/applicable-list';
  static const String downloadDigitalProduct =
      '/api/v1/customer/order/digital-product-download/';
  static const String otpVResendForDigitalProduct =
      '/api/v1/customer/order/digital-product-download-otp-resend';
  static const String otpVerificationForDigitalProduct =
      '/api/v1/customer/order/digital-product-download-otp-verify';
  static const String getCompareList = '/api/v1/customer/compare/list';
  static const String addToCompareList =
      '/api/v1/customer/compare/product-store';
  static const String removeAllFromCompareList =
      '/api/v1/customer/compare/clear-all';
  static const String replaceFromCompareList =
      '/api/v1/customer/compare/product-replace';
  static const String setCurrentLanguage = '/api/v1/customer/language-change';

  // Offline Pooja
  static const offlinePoojaTrackUrl = '/api/v1/offlinepooja/adduserdetail';
  static const offlinePoojaCancalIdUrl =
      '/api/v1/offlinepooja/user/order/cancel/amount?orderId=';
  static const offlinePoojaCancalUrl = '/api/v1/offlinepooja/user/order/cancel';
  static const getResheduleUrl =
      '/api/v1/offlinepooja/user/order/schedule/amount?orderId=';
  static const sheduleOrderIdUrl =
      '/api/v1/offlinepooja/user/order/schedule/pay';
  static const addOfflineReviewUrl = '/api/v1/offlinepooja/addreview';
  static const offlineRemainingPayUrl =
      '/api/v1/offlinepooja/user/order/remaining/pay';
  static const fetchWalletAmount = '/api/v1/pooja/wallet-balance/';
  static const fetchOfflineInvoiceUrl = '/api/v1/pooja/offlinepooja/invoice/';
  static const getOfflineDataUrl =
      '/api/v1/offlinepooja/user/order/details?orderId=';
  static const offlineCategoryUrl = '/api/v1/offlinepooja/category';
  static const panditPolicyUrl = '/api/v1/offlinepooja/policy';
  static const panditSubCategoryUrl = '/api/v1/offlinepooja/list?type=';

  //Mahakal API URl's
  static const trackOrderReviewSetUrl = '/api/v1/service/add/review';
  static const trackOrderGetData = '/api/v1/pooja/pooja-details/';

  //UserEmailUpdate
  static const userEmailUpdate = '/api/v1/auth/customer-email-update';
  //MahaBhandar
  static const choghadiyaUrl = '/api/v1/astro/chaughadiya';
  static const choghadiyaDayUrl = '/api/v1/astro/old-chaughadiya';
  static const horaUrl = '/api/v1/astro/hora';
  static const horaDayUrl = '/api/v1/astro/old-hora';
  static const grahoUrl = '/api/v1/astro/planate/position';
  static const panchangUrl = '/api/v1/astro/panchang';
  static const moonImageURl = '/api/v1/astro/moonimage';

  //Caculator
  static const orignalNumberUrl = '/api/v1/calculator/mool-ank';
  static const rashiNamakUrl = '/api/v1/calculator/rashi-namakshar';
  static const rashiListURL = '/api/v1/astro/rashi/list';
  static const kaalSarpUrl = '/api/v1/calculator/kalsarp-dosha';
  static const manglikDoshUrl = '/api/v1/calculator/manglik-dosh';
  static const pitrDoshUrl = '/api/v1/calculator/pitra-dosha';
  static const vimshottariUrl = '/api/v1/calculator/vimshottari-dasha';
  static const vimshottariMahaUrl = '/api/v1/calculator/maha-vimshottari';
  static const gemSuggestionUrl = '/api/v1/calculator/gem-suggestion';
  static const prayerSugestionUrl = '/api/v1/calculator/prayer-suggestion';
  static const rudrakshSugestionUrl = '/api/v1/calculator/rudraksha-suggestion';

  //Janm-Jankari se janiye
  static const anukulMantra = '/api/v1/astro/fav-mantra';
  static const shubhVrat = '/api/v1/astro/fast';
  static const anukulDev = '/api/v1/astro/fav-lord';
  static const anukulTime = '/api/v1/astro/fav-time';
  static const monthlyFestival = '/api/v1/astro/panchang-events';
  static const getFestivalDetails = '/api/v1/astro/events-name?eventName=';
  static const shubhMuhrt = '/api/v1/astro/muhurat';
  static const orderPdfurl = '/api/v1/birth_journal/getbirthpdf';
  static const createBirthPdfUrl = '/api/v1/birth_journal/createbirthpdf';
  static const getBirthByIdUrl = '/api/v1/birth_journal/getbirthjournalbyid';
  static const getMahuratUrl = '/api/v1/astro/muhurat?year=';
  static const createPdfLeadsUrl = '/api/v1/birth_journal/create-leads';
  static const getBirthJournal = '/api/v1/birth_journal/getbirthjournal';
  static const specialMahuratUrl = '/api/v1/astro/special-muhurat';

  //Kundli
  static const kundliURL = '/api/v1/astro/kundali';
  static const kundliDeleteURL = '/api/v1/astro/delete-kundali/';
  static const kundliSaveURL = '/api/v1/astro/save-user-kundali/';
  static const kundliMilanURL = '/api/v1/astro/kundali/milan';
  static const kundliMilanDeleteURL = '/api/v1/astro/delete-kundali-milan/';
  static const kundliMilanSaveURL =
      '/api/v1/astro/save-user-kundali-milan-list/';
  static const moonImagePathURL = '/storage/app/public/panchang-moon-img/';
  static const northChartURL = '/api/v1/astro/north-charts?';
  static const southChartURL = '/api/v1/astro/south-charts?';

  //Login&Register
  static const mobileCheckURl = '/api/v1/auth/customer-login';
  static const userRegisterURl = '/api/v1/auth/customer-register';

  // Mandir darshan
  static const allMandirDarshan = '/api/v1/temple/temple';
  static const darshanCategoryUrl = '/api/v1/temple/category_list';
  static const getTempleUrl = '/api/v1/temple/gettemple';
  static const getHotelUrl = '/api/v1/hotel/gethotels';
  static const getCityUrl = '/api/v1/cities/getcities';
  static const getRestaurantUrl = '/api/v1/restaurant/getrestaurant';
  static const getTempleDetailUrl = '/api/v1/temple/gettemplebyid';
  static const templeCommentUrl = '/api/v1/temple/gettemplecomment';
  static const setTempleReview = '/api/v1/temple/templeaddcomment';
  static const packageTempleLead = '/api/v1/temple/lead-add';
  static const packageTempleDetail = '/api/v1/temple/darshan-booking';
  static const packageTempleLeadUpdate = '/api/v1/temple/leads-update';
  static const placeOrderTemple = '/api/v1/temple/booking-success';
  static const sendAadharOtp = '/api/v1/darshan/aadhar-send-otp';
  static const sendAadharOtpVerify = '/api/v1/darshan/aadhar-otp-verify';

  // Mandir Url
  static const bhagwanUrl = '/api/v1/bhagwan/bhagwan-logs';
  static const getMandirTabsUrl = '/api/v1/bhagwan';
  static const wallpaperData = '/api/v1/bhagwan/wallpaper';

  //Rashi-Fal
  static const rashiDailyData = '/api/v1/astro/rashi/detail';
  static const rashiMonthlyData = '/api/rashiphal/monthly';
  static const rashiYearlyData = '/api/v1/astro/rashi/detail';

  //Astrology
  static const shubhmuhuratUrl = '/api/v1/astro/shubhmuhurat';
  static const consultaionUrl = '/api/v1/astro/counselling';
  static const consultationDetailUrl = '/api/v1/astro/counselling_detail/';
  static const consultancyReviewsUrl = '/api/v1/service/get/reviews/';
  static const counslingLeadStoreUrl = '/api/v1/pooja/counsellinglead-store';

  // astro page
  static const imagesUrl = 'https://mahakal.com/storage/app/public/banner/';

  //Pooja home
  static const poojaCategoryUrl = '/api/v1/pooja/getpooja-category/33';
  static const poojaSubCategoryUrl = '/api/v1/pooja/sub-category/';
  static const poojaAllUrl = '/api/v1/pooja';
  static const anushthanHomeUrl = '/api/v1/pooja/all-anushthan';
  static const chadhavaHomeUrl = '/api/v1/pooja/all-chadhava';
  static const vipHomeUrl = '/api/v1/pooja/allvip-pooja';
  static const allOrdersUrl = '/api/v1/pooja/all-orders';
  static const fetchInvoiceUrl = '/api/v1/birth_journal/invoice/';

  //pooja single details
  static const poojaSingleDetailUrl = '/api/v1/pooja/sname/';
  static const offlinePoojaSingleDetailUrl =
      '/api/v1/offlinepooja/details?slug=';
  static const chadhavaDetailUrl = '/api/v1/pooja/chadhava-details/';
  static const anushthanDetailUrl = '/api/v1/pooja/anushthan-details/';
  static const vipDetailsUrl = '/api/v1/pooja/vip-details/';
  static const poojaSankalpUrl = '/api/v1/pooja/pooja-sankalp/';
  static const poojaOrderPlaceUrl = '/api/v1/pooja/pooja-place-order';
  static const chadhavaOrderPlaceUrl = '/api/v1/pooja/chadhava-place-order';
  static const chadhavaLeadUrl = '/api/v1/pooja/chadhavalead-store';
  static const poojaLeadUrl = '/api/v1/pooja/lead-store';
  static const vipLeadUrl = '/api/v1/pooja/viplead-store';
  static const anushthanLeadUrl = '/api/v1/pooja/anushthanlead-store';
  static const charityProductdUrl = '/api/v1/pooja/charity-store';
  static const setChadhavaReviewUrl = '/api/v1/service/add/review';
  static const trackChadhavaUrl = '/api/v1/pooja/chadhava-details-order/';
  static const fetchChadhavaInvoiceUrl = '/api/v1/pooja/chadhava/invoice/';
  static const fetchChadhavaTrackUrl = '/api/v1/pooja/chadhavatrack/';
  static const poojaWalletUrl = '/api/v1/pooja/wallet-balance/';
  static const applyPoojaCouponUrl = '/api/v1/pooja/apply';
  static const fetchPoojaCouponUrl = '/api/v1/pooja/list?coupon_type=';
  static const poojaPrashadTrackUrl = '/api/v1/pooja/prashadtrack/';
  static const poojaServiceTrackUrl = '/api/v1/pooja/servicetrack/';

  //order screen
  static const poojaOrderUrl = '/api/v1/pooja/orders?type=pooja';
  static const offlinePoojaOrderUrl = '/api/v1/offlinepooja/user/order/list';
  static const vipOrderUrl = '/api/v1/pooja/orders?type=vip';
  static const anushthanOrderUrl = '/api/v1/pooja/orders?type=anushthan';
  static const chadhavaOrderUrl = '/api/v1/pooja/orders?type=chadhava';
  static const counsellingOrderUrl = '/api/v1/pooja/orders?type=counselling';
  static const getSankalpDataUrl = '/api/v1/pooja/counselling-sankalp-store';
  static const upDateSankalpDataUrl = '/api/v1/pooja/counselling-sankalp-update/';
  static const setReviewDataUrl = '/api/v1/service/add/review';
  static const getTrackDataUrl = '/api/v1/pooja/pooja-details/';
  static const getCounsInvoiceUrl = '/api/v1/pooja/counselling/invoice/';
  static const serviceTrackUrl = '/api/v1/pooja/servicetrack/';
  static const fetchOnlinePoojaInvoiceUrl = '/api/v1/pooja/';
  static const darshanUrl = '/api/v1/temple/booking-list';

  // Ram Shalakha
  static const ramshalakhaUrl = '/api/v1/sahitya/ram-shalaka';

  // All Pandit
  static const allPanditUrl = "/api/v1/guruji?city=";
  // static const allPanditServicesUrl = "/api/v1/guruji/detail?id=";
  static const allPanditDetailsUrl = "/api/v1/guruji/puja?guruji_id=";
  static const allPanditSuccessUrl = "/api/v1/guruji/puja/lead";
  static const allPanditPersonUrl = "/api/v1/guruji/puja/sankalp/store";
  static const allPanditOrderUrl = "/api/v1/pooja/orders?type=panditpooja";
  static const allPanditCounsellingUrl = "/api/v1/guruji/counselling/?guruji_id=";
  static const allPanditCounsellingLeadUrl = "/api/v1/guruji/counselling/lead";
  static const allPanditCounsellingSuccessUrl = "/api/v1/guruji/counselling/sankalp/store";
  static const allPanditServiceUrl = "/api/v1/guruji/detail?id=";

  // Tour Booking
  static const String newTourDataUrl = '/api/v1/tour/new-tours';
  static const String tourCategoryUrl = '/api/v1/tour/tour-category';
  static const String tourStateUrl = '/api/v1/tour/tour';
  static const String tourCityUrl = '/api/v1/tour/tour';
  static const String tourTravellersInfoUrl =
      '/api/v1/tour/tour-traveller-info';
  static const String tourDetailsUrl = '/api/v1/tour/tour-by-id?tour_id=';
  static const String fetchTourDistanceUrl = '/api/v1/tour/tour-get-distance';
  static const String tourLeadUrl = '/api/v1/tour/create-lead';
  static const String successTourAmount = '/api/v1/tour/tour-booking';
  static const String tourCouponUrl = '/api/v1/tour/coupon-list-type';
  static const String tourApplyCouponUrl = '/api/v1/tour/tour-coupon-apply';
  static const String tourWalletUrl = '/api/v1/pooja/wallet-balance/';
  static const String addCommentUrl = '/api/v1/tour/add-tour-comment';
  static const String fetchCommentUrl = '/api/v1/tour/get-tour-comment';
  static const String remainingAmountUrl =
      '/api/v1/tour/tour-booking-remming-pay';
  static const String cancalTourUrl = '/api/v1/tour/tour-order-cancel';
  static const String tourOrderDetailsUrl = '/api/v1/tour/tour-booking-list';
  static const String tourBookingPolicyUrl = '/api/v1/tour/tour-booking-policy';
  static const String tourBookingInvoiceUrl =
      '/api/v1/tour/tour-order-invoice/';
  static const String tourAllStateUrl = '/api/v1/tour/get-states';
  static const String tourSearchUrl = '/api/v1/tour/search';
  static const String tourAllVendorUrl = '/api/v1/tour/vendor/all';
  static const String allVendorTourUrl = '/api/v1/tour/vendor/tour?id=';
  static const String tourImagesUrl = '/api/v1/tour/banner';
  static const String tourDatesUrl = '/api/v1/tour/tour-find-seat-availability';

  // Event Booking
  static const String eventCategoryUrl = '/api/v1/event/getcategory';
  static const String eventSubCategoryUrl = '/api/v1/event/getevent';
  static const String eventBannersUrl = '/api/v1/banners';
  static const String eventDetailsUrl = '/api/v1/event/geteventbyid';
  static const String eventIntrestedUrl = '/api/v1/event/addinterested';
  static const String eventPassUrl = '/api/v1/event/get-qr-code';
  static const String addEventCommentUrl = '/api/v1/event/Eventaddcomment';
  static const String fetchEventCommentUrl = '/api/v1/event/geteventcomment';
  static const String orderSuccessUrl = '/api/v1/event/eventorder';
  static const String eventOrderListUrl = '/api/v1/event/eventorderlist';
  static const String eventOrderPassUrl = '/api/v1/event/event-order-pass';
  static const String eventCouponApplyUrl = '/api/v1/event/eventcoupon';
  static const String eventLeadUrl = '/api/v1/event/event-leads';
  static const String upDateLeadUrl = '/api/v1/event/event-lead-update';

  // Donation
  static const String donationTrustDetailsUrl = '/api/v1/donate/trustget';
  static const String donationAdsUrl = '/api/v1/donate/donatetrust';
  static const String donationCategoryUrl = '/api/v1/donate/getcategory';
  static const String donationPurposeUrl = '/api/v1/donate/getpurpose';
  static const String donationWalletUrl = '/api/v1/pooja/wallet-balance/';
  static const String donationLeadUrl = '/api/v1/donate/donateamount';
  static const String donationLeadUpdateUrl =
      '/api/v1/donate/donateamountupdate';
  static const String donationAmountSuccessUrl =
      '/api/v1/donate/donateamountsuccess';
  static const String donationOrderUrl = '/api/v1/donate/donateorder';
  static const String donationInvoiceUrl = '/api/v1/donate/invoice/';
  static const String donationPanUrl = '/api/v1/donate/pan-card-verified-check';
  static const String donationSubsCancalUrl =
      '/api/v1/donate/cancel-subscription';

  // Sahitya
  static const String sahityaVerseUrl =
      '/api/v1/sahitya/bhagvad-geeta?chapter=';
  static const String sahityaGridUrl = '/api/v1/sahitya';

  // Sangeet
  static const String sangeetCategoryUrl = '/api/v1/sangeet/category';
  static const String sangeetGetByCategoryUrl =
      '/api/v1/sangeet/get-by-sangeet-category/';
  static const String sangeetLanguageUrl = '/api/v1/sangeet/language';
  static const String fetchSangeetDataUrl =
      '/api/v1/sangeet/sangeet-details?subcategory_id=';
  static const String getAllCategorySangeetData =
      '/api/v1/sangeet/sangeet-all-details?category_id=';

  // Blog
  static const String blogsSubCategoryUrl =
      '/api/v1/blog/category-by-blog?languageId=';
  static const String blogsDetailsUrl = '/api/v1/blog/get-blog-detail/';
  static const String blogsCategoryUrl =
      '/api/v1/blog/category-blog?languageId=';

  // Mandir (Sangeet)
  static const String mandirSangeetDataUrl =
      '/api/v1/bhagwan/bhagwan-sangeet?category_id=';
  static const String getBhajanByGodUrl =
      '/api/v1/bhagwan/get-by-category-name';
  static const String mandirChadhavaUrl =
      '/api/v1/bhagwan/get-bhagwan-chadhava/';
  static const String mandirTabsUrl = '/api/v1/bhagwan';

  // Youtube Vides
  static const String youtubeSubCategoryUrl =
      '/api/v1/astro/get-by-youtube-category/';
  static const String youtubeCategoryUrl =
      '/api/v1/astro/youtube/video/category';
  static const String youtubeAllVideosUrl =
      '/api/v1/video/video-by-listType?subcategory_id=';

  //Explore Screen App Section
  static const sectionSwitcherUrl = '/api/v1/appsection/app-section';

  // sharePreference
  static const String userLoginToken = 'user_login_token';
  static const String guestId = 'guestId';
  static const String user = 'user';
  static const String userEmail = 'user_email';
  static const String userPassword = 'user_password';
  static const String homeAddress = 'home_address';
  static const String searchProductName = 'search_product';
  static const String officeAddress = 'office_address';
  static const String config = 'config';
  static const String guestMode = 'guest_mode';
  static const String currency = 'currency';
  static const String langKey = 'lang';
  static const String intro = 'intro';
  static const String countryDefault = 'u';
  static const pi = 3.14;
  static const defaultSpread = 0.0872665;
  static const double minFilter = 0;
  static const double maxFilter = 1000000;

  // Jap and Ram Lekhan
  static const String japCountUrl = '/api/v1/jaap/get-jaap-count';
  static const String ramLekhanUrl = '/api/v1/jaap/get-ram-lekhan';
  static const String deleteJapCountUrl = '/api/v1/jaap/delete-jaap-count/';
  static const String deleteramLekhanCountUrl =
      '/api/v1/jaap/delete-ram-lekhan/';
  static const String saveJapCountUrl = '/api/v1/jaap/jaap-count';
  static const String saveRamLekhanUrl = '/api/v1/jaap/ram-lekhan';

  // order status
  static const String pending = 'pending';
  static const String confirmed = 'confirmed';
  static const String processing = 'processing';
  static const String processed = 'processed';
  static const String delivered = 'delivered';
  static const String failed = 'failed';
  static const String returned = 'returned';
  static const String cancelled = 'canceled';
  static const String outForDelivery = 'out_for_delivery';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String theme = 'theme';
  static const String topic = 'sixvalley';
  static const String userAddress = 'user_address';

  //AstroTalk
  static const String astrologersCategory = '/api/v1/astrologer/category';
  static const String expressURI = 'https://astro-server.pavtr.in';
  static const String expressApiURI = '$expressURI/api';
  static const String astrologersList = '$expressApiURI/astrologers';
  static const String fetchAstrologersByCategory= '$expressApiURI/astrologers?category=';
  static const String astrologersChatSave = '$expressApiURI/chat/save';
  static const String astrologersImages =
      '$baseUrl/storage/app/public/astrologers/';
  static const String getAstrologersChatData = '$expressApiURI/chat/get';
  static const String sendAstrologersChat = '$expressApiURI/chat/save';
  static const String liveAstrologers = '$expressApiURI/live-stream/active';
  static const String onlineAstrologersList =
      '$expressApiURI/astrologers/online/astrologers';
  static const String astrologerLiveStreamURL =
      'https://stream.mahakal.com/hls/';
  static const String poojaLiveStreamURL = 'https://stream.mahakal.com/live/';

  // Support Tickit
  static const String supportIssuesUrl = '/api/v1/customer/supports/issues';
  static const String supportIssuesTypeUrl =
      '/api/v1/customer/supports/issue-type';

  // Hotels Booking
  static const String featuredHotelsUrl = '/api/hotels/featured';
  static const String allHotelsUrl = '/api/hotels';
  static const String hotelLocationsUrl = '/api/locations';
  static const String hotelPapulerUrl = '/api/hotels?location_id=';
  static const String hotelAvaliblityCheckUrl = '/api/hotels/check-availablity';
  static const String hotelDetailsUrl = '/api/hotels/details/';
  static const String hotelAddtoCartUrl = '/api/bookapi/add-to-cart';
  static const String hotelUserUrl = '/api/register/user';
  static const String hotelBookUrl = '/api/bookapi/hotel-checkout';
  static const String hotelOrdersUrl = '/api/user/orders';
  static const String drafthotelOrdersUrl = '/api/user/orders?status=draft';
  static const String hotelSpacesUrl = '/api/spaces';
  static const String spaceDetailsUrl = '/api/spaces/';



  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: Images.en,
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: Images.hi,
        languageName: 'Hindi',
        countryCode: 'IN',
        languageCode: 'hi'),
    // LanguageModel(imageUrl: Images.ar, languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
    // LanguageModel(imageUrl: Images.bn, languageName: 'Bangla', countryCode: 'BD', languageCode: 'bn'),
    // LanguageModel(imageUrl: Images.es, languageName: 'Spanish', countryCode: 'ES', languageCode: 'es'),
  ];
}
