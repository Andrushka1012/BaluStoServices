import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/screens/shared/home/bloc/debit_cubit.dart';
import 'package:balu_sto/widgets/containers/progress_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin/internals.dart';

showDebitDialog(BuildContext context, String userId, {required bool addDebit}) {
  final _textFieldController = TextEditingController();
  final DebitCubit cubit = KoinContextHandler.get().get();
  showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<DebitCubit>(
          create: (_) => cubit,
          child: BlocListener<DebitCubit, DebitState>(
            listener: (_, state) {
              if (state is AddDebitResult) {
                if (state.response.isSuccessful) {
                  Navigator.of(context).pop();
                } else {
                  showErrorDialog(context, state.response.requiredError);
                }
              }
            },
            child: BlocBuilder<DebitCubit, DebitState>(
              builder: (_, state) => ProgressContainer(
                isProcessing: state is DebitProcessing,
                child: AlertDialog(
                  title: Text(
                    addDebit ? 'Дать в долг' : 'Забрать долг',
                    style: AppTextStyles.headline1,
                  ),
                  backgroundColor: AppColors.background,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/kolywan.jpeg'),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: _textFieldController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Простить'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text('Записать'),
                      onPressed: () {
                        try {
                          final int debitAmount = int.parse(_textFieldController.value.text);
                          addDebit ? cubit.addDebit(
                            userId,
                            debitAmount,
                          ) : cubit.payDebit(
                            userId,
                            debitAmount,
                          );
                        } catch (error) {
                          showErrorDialog(context, error);
                          return;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
