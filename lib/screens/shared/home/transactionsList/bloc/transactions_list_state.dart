part of 'transactions_list_bloc.dart';

@immutable
abstract class TransactionsListState {}

class TransactionsListStateProcessing extends TransactionsListState {}

class TransactionsListStateDefault extends TransactionsListState {
  TransactionsListStateDefault(this.transactions);

  final List<WorkTransaction> transactions;
}

class TransactionsListStateError extends TransactionsListState {
  TransactionsListStateError(this.error);

  final dynamic error;
}
