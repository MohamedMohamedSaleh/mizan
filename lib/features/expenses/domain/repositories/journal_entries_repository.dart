import '../../../../core/utils/result.dart';
import '../entities/journal_entry_entity.dart';
import '../entities/journal_entry_line_entity.dart';

abstract class JournalEntriesRepository {
  Future<Result<JournalEntryEntity>> createJournalEntry(
    JournalEntryEntity entry,
  );
  Future<Result<void>> createJournalEntryLines(
    List<JournalEntryLineEntity> lines,
  );
  Future<Result<void>> voidJournalEntry(String id);
}
