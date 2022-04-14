part of 'debit_cubit.dart';

@immutable
abstract class DebitState {}

class DebitInitial extends DebitState {}
class DebitProcessing extends DebitState {}

class AddDebitResult extends DebitState {
  final SafeResponse response;

  AddDebitResult(this.response);
}
