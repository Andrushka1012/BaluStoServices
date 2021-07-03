import 'dart:async';

import 'package:balu_sto/features/firestore/firestore_repository.dart';
import 'package:balu_sto/features/firestore/models/transaction.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'transaction_details_event.dart';

part 'transaction_details_state.dart';

class TransactionDetailsBloc extends Bloc<TransactionDetailsEvent, TransactionDetailsState> {
  TransactionDetailsBloc(this._transactionId, this._firestoreRepository) : super(TransactionDetailsStateProcessing());

  final String _transactionId;
  final FirestoreRepository _firestoreRepository;

  @override
  Stream<TransactionDetailsState> mapEventToState(TransactionDetailsEvent event) async* {
    if (event == TransactionDetailsEvent.INIT) {
      yield* _init();
    }
  }

  Stream<TransactionDetailsState> _init() async* {
    final detailsResponse = await _firestoreRepository.getTransactionDetails(_transactionId);

    if (detailsResponse.isSuccessful) {
      yield TransactionDetailsStateDefault(detailsResponse.requiredData);
    } else {
      yield TransactionDetailsStateError(detailsResponse.requiredError);
    }
  }
}
