part of 'transaction_details_bloc.dart';

@immutable
abstract class TransactionDetailsState {}

class TransactionDetailsStateProcessing extends TransactionDetailsState {}

class TransactionDetailsStateDefault extends TransactionDetailsState {
  TransactionDetailsStateDefault(this.details);

  final TransactionDetails details;
}

class TransactionDetailsStateError extends TransactionDetailsState {
  TransactionDetailsStateError(this.error);

  final dynamic error;
}
