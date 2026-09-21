import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/form/create/ad/ad_create_form_cubit.dart';
import 'package:megaladon/logic/form/update/ad/ad_update_form_cubit.dart';

void main() {
  // AuthBloc в конструкторе подписывается на ApiService.auth.
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    dotenv.testLoad(mergeWith: {'BASE_URL': 'https://example.test/api'});
    ApiService.initialize();
  });

  final city = CityModel(id: 1, name: 'Алматы');
  final category = AdvertCategoryModel(id: 2, name: 'Токарные работы');

  bool checkCreate({required int? price, String title = 'Токарные работы'}) =>
      AdCreateFormCubit(AuthBloc()).checkCreate(
        title: title,
        description: 'Описание',
        price: price,
        city: city,
        category: category,
        phone: '',
        media: const [],
        type: AdvertType.service,
      );

  bool checkUpdate({required int? price}) =>
      AdUpdateFormCubit(AuthBloc()).checkUpdate(
        title: 'Токарные работы',
        description: 'Описание',
        price: price,
        city: city,
        category: category,
        phone: '',
        media: const [],
        type: AdvertType.advert,
      );

  test('создание объявления проходит без цены', () {
    expect(checkCreate(price: null), isTrue);
  });

  test('создание объявления проходит с ценой', () {
    expect(checkCreate(price: 20000), isTrue);
  });

  test('остальные поля остаются обязательными', () {
    expect(checkCreate(price: null, title: ''), isFalse);
  });

  test('редактирование объявления проходит без цены', () {
    expect(checkUpdate(price: null), isTrue);
  });
}
