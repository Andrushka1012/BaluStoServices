import 'dart:io';

import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/screens/mobile/service/service/service_bloc.dart';
import 'package:balu_sto/widgets/app_card.dart';
import 'package:balu_sto/widgets/containers/progress_container.dart';
import 'package:balu_sto/widgets/inputs/text_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceForm extends StatelessWidget {
  final _serviceNameController = TextEditingController();
  final _moneyAmountController = TextEditingController();

  Widget _getPhotoItem(BuildContext context, File photo) => Padding(
        padding: EdgeInsets.only(bottom: Dimens.spanBig),
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: FileImage(photo),
              ),
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                padding: EdgeInsets.only(
                  bottom: Dimens.spanTiny,
                  right: Dimens.spanTiny,
                ),
                alignment: Alignment.bottomRight,
                icon: Icon(
                  Icons.delete,
                  color: AppColors.white,
                ),
                onPressed: () => context.read<ServiceBloc>().add(
                      ServiceEventRemovePhoto(),
                    ),
              ),
            ),
          ),
        ),
      );

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
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!kIsWeb && state is DefaultServiceState && state.photo != null) _getPhotoItem(context, state.photo!),
                  if (!kIsWeb && state is DefaultServiceState && state.photo == null && !state.isEditMode)
                    Padding(
                      padding: EdgeInsets.only(bottom: Dimens.spanBig),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                        child: IconButton(
                          icon: Icon(
                            Icons.camera,
                            color: AppColors.white,
                          ),
                          onPressed: () => context.read<ServiceBloc>().add(
                                ServiceEventTakePhoto(),
                              ),
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
                  SizedBox(
                    height: Dimens.spanSmall,
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
                    height: Dimens.spanSmall,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: Dimens.spanSmallerGiant,
                    child: ElevatedButton(
                      child: Text('Записать', style: AppTextStyles.bodyText1),
                      style: ElevatedButton.styleFrom(primary: AppColors.primary),
                      onPressed:
                          state is DefaultServiceState && state.serviceName.isNotEmpty && state.moneyAmount.isNotEmpty
                              ? () => _save(context, state)
                              : null,
                    ),
                  ),
                  if (state is DefaultServiceState && state.isEditMode)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: Dimens.spanSmall,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: Dimens.spanSmallerGiant,
                        child: ElevatedButton(
                          child: Text('Удалить', style: AppTextStyles.bodyText1),
                          style: ElevatedButton.styleFrom(primary: AppColors.redTart),
                          onPressed: () => _deleteService(context),
                        ),
                      ),
                    ),
                ],
              ),
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

  void _save(BuildContext context, DefaultServiceState state) {
    if (kIsWeb || state.isEditMode || state.photo != null) {
      context.read<ServiceBloc>().add(
            ServiceEventApply(),
          );
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                backgroundColor: AppColors.secondary,
                title: Text(
                  'Фотография не была добавлена!',
                  style: TextStyle(color: AppColors.white),
                ),
                content: Text(
                  'Вы уверены что не хотите добавить фото?\nВы не сможете сделать это позже!',
                  style: TextStyle(color: AppColors.white),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      child: Text(
                        'Добваить',
                        style: TextStyle(color: AppColors.white),
                      ),
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
                      child: Text(
                        'Отправить без фото',
                        style: TextStyle(color: AppColors.white),
                      ),
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
        builder: (_) => AlertDialog(
              title: Text(
                'Удалить услугу',
                style: TextStyle(color: AppColors.white),
              ),
              backgroundColor: AppColors.secondary,
              content: Text(
                'Вы уверены что хотите удалить эту услугу? Вы не сможете добавить ее обратно!',
                style: TextStyle(color: AppColors.white),
              ),
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
                    child: Text(
                      'Нет',
                      style: TextStyle(color: AppColors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ));
  }
}
