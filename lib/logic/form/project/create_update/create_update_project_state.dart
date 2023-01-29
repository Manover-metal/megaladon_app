part of 'create_update_project_cubit.dart';

class CreateUpdateProjectState extends Equatable {
  final FormzStatus status;
  final TitleFormModel title;
  final DescriptionFormModel description;

  const CreateUpdateProjectState({
    this.title = const TitleFormModel.dirty(''),
    this.description = const DescriptionFormModel.dirty(''),
    this.status = FormzStatus.invalid
  });


  CreateUpdateProjectState copyWith({
    FormzStatus? status,
    TitleFormModel? title,
    DescriptionFormModel? description,
  }) {
    return CreateUpdateProjectState(
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [title, description, status];
}