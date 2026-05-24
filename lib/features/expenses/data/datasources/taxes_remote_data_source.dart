import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/tax_model.dart';
import 'authenticated_supabase_data_source.dart';

abstract class TaxesRemoteDataSource {
  Future<List<TaxModel>> getTaxes();
}

class TaxesRemoteDataSourceImpl
    with AuthenticatedSupabaseDataSource
    implements TaxesRemoteDataSource {
  TaxesRemoteDataSourceImpl(this.client);

  @override
  final SupabaseClient client;

  static const _table = 'taxes';

  @override
  Future<List<TaxModel>> getTaxes() async {
    final response = await client
        .from(_table)
        .select()
        .eq('user_id', currentUserId)
        .eq('is_active', true)
        .isFilter('deleted_at', null)
        .order('name', ascending: true);

    return rowsAsMaps(response).map(TaxModel.fromJson).toList();
  }
}
