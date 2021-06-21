part of 'start_profile_wizard_cubit.dart';

@immutable
abstract class ProfileWizardState {
  const ProfileWizardState();
}

class ProfileWizardInitial extends ProfileWizardState {
 const ProfileWizardInitial();

}


class ProfileWizardLoading extends ProfileWizardState {
  const ProfileWizardLoading();
}

class ProfileWizardLoaded extends ProfileWizardState {
  final Profile profile;
  const ProfileWizardLoaded(this.profile);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ProfileWizardLoaded && o.profile == profile;
  }

  @override
  int get hashCode => profile.hashCode;
}

class ProfileWizardError extends ProfileWizardState {
  final String message;
  const ProfileWizardError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ProfileWizardError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}


