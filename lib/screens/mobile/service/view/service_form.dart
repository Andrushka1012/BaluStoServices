import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/screens/mobile/service/service/service_bloc.dart';
import 'package:balu_sto/widgets/containers/progress_container.dart';
import 'package:balu_sto/widgets/inputs/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceForm extends StatelessWidget {
  final _serviceNameController = TextEditingController();
  final _moneyAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServiceBloc, ServiceState>(
        listener: _handleEvents,
        buildWhen: (_, current) => current is DefaultServiceState || current is ServiceStateProcessing,
        builder: (context, ServiceState state) {
          if (state is DefaultServiceState) {
            _handleEvents(context, state);
          }
          return ProgressContainer(
            isProcessing: state is ServiceStateProcessing,
            child: Column(
              children: [
                TextInput(
                  controller: _serviceNameController,
                  label: 'Предоставленная услуга',
                  hint: 'Введите название услуги',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => context.read<ServiceBloc>().add(ServiceEventNameChanged(value)),
                ),
                TextInput(
                  controller: _moneyAmountController,
                  label: 'Стоимость услуги',
                  hint: 'Введите стоимость услуги',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) => context.read<ServiceBloc>().add(ServiceEventMoneyAmountChanged(value)),
                ),
                SizedBox(
                  width: double.infinity,
                  height: Dimens.spanSmallerGiant,
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Записать', style: AppTextStyles.bodyText1),
                        SizedBox(
                          width: Dimens.spanTiny,
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: Dimens.spanMedium,
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(primary: AppColors.primaryDark),
                    onPressed:
                        state is DefaultServiceState && state.serviceName.isNotEmpty && state.moneyAmount.isNotEmpty
                            ? () => context.read<ServiceBloc>().add(
                                  ServiceEventApply(),
                                )
                            : null,
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _handleEvents(BuildContext context, ServiceState state) {
    if (state is DefaultServiceState) {
      if (_serviceNameController.text != state.serviceName) {
        _serviceNameController.text = state.serviceName;
      }
      if (_moneyAmountController.text != state.moneyAmount) {
        _moneyAmountController.text = state.moneyAmount;
      }
    }

    if (state is ServiceStateError) {
      showErrorDialog(context, state.error);
    }

    if (state is ServiceStateSuccess) {
      Navigator.of(context).pop();
    }
  }
}
