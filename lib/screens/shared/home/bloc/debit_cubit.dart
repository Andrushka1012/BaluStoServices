import 'package:balu_sto/features/firestore/firestore_repository.dart';
import 'package:balu_sto/helpers/fetch_helpers.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'debit_state.dart';

class DebitCubit extends Cubit<DebitState> {
  DebitCubit(this._firestoreRepository) : super(DebitInitial());

  final FirestoreRepository _firestoreRepository;

  Future addDebit(String userId, int debitAmount) async {
    final currentState = state;
    if (state is! DebitInitial) return;

    emit(DebitProcessing());

    final addDebitResponse = await _firestoreRepository.addDebit(userId, debitAmount);

    emit(AddDebitResult(addDebitResponse));
    emit(currentState);
  }

  Future payDebit(String userId, int debitAmount) async {
    final currentState = state;
    if (state is! DebitInitial) return;

    emit(DebitProcessing());

    final addDebitResponse = await _firestoreRepository.payDebit(userId, debitAmount);

    emit(AddDebitResult(addDebitResponse));
    emit(currentState);
  }
}
