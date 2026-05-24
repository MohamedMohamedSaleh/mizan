import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';

mixin AuthenticatedSupabaseDataSource {
  SupabaseClient get client;

  String get currentUserId {
    final userId = client.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      throw const AuthFailure(message: 'User is not authenticated.');
    }
    return userId;
  }

  Map<String, dynamic> rowAsMap(Object? row) {
    if (row is Map<String, dynamic>) return row;
    if (row is Map) return Map<String, dynamic>.from(row);
    throw const ServerFailure(message: 'Invalid server response.');
  }

  List<Map<String, dynamic>> rowsAsMaps(Object? rows) {
    if (rows is! List) {
      throw const ServerFailure(message: 'Invalid server response.');
    }
    return rows.map(rowAsMap).toList();
  }

  Map<String, dynamic> dataForInsert(
    Map<String, dynamic> data,
    String userId, {
    bool keepId = true,
  }) {
    final payload = Map<String, dynamic>.from(data);
    if (!keepId || payload['id'] == '') payload.remove('id');
    payload['user_id'] = userId;
    return payload;
  }

  Map<String, dynamic> dataForUpdate(Map<String, dynamic> data, String userId) {
    final payload = Map<String, dynamic>.from(data);
    payload.remove('id');
    payload.remove('created_at');
    payload['user_id'] = userId;
    payload['updated_at'] = DateTime.now().toIso8601String();
    return payload;
  }
}
