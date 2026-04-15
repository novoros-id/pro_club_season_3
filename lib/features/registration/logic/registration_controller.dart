import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationState {
  final String name;
  final bool isSaving;
  const RegistrationState({this.name = '', this.isSaving = false});
  RegistrationState copyWith({String? name, bool? isSaving}) =>
      RegistrationState(name: name ?? this.name, isSaving: isSaving ?? this.isSaving);
}

final registrationControllerProvider = NotifierProvider<RegistrationController, RegistrationState>(RegistrationController.new);

class RegistrationController extends Notifier<RegistrationState> {
  @override
  RegistrationState build() => const RegistrationState();

  void setName(String value) => state = state.copyWith(name: value);
  Future<void> submit() async {
    state = state.copyWith(isSaving: true);
    await Future.delayed(const Duration(milliseconds: 500)); // заглушка
    state = state.copyWith(isSaving: false);
  }
}