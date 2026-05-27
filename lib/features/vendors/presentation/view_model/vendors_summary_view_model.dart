import 'package:equatable/equatable.dart';

class VendorsSummaryViewModel extends Equatable {
  const VendorsSummaryViewModel({
    required this.totalCount,
    required this.withEmailCount,
    required this.withPhoneCount,
  });

  final int totalCount;
  final int withEmailCount;
  final int withPhoneCount;

  @override
  List<Object?> get props => [totalCount, withEmailCount, withPhoneCount];
}
