import 'package:mahakal/data/datasource/remote/dio/dio_client.dart';
import 'package:mahakal/data/datasource/remote/exception/api_error_handler.dart';
import 'package:mahakal/data/model/api_response.dart';
import 'package:mahakal/features/deal/domain/repositories/flash_deal_repository_interface.dart';
import 'package:mahakal/utill/app_constants.dart';

class FlashDealRepository implements FlashDealRepositoryInterface {
  final DioClient? dioClient;
  FlashDealRepository({required this.dioClient});

  @override
  Future<ApiResponse> getFlashDeal() async {
    try {
      final response = await dioClient!.get(AppConstants.flashDealUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> get(String productID) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.flashDealProductUri}$productID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
