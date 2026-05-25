import '../../../../core/utils/result.dart';
import '../../domain/entities/journal_entry_entity.dart';
import '../../domain/entities/journal_entry_line_entity.dart';
import '../../domain/repositories/journal_entries_repository.dart';
import '../datasources/journal_entries_remote_data_source.dart';
import '../models/journal_entry_line_model.dart';
import '../models/journal_entry_model.dart';
import 'expense_repository_guard.dart';

class JournalEntriesRepositoryImpl implements JournalEntriesRepository {
  JournalEntriesRepositoryImpl(this._remoteDataSource);

  final JournalEntriesRemoteDataSource _remoteDataSource;

  @override
  Future<Result<JournalEntryEntity>> createJournalEntry(
    JournalEntryEntity entry,
  ) {
    return guardExpenseRepositoryCall<JournalEntryEntity>(() async {
      return (await _remoteDataSource.createJournalEntry(
        JournalEntryModel.fromEntity(entry),
      ))
          .toEntity();
    });
  }

  @override
  Future<Result<JournalEntryEntity>> updateJournalEntry(
    JournalEntryEntity entry,
  ) {
    return guardExpenseRepositoryCall<JournalEntryEntity>(() async {
      return (await _remoteDataSource.updateJournalEntry(
        JournalEntryModel.fromEntity(entry),
      ))
          .toEntity();
    });
  }

  @override
  Future<Result<void>> createJournalEntryLines(
    List<JournalEntryLineEntity> lines,
  ) {
    return guardExpenseRepositoryCall<void>(() {
      return _remoteDataSource.createJournalEntryLines(
        lines.map(JournalEntryLineModel.fromEntity).toList(),
      );
    });
  }

  @override
  Future<Result<void>> replaceJournalEntryLines(
    String journalEntryId,
    List<JournalEntryLineEntity> lines,
  ) {
    return guardExpenseRepositoryCall<void>(() {
      return _remoteDataSource.replaceJournalEntryLines(
        journalEntryId,
        lines.map(JournalEntryLineModel.fromEntity).toList(),
      );
    });
  }

  @override
  Future<Result<void>> voidJournalEntry(String id) {
    return guardExpenseRepositoryCall<void>(
      () => _remoteDataSource.voidJournalEntry(id),
    );
  }
}
