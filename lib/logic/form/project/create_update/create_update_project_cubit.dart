import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/description.dart';
import 'package:megaladon/data/models/form/title.dart';

part 'create_update_project_state.dart';

class CreateUpdateProjectCubit extends Cubit<CreateUpdateProjectState> {
  CreateUpdateProjectCubit() : super(const CreateUpdateProjectState());

  initialize(titleData, descriptionData) {
    TitleFormModel title = TitleFormModel.dirty(titleData);
    DescriptionFormModel description = DescriptionFormModel.dirty(descriptionData);

    emit(state.copyWith(
        title: title,
        description: description,

        status: Formz.validate([title, description])
    ));
  }

  onChangeTitle(value) {
    TitleFormModel title = TitleFormModel.dirty(value);
    emit(state.copyWith(
        title: title,
        status: Formz.validate([title])
    ));
  }

  onChangeDescription(value) {
    DescriptionFormModel description = DescriptionFormModel.dirty(value);
    emit(state.copyWith(
        description: description,
        status: Formz.validate([description])
    ));
  }


  CreateUpdateProjectState checkAll() {
    CreateUpdateProjectState newState = state.copyWith(
        status: Formz.validate([
          state.title,
          state.description,
        ])
    );
    emit(newState);
    return newState;
  }
}
