import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/repository/app_user_repository.dart';

abstract class BaseWizardCubit<T> extends Cubit<T> {
  final AppUserRepository appUserRepository;

  BaseWizardCubit(T initialState, this.appUserRepository) : super(initialState);

  Future<void> loadData();

  Future<void> postData();
}