import 'dart:async';

import 'package:balu_sto/features/firestore/firestore_repository.dart';
import 'package:balu_sto/features/firestore/models/transaction.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'transactions_list_event.dart';

part 'transactions_list_state.dart';

class TransactionsListBloc extends Bloc<TransactionsListEvent, TransactionsListState> {
  TransactionsListBloc(this._userId, this._firestoreRepository) : super(TransactionsListStateProcessing());

  final String? _userId;
  final FirestoreRepository _firestoreRepository;

  @override
  Stream<TransactionsListState> mapEventToState(TransactionsListEvent event) async* {
    switch (event) {
      case TransactionsListEvent.INIT:
        yield TransactionsListStateProcessing();

        final transactionsResponse = await _firestoreRepository.getTransactions(_userId);
        if (transactionsResponse.isSuccessful) {
          yield TransactionsListStateDefault(transactionsResponse.requiredData.reversed.toList());
        } else {
          yield TransactionsListStateError(transactionsResponse.requiredError);
        }

        break;
    }
  }
}
