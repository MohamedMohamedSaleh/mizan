import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/expense_enums.dart';
import '../models/expense_model_helpers.dart';
import '../models/journal_entry_line_model.dart';
import '../models/journal_entry_model.dart';
import 'authenticated_supabase_data_source.dart';

abstract class JournalEntriesRemoteDataSource {
  Future<JournalEntryModel> createJournalEntry(JournalEntryModel entry);
  Future<JournalEntryModel> updateJournalEntry(JournalEntryModel entry);
  Future<void> createJournalEntryLines(List<JournalEntryLineModel> lines);
  Future<void> replaceJournalEntryLines(
    String journalEntryId,
    List<JournalEntryLineModel> lines,
  );
  Future<void> voidJournalEntry(String id);
}

class JournalEntriesRemoteDataSourceImpl
    with AuthenticatedSupabaseDataSource
    implements JournalEntriesRemoteDataSource {
  JournalEntriesRemoteDataSourceImpl(this.client);

  @override
  final SupabaseClient client;

  static const _entriesTable = 'journal_entries';
  static const _linesTable = 'journal_entry_lines';

  @override
  Future<JournalEntryModel> createJournalEntry(JournalEntryModel entry) async {
    final userId = currentUserId;
    final payload = dataForInsert(entry.toJson(), userId);
    payload['created_at'] ??= DateTime.now().toIso8601String();
    payload['updated_at'] ??= DateTime.now().toIso8601String();
    payload['deleted_at'] = null;

    final response = await client
        .from(_entriesTable)
        .insert(payload)
        .select()
        .single();

    return JournalEntryModel.fromJson(rowAsMap(response));
  }

  @override
  Future<void> createJournalEntryLines(List<JournalEntryLineModel> lines) async {
    if (lines.isEmpty) return;
    final userId = currentUserId;
    final payload = lines.map((line) {
      final data = dataForInsert(line.toJson(), userId);
      data['created_at'] ??= DateTime.now().toIso8601String();
      return data;
    }).toList();

    await client.from(_linesTable).insert(payload);
  }

  @override
  Future<JournalEntryModel> updateJournalEntry(JournalEntryModel entry) async {
    final userId = currentUserId;
    final payload = dataForUpdate(entry.toJson(), userId);
    final response = await client
        .from(_entriesTable)
        .update(payload)
        .eq('id', entry.id)
        .eq('user_id', userId)
        .isFilter('deleted_at', null)
        .select()
        .single();

    return JournalEntryModel.fromJson(rowAsMap(response));
  }

  @override
  Future<void> replaceJournalEntryLines(
    String journalEntryId,
    List<JournalEntryLineModel> lines,
  ) async {
    final userId = currentUserId;
    await client
        .from(_linesTable)
        .delete()
        .eq('journal_entry_id', journalEntryId)
        .eq('user_id', userId);
    await createJournalEntryLines(lines);
  }

  @override
  Future<void> voidJournalEntry(String id) async {
    final userId = currentUserId;
    final now = DateTime.now().toIso8601String();
    await client
        .from(_entriesTable)
        .update({
          'status': ExpenseModelHelpers.enumToJson(JournalEntryStatus.voided),
          'deleted_at': now,
          'updated_at': now,
        })
        .eq('id', id)
        .eq('user_id', userId)
        .isFilter('deleted_at', null);
  }
}
