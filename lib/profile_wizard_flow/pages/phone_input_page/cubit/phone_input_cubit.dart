import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'phone_input_state.dart';

class PhoneInputCubit extends Cubit<PhoneInputState> {
  PhoneInputCubit() : super(PhoneInputInitial());
}
