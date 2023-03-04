import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_offer_form_state.dart';

class CreateOfferFormCubit extends Cubit<CreateOfferFormState> {
  CreateOfferFormCubit() : super(CreateOfferFormInitial());
}
