import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/vendor_model.dart';
import '../../../vendors/presentation/utils/vendor_status_utils.dart';
import 'authenticated_supabase_data_source.dart';

abstract class VendorsRemoteDataSource {
  Future<List<VendorModel>> getVendors({
    String? search,
    String? status,
  });
  Future<VendorModel> createVendor(String name);
  Future<VendorModel> getVendorById(String id);
  Future<VendorModel> createVendorRecord(VendorModel vendor);
  Future<VendorModel> updateVendor(VendorModel vendor);
  Future<void> deleteVendor(String id);
}

class VendorsRemoteDataSourceImpl
    with AuthenticatedSupabaseDataSource
    implements VendorsRemoteDataSource {
  VendorsRemoteDataSourceImpl(this.client);

  @override
  final SupabaseClient client;

  static const _table = 'vendors';

  @override
  Future<List<VendorModel>> getVendors({
    String? search,
    String? status,
  }) async {
    dynamic query = client.from(_table).select().eq('user_id', currentUserId);

    final normalizedStatus = _normalizeOptional(status);
    if (normalizedStatus != null) {
      query = query.eq('status', VendorStatusUtils.normalize(normalizedStatus));
    }

    final normalizedSearch = _normalizeOptional(search);
    if (normalizedSearch != null) {
      query = query.or(
        'name.ilike.%$normalizedSearch%,'
        'phone.ilike.%$normalizedSearch%,'
        'email.ilike.%$normalizedSearch%,'
        'address.ilike.%$normalizedSearch%,'
        'tax_number.ilike.%$normalizedSearch%',
      );
    }

    final response = await query.order('updated_at', ascending: false);
    return rowsAsMaps(response).map(VendorModel.fromJson).toList();
  }

  @override
  Future<VendorModel> createVendor(String name) {
    return createVendorRecord(
      VendorModel(
        id: '',
        userId: '',
        name: name.trim(),
        status: VendorStatusUtils.active,
      ),
    );
  }

  @override
  Future<VendorModel> getVendorById(String id) async {
    final response = await client
        .from(_table)
        .select()
        .eq('id', id)
        .eq('user_id', currentUserId)
        .single();

    return VendorModel.fromJson(rowAsMap(response));
  }

  @override
  Future<VendorModel> createVendorRecord(VendorModel vendor) async {
    final userId = currentUserId;
    final now = DateTime.now().toIso8601String();
    final payload = _payloadForInsert(vendor, userId, now);

    final response = await client.from(_table).insert(payload).select().single();
    return VendorModel.fromJson(rowAsMap(response));
  }

  @override
  Future<VendorModel> updateVendor(VendorModel vendor) async {
    final payload = _payloadForUpdate(vendor, currentUserId);

    final response = await client
        .from(_table)
        .update(payload)
        .eq('id', vendor.id)
        .eq('user_id', currentUserId)
        .select()
        .single();

    return VendorModel.fromJson(rowAsMap(response));
  }

  @override
  Future<void> deleteVendor(String id) async {
    await client
        .from(_table)
        .delete()
        .eq('id', id)
        .eq('user_id', currentUserId);
  }

  Map<String, dynamic> _payloadForInsert(
    VendorModel vendor,
    String userId,
    String now,
  ) {
    final payload = dataForInsert(vendor.toJson(), userId);
    payload['name'] = vendor.name.trim();
    payload['created_at'] = now;
    payload['updated_at'] = now;
    _normalizeOptionalField(payload, 'phone');
    _normalizeOptionalField(payload, 'email');
    _normalizeOptionalField(payload, 'address');
    _normalizeOptionalField(payload, 'tax_number');
    _normalizeOptionalField(payload, 'notes');
    final normalizedStatus = _normalizeOptional(payload['status'] as String?);
    payload['status'] = VendorStatusUtils.normalize(normalizedStatus);
    return payload;
  }

  Map<String, dynamic> _payloadForUpdate(VendorModel vendor, String userId) {
    final payload = dataForUpdate(vendor.toJson(), userId);
    payload['name'] = vendor.name.trim();
    _normalizeOptionalField(payload, 'phone');
    _normalizeOptionalField(payload, 'email');
    _normalizeOptionalField(payload, 'address');
    _normalizeOptionalField(payload, 'tax_number');
    _normalizeOptionalField(payload, 'notes');
    final normalizedStatus = _normalizeOptional(payload['status'] as String?);
    payload['status'] = VendorStatusUtils.normalize(normalizedStatus);
    return payload;
  }

  void _normalizeOptionalField(Map<String, dynamic> payload, String key) {
    final normalized = _normalizeOptional(payload[key] as String?);
    if (normalized == null) {
      payload.remove(key);
      return;
    }
    payload[key] = normalized;
  }

  String? _normalizeOptional(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
