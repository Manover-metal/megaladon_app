part of 'price_form_cubit.dart';

class PriceFormState extends Equatable{
  final List<FileModel> prices;
  final ErrorModel? error;

  const PriceFormState({
    this.prices = const [],
    this.error
  });

  @override
  List<Object?> get props => [prices, error];

  PriceFormState copyWith({
    List<FileModel>? prices,
    ErrorModel? error
  }) {
    return PriceFormState(
      prices: prices ?? this.prices,
      error: error ?? this.error
    );
  }
}

