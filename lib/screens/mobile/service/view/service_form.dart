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
                if (state is DefaultServiceState && state.isEditMode)
                  SizedBox(
                    width: double.infinity,
                    height: Dimens.spanSmallerGiant,
                    child: ElevatedButton(
                      child: Text('delete', style: AppTextStyles.bodyText1),
                      style: ElevatedButton.styleFrom(primary: AppColors.primaryDark),
                      onPressed: () => _deleteService(context),
                    ),
                  ),
                if (state is DefaultServiceState && state.photo != null)
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.file(state.photo!),
                  ),
                if (state is DefaultServiceState && state.photo != null && !state.isEditMode)
                  SizedBox(
                    width: double.infinity,
                    height: Dimens.spanSmallerGiant,
                    child: ElevatedButton(
                      child: Text('remove photo', style: AppTextStyles.bodyText1),
                      style: ElevatedButton.styleFrom(primary: AppColors.primaryDark),
                      onPressed: () => context.read<ServiceBloc>().add(
                            ServiceEventRemovePhoto(),
                          ),
                    ),
                  ),
                if (state is DefaultServiceState && state.photo == null && !state.isEditMode)
                  SizedBox(
                    width: double.infinity,
                    height: Dimens.spanSmallerGiant,
                    child: ElevatedButton(
                      child: Text('Photo', style: AppTextStyles.bodyText1),
                      style: ElevatedButton.styleFrom(primary: AppColors.primaryDark),
                      onPressed: () => context.read<ServiceBloc>().add(
                            ServiceEventTakePhoto(),
                          ),
                    ),
                  ),
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
                    child: Text('Записать', style: AppTextStyles.bodyText1),
                    style: ElevatedButton.styleFrom(primary: AppColors.primaryDark),
                    onPressed:
                        state is DefaultServiceState && state.serviceName.isNotEmpty && state.moneyAmount.isNotEmpty
                            ? () => _save(context, state)
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
      Navigator.of(context).pop();
      print(state.error);
    }

    if (state is ServiceStateSuccess) {
      Navigator.of(context).pop();
    }
  }

  void _save(BuildContext context, DefaultServiceState state) {
    if (state.isEditMode || state.photo != null) {
      context.read<ServiceBloc>().add(
            ServiceEventApply(),
          );
    } else {
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                title: new Text('Фотография не была добавленна'),
                content: new Text('Вы уверены что не хотите добавить фото?\nВы не спожете сделать это позже!'),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      child: Text('Добваить'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.read<ServiceBloc>().add(
                              ServiceEventTakePhoto(),
                            );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      child: Text('Отправить без фото'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.read<ServiceBloc>().add(
                              ServiceEventApply(),
                            );
                      },
                    ),
                  ),
                ],
              ));
    }
  }

  void _deleteService(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text('Удалить услугу'),
              content: new Text('Вы уверены что хотите удалить эту услугу? Вы не сможете добавить ее обратно!'),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: Text(
                      'Удалить',
                      style: TextStyle(color: AppColors.redTart),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<ServiceBloc>().add(
                            ServiceEventDelete(),
                          );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: Text('Нет'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ));
  }
}
