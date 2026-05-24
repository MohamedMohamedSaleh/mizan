import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/vendor_model.dart';
import 'authenticated_supabase_data_source.dart';

abstract class VendorsRemoteDataSource {
  Future<List<VendorModel>> getVendors();
  Future<VendorModel> createVendor(String name);
}

class VendorsRemoteDataSourceImpl
    with AuthenticatedSupabaseDataSource
    implements VendorsRemoteDataSource {
  VendorsRemoteDataSourceImpl(this.client);

  @override
  final SupabaseClient client;

  static const _table = 'vendors';

  @override
  Future<List<VendorModel>> getVendors() async {
    final response = await client
        .from(_table)
        .select()
        .eq('user_id', currentUserId)
        .eq('is_active', true)
        .isFilter('deleted_at', null)
        .order('name', ascending: true);

    return rowsAsMaps(response).map(VendorModel.fromJson).toList();
  }

  @override
  Future<VendorModel> createVendor(String name) async {
    final userId = currentUserId;
    final now = DateTime.now().toIso8601String();
    final response = await client
        .from(_table)
        .insert({
          'user_id': userId,
          'name': name.trim(),
          'is_active': true,
          'created_at': now,
          'updated_at': now,
          'deleted_at': null,
        })
        .select()
        .single();

    return VendorModel.fromJson(rowAsMap(response));
  }
}
