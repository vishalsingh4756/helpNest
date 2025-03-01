import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackEntity {
  final String id;
  final num rating;
  final String module;
  final String category;
  final String title;
  final String description;
  final String response;
  final Timestamp responseTD;
  final Timestamp creationTD;
  final String createdBy;
  final bool deactivate;

  FeedbackEntity(
      {required this.id,
      required this.rating,
      required this.module,
      required this.category,
      required this.title,
      required this.description,
      required this.response,
      required this.responseTD,
      required this.creationTD,
      required this.createdBy,
      required this.deactivate});
}
