part of 'price_form_cubit.dart';

class PriceFormState extends Equatable {
  const PriceFormState({this.prices = const [], this.error});
  final List<FileModel> prices;
  final ErrorModel? error;

  @override
  List<Object?> get props => [prices, error];

  PriceFormState copyWith({List<FileModel>? prices, ErrorModel? error}) =>
      PriceFormState(prices: prices ?? this.prices, error: error ?? this.error);
}
