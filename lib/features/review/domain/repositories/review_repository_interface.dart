import 'dart:io';
import 'package:mahakal/features/review/domain/models/review_body.dart';
import 'package:mahakal/interface/repo_interface.dart';

abstract class ReviewRepositoryInterface
    implements RepositoryInterface<ReviewBody> {
  Future<dynamic> submitReview(
      ReviewBody reviewBody, List<File> files, bool update);

  Future<dynamic> getOrderWiseReview(String productID, String orderId);

  Future<dynamic> deleteOrderWiseReviewImage(String id, String name);
}
