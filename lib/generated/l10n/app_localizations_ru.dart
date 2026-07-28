// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get pushNotificationsTitle => 'Пуш-уведомления';

  @override
  String get pushNotificationsOn => 'Уведомления включены';

  @override
  String get pushNotificationsOff => 'Уведомления отключены';

  @override
  String get pushNotificationsLoading => 'Загрузка…';

  @override
  String get pushNotificationsLoadError => 'Не удалось загрузить статус';

  @override
  String get retry => 'Повторить';

  @override
  String get main_screen => 'Главная';

  @override
  String get element => 'Элемент';

  @override
  String get project => 'Проект';

  @override
  String get product => 'Продукт';

  @override
  String get category => 'Категория';

  @override
  String get create => 'Создать';

  @override
  String get update => 'Изменить';

  @override
  String get add_title => 'Добавить';

  @override
  String get create_title => 'Cоздать';

  @override
  String get name_field => 'Название';

  @override
  String get description_field => 'Описание';

  @override
  String get type => 'Тип';

  @override
  String get edit => 'Изменить';

  @override
  String get delete => 'Удалить';

  @override
  String get copy => 'Копировать';

  @override
  String get cut => 'Вставить';

  @override
  String get orders => 'Заказы';

  @override
  String get theshops => 'Металлопрокат';

  @override
  String get all => 'Все';

  @override
  String get active => 'Активные';

  @override
  String get moderate => 'На проверке';

  @override
  String get completed => 'Выполнен';

  @override
  String get status => 'Статус';

  @override
  String get in_rocessing => 'В обработке';

  @override
  String get in_work => 'В работе';

  @override
  String get archive => 'Архив ';

  @override
  String get field_of_activity => 'Сфера деятельности';

  @override
  String get rating => 'Рейтинг ';

  @override
  String get noRatings => 'Нет оценок';

  @override
  String get comment_optional => 'Комментарий (необязательно)';

  @override
  String get location => 'Местоположение';

  @override
  String get create_an_order => 'Создание заказа';

  @override
  String get select_a_category => 'Выберите категорию';

  @override
  String get job_title => 'Название работы';

  @override
  String get description_of_work => 'Описание работы';

  @override
  String get choose_city => 'Выберите город';

  @override
  String get city_selection_title => 'Выбор города';

  @override
  String get company_type_selection_title => 'Выбор типа';

  @override
  String get search => 'Поиск';

  @override
  String get desired_budget => 'Желаемый бюджет (не обязательно)';

  @override
  String get execution_days_label => 'Срок исполнения в днях';

  @override
  String get form_error_execution_days_empty =>
      'Укажите срок исполнения в днях';

  @override
  String get allowed_budget => 'Допустимый бюджет (не обязательно)';

  @override
  String get attach_files => 'Прикрепить файлы:';

  @override
  String get add_file => 'Добавить файл';

  @override
  String get create_order => 'Создать заказ';

  @override
  String get cancel => 'Отмена';

  @override
  String get creating_an_ad => 'Создание объявления';

  @override
  String get headline => 'Заголовок объявления';

  @override
  String get description_of_your_offer => 'Описание вашего предложения';

  @override
  String get price => 'Цена';

  @override
  String get create_ad => 'Создать объявление';

  @override
  String get name => 'Имя';

  @override
  String get telephone => 'Телефон';

  @override
  String get artist_data => 'Данные исполнителя';

  @override
  String get organization => 'Название организации';

  @override
  String get address => 'Адрес';

  @override
  String get services => 'Услуги';

  @override
  String get service => 'Услуга';

  @override
  String get subscription => 'Подписка';

  @override
  String get subscriptions => 'Подписки';

  @override
  String get store_data => 'Данные металопроката';

  @override
  String get description => 'Описание';

  @override
  String get email => 'Email';

  @override
  String get website => 'Сайт';

  @override
  String get price_lists => 'Прайс-листы';

  @override
  String get authorization => 'Авторизация';

  @override
  String get your_phone_number => 'Ваш телефон';

  @override
  String get your_password => 'Ваш пароль';

  @override
  String get forgot_your_password => 'Забыли пароль?';

  @override
  String get sign_in => 'Войти';

  @override
  String you_need_to_log_into_the_application(String suffix) {
    return 'Вам нужно авторизоваться в приложение$suffix';
  }

  @override
  String get registration => 'Регистрация';

  @override
  String get continueAction => 'Продолжить';

  @override
  String get for_this_request_ended => ' по данному запросу закончились';

  @override
  String get what_is_your_name => 'Как вас зовут';

  @override
  String get choose_password => 'Выберите пароль';

  @override
  String get confirm_the_password => 'Подтвердите пароль';

  @override
  String get register => 'Зарегистрироваться';

  @override
  String get registerAsExecutor => 'Зарегистрируйтесь как Исполнитель';

  @override
  String get ad => 'Объявление';

  @override
  String get no_attached_files => 'Нет прикреплённых файлов';

  @override
  String get attached_files => 'Прикреплённые файлы';

  @override
  String get price_up_to => 'Цена: до';

  @override
  String priceUpToAmount(String amount) {
    return 'Цена: до $amount ₸';
  }

  @override
  String priceAmount(String amount) {
    return '$amount ₸';
  }

  @override
  String get call => 'Позвонить';

  @override
  String get ask_a_question_in_the_chat => 'Задать вопрос в чате';

  @override
  String get chat_companion_deleted => 'Пользователь удалил аккаунт';

  @override
  String get my_announcement => 'Мои объявления';

  @override
  String get my_executor => 'Мои исполнители';

  @override
  String get ads => 'Объявления';

  @override
  String get marketplace => 'Торговая площадка';

  @override
  String get artist_registration => 'Регистрация исполнителя';

  @override
  String get bIN => 'БИН/ИИН';

  @override
  String get full_address => 'Полный адрес';

  @override
  String get latitude => 'Широта';

  @override
  String get longitude => 'Долгота';

  @override
  String get by_clicking_on_the_Continue_button_you_accept =>
      'Нажимая на кнопку \'Продолжить\', вы принимаете ';

  @override
  String get user_Agreement_Terms => 'Условия пользовательского соглашения';

  @override
  String get privacy_policy => 'Политика конфиденциальности';

  @override
  String get user_agreement => 'Пользовательское соглашение';

  @override
  String get shop_registration => 'Регистрация металопроката';

  @override
  String get names => 'Названия';

  @override
  String get type_of_business => 'Тип бизнеса';

  @override
  String get city => 'Город';

  @override
  String get password_recovery => 'Восстановление пароля';

  @override
  String get send_password => 'Отправить пароль';

  @override
  String get change_password => 'Изменить пароль';

  @override
  String get enter_6digit_code_from_SMS => 'Введите 6-ти значный код из смс';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get send_code_again => 'Выслать код повторно';

  @override
  String get code_sent_again => 'Код отправлен повторно';

  @override
  String get send_the_code => 'Отправить код';

  @override
  String get reset_password => 'Сменить пароль';

  @override
  String get chat => 'Чат';

  @override
  String get noMessagesInChat => 'Пока что сообщений в этом чате нет';

  @override
  String get chats => 'Чаты';

  @override
  String get executor => 'Исполнитель: ';

  @override
  String get additional_Phone => 'Дополнительный телефон';

  @override
  String get edit_ad => 'Изменить объявление';

  @override
  String get editService => 'Изменить услугу';

  @override
  String get response_to_order => 'Отклик на заказ №';

  @override
  String responseToOrderId(String id) {
    return 'Отклик на заказ №$id';
  }

  @override
  String get responseSent => 'Отклик отправлен';

  @override
  String get actual_until => 'Актуален до';

  @override
  String get time_to_work => 'Время на работу';

  @override
  String get respond => 'Откликнуться';

  @override
  String get header => 'Заголовок';

  @override
  String get change_order => 'Изменить заказ';

  @override
  String get artists_suggestion => 'Предложение';

  @override
  String get price2 => 'Цена: ';

  @override
  String get terms => 'Сроки: ';

  @override
  String get createChat => 'Создать чат';

  @override
  String get location2 => 'Местоположение: ';

  @override
  String get description2 => 'Описание: ';

  @override
  String get executorAddedToFavorites => 'Исполнитель добавлен в избранное';

  @override
  String get executorSuggestedPrice => 'Предложенная исполнителем цена: ';

  @override
  String get executionDate => 'Дата исполнения: ';

  @override
  String cityName(String name) {
    return 'г. $name';
  }

  @override
  String get set_as_executor => 'Назначить исполнителем';

  @override
  String get order => 'Заказ №';

  @override
  String orderWithId(String id) {
    return 'Заказ №$id';
  }

  @override
  String get desired_budget_up_to => 'Желаемый бюджет: до ';

  @override
  String desiredBudgetUpToAmount(String amount) {
    return 'Желаемый бюджет: до $amount ₸';
  }

  @override
  String executionDaysValue(String days) {
    return 'Срок исполнения: $days дн.';
  }

  @override
  String get valid_to => 'Допустимый: до ';

  @override
  String validToAmount(String amount) {
    return 'Допустимый: до $amount ₸';
  }

  @override
  String get offer_services => 'Предложить услуги';

  @override
  String get discuss_in_chat => 'Обсудить в чате';

  @override
  String get offers => 'Предложений: ';

  @override
  String offersCount(String count) {
    return 'Предложений ($count новых)';
  }

  @override
  String offersWithCount(String count) {
    return 'Предложений: $count';
  }

  @override
  String get discuss_in_chat2 => 'Обсудить в чате (5 новых)';

  @override
  String get to_finish_work => 'Завершить работу';

  @override
  String get my_orders => 'Мои заказы';

  @override
  String get as_a_user => 'Как пользователя';

  @override
  String get as_a_executor => 'Как исполнителя';

  @override
  String get asAStore => 'Как магазина';

  @override
  String get feedback_on_order => 'Отзыв по заказу';

  @override
  String feedbackOnOrderId(String id) {
    return 'Отзыв по заказу №$id';
  }

  @override
  String get leave_feedback => 'Оставить отзыв';

  @override
  String get back => 'Назад';

  @override
  String get password_changed_successfully => 'Пароль успешно изменен';

  @override
  String get phone_number_changed_successfully =>
      'Номер телефона успешно изменен';

  @override
  String get change_phone_number => 'Изменить номер телефона';

  @override
  String get old_phone => 'Старый телефон';

  @override
  String get code => 'Код';

  @override
  String get new_phone => 'Новый телефон';

  @override
  String get submit_Code => 'Отправить код';

  @override
  String get rate => 'Оценить';

  @override
  String get send => 'Отправить';

  @override
  String get storeRated => 'Вы оценили магазин';

  @override
  String get profile => 'Профиль';

  @override
  String get add_price => 'Добавить прайс';

  @override
  String get settings => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String get theme => 'Тема';

  @override
  String get theme_dark => 'Тёмная';

  @override
  String get theme_light => 'Светлая';

  @override
  String get theme_system => 'Системная';

  @override
  String get about_the_application => 'О приложении';

  @override
  String get delete_account => 'Удалить аккаунт';

  @override
  String get delete_account_warning =>
      'Действие необратимо. Аккаунт будет удалён, и вы выйдете из него. Введите пароль для подтверждения.';

  @override
  String get account_deleted_successfully => 'Аккаунт удалён';

  @override
  String get aboutText =>
      '\"Заказы\" — список размещённых на платформе заказов для поиска лучшего предложения от исполнителей.\n\"Металлопрокат\" — список компаний, занимающихся продажей готовой продукции.\n\"+\" (Заказ) — создание заказа для поиска исполнителей.\n\"+\" (Услуги) — создание услуг для распространения своих услуг.\n\"+\" (Объявление) — создание объявления для продажи товаров или оказания услуг машиностроения.\n\"Торговая площадка\" — список объявлений о продаже товара или оказании услуг машиностроения.\n\"Профиль\" — профиль пользователя.';

  @override
  String get introOrders =>
      'Список размещённых на платформе заказов для поиска лучшего предложения от исполнителей.';

  @override
  String get introStores =>
      'Список компаний, занимающихся продажей готовой продукции.';

  @override
  String get introAds =>
      'Список объявлений о продаже товара или оказании услуг машиностроения.';

  @override
  String get introProfile => 'Профиль пользователя.';

  @override
  String get change_artist_details => 'Изменить данные исполнителя';

  @override
  String get rating2 => 'Рейтинг: ';

  @override
  String get filter => 'Фильтр';

  @override
  String get price_from => 'Цена от: ';

  @override
  String get price_to => 'До: ';

  @override
  String get from => 'От';

  @override
  String get to => 'До';

  @override
  String get last_period => 'За последний период';

  @override
  String get apply => 'Применить';

  @override
  String get order2 => 'Заказ';

  @override
  String get to_create_an_ad_or_order => ', чтобы создать объявление или заказ';

  @override
  String get more_details => 'Подробнее';

  @override
  String get exit => 'Выход';

  @override
  String get change_executor => 'Изменить исполнителя';

  @override
  String get change_store => 'Изменить металопрокат';

  @override
  String get add_contact => 'Добавить Контакт';

  @override
  String get add_image => 'Добавить изображение';

  @override
  String get add_service => 'Добавить категорию услуг';

  @override
  String get add_order_category => 'Добавить категорию заказа';

  @override
  String get select => 'Выбрать';

  @override
  String get contact_name => 'Имя контакта';

  @override
  String get posted_projects => 'Размещено проектов: ';

  @override
  String get customer2 => 'Заказчик: ';

  @override
  String get no_description => 'Нет описания';

  @override
  String get customer => 'Заказчик';

  @override
  String get select_category => 'Выберите категорию';

  @override
  String get select_city => 'Выберите город';

  @override
  String get add_at_least_one_contact => 'Добавьте минимум один контакт';

  @override
  String get contacts_are_not_fully_filled_out =>
      'Контакты не полностью заполнены';

  @override
  String get add_at_least_one_service => 'Добавьте минимум один услуга';

  @override
  String get category_is_not_filled_out => 'Категория не заполнена';

  @override
  String get type_is_not_specified => 'Тип не указан';

  @override
  String get bIN_is_not_filled => 'БИН/ИИН не заполнен';

  @override
  String get bIN_is_not_fully_filled => 'БИН/ИИН не полностью заполнен';

  @override
  String get bIN_maximum_12_digits => 'БИН/ИИН максимум 12 цифр';

  @override
  String get work_time_is_not_filled => 'Время на работу не заполнено';

  @override
  String get description_exceeds_1000_characters =>
      'Описание превысело 1000 символов';

  @override
  String get not_an_email => 'Не является Email-ом';

  @override
  String get email_is_empty => 'Email пустой';

  @override
  String get response_relevance_is_not_filled =>
      'Актуальность отклика не заполнена';

  @override
  String get latitude_not_filled => 'Широта не заполнен';

  @override
  String get latitude_cannot_be_less_than_90 =>
      'Широта не может быть меньше -90°';

  @override
  String get latitude_cannot_be_greater_than_90 =>
      'Широта не может быть больше +90°';

  @override
  String get longitude_is_not_filled => 'Долгота не заполнен';

  @override
  String get longitude_cannot_be_less_than_180 =>
      'Долгота не может быть меньше -180°';

  @override
  String get longitude_cannot_be_greater_than_180 =>
      'Долгота не может быть больше 180°';

  @override
  String get name_is_empty => 'Имя пустое';

  @override
  String get passwords_do_not_match => 'Пароли не совпадают';

  @override
  String get password_must_be_at_least_8_characters =>
      'Пароль должен состоять минимально из 8 символов';

  @override
  String get password_is_empty => 'Пароль пустой';

  @override
  String get phone_number_is_empty => 'Телефон пустой';

  @override
  String get code_is_empty => 'Код пустой';

  @override
  String get code_is_6_characters => 'Код из 6 символов';

  @override
  String get fill_in_the_price => 'Заполните Цену';

  @override
  String get header_is_empty => 'Заголовок пустой';

  @override
  String get days_3 => '3 дня';

  @override
  String get week => 'неделю';

  @override
  String get month => 'месяц';

  @override
  String get by_creation => 'По созданию';

  @override
  String get by_date => 'По дате';

  @override
  String get by_status => 'По статусу';

  @override
  String get by_category => 'По категории';

  @override
  String get mobile_phone => 'Мобильный телефон';

  @override
  String get home_phone => 'Домашний телефон';

  @override
  String get additional_data => 'Доп. данные';

  @override
  String get unknown_error => 'Неизвестная ошибка';

  @override
  String get the_number_of_orders => 'Количество заказов';

  @override
  String get city2 => 'Город: ';

  @override
  String get bIN2 => 'БИН/ИИН: ';

  @override
  String get no_price_list => 'Нет прайс листа';

  @override
  String get price_list => 'Прайс лист';

  @override
  String get write => 'Написать';

  @override
  String get sort => 'Сортировать';

  @override
  String get contact => 'Контакт';

  @override
  String get contacts => 'Контакты';

  @override
  String get failed_to_open_contact => 'Не удалось открыть контакт';

  @override
  String get artist2 => 'Иполнитель: ';

  @override
  String get address2 => 'Адрес: ';

  @override
  String get en => 'Английский';

  @override
  String get ru => 'Русский';

  @override
  String get kk => 'Казахский';

  @override
  String get add_to_Favorite => 'Добавить в избранное';

  @override
  String get creating_an_service => 'Создание услуги';

  @override
  String get create_service => 'Создать услугу';

  @override
  String get service_category => 'Категория услуг';

  @override
  String get order_category => 'Категория заказа';

  @override
  String get period => 'Период';

  @override
  String months_count(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString месяца',
      many: '$countString месяцев',
      few: '$countString месяца',
      one: '$countString месяц',
    );
    return '$_temp0';
  }

  @override
  String get activate_for_free => 'Активировать бесплатно';

  @override
  String get buy => 'Купить';

  @override
  String subscribed_for_months(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вы взяли подписку на $countString месяца',
      many: 'Вы взяли подписку на $countString месяцев',
      few: 'Вы взяли подписку на $countString месяца',
      one: 'Вы взяли подписку на $countString месяц',
    );
    return '$_temp0';
  }

  @override
  String tenge_price(String amount) {
    return '$amount ₸';
  }

  @override
  String get last_3_days => 'Последние 3 дня';

  @override
  String get last_week => 'Последняя неделя';

  @override
  String get last_month => 'Последний месяц';

  @override
  String get all_time => 'За всё время';

  @override
  String get form_error_bin_empty => 'БИН/ИИН не заполнен';

  @override
  String get form_error_bin_min => 'БИН/ИИН заполнен не полностью';

  @override
  String get form_error_bin_max => 'БИН/ИИН максимум 12 цифр';

  @override
  String get form_error_date_offer_empty => 'Время работы не заполнено';

  @override
  String get form_error_description_empty => 'Описание не заполнено';

  @override
  String get form_error_description_limit => 'Описание превышает 1000 символов';

  @override
  String get form_error_email_empty => 'Email не заполнен';

  @override
  String get form_error_email_invalid => 'Некорректный email';

  @override
  String get form_error_expired_at_empty => 'Актуальность отклика не заполнена';

  @override
  String get form_error_lat_empty => 'Широта не заполнена';

  @override
  String get form_error_lat_min => 'Широта не может быть меньше -90°';

  @override
  String get form_error_lat_max => 'Широта не может быть больше +90°';

  @override
  String get form_error_lon_empty => 'Долгота не заполнена';

  @override
  String get form_error_lon_min => 'Долгота не может быть меньше -180°';

  @override
  String get form_error_lon_max => 'Долгота не может быть больше 180°';

  @override
  String get form_error_name_empty => 'Имя не заполнено';

  @override
  String get form_error_password_empty => 'Пароль не заполнен';

  @override
  String get form_error_password_min =>
      'Пароль должен содержать минимум 8 символов';

  @override
  String get form_error_password_confirmation_not_match =>
      'Пароли не совпадают';

  @override
  String get form_error_phone_empty => 'Номер телефона не заполнен';

  @override
  String get form_error_pincode_empty => 'Код не заполнен';

  @override
  String get form_error_pincode_min => 'Код должен содержать 6 символов';

  @override
  String get form_error_price_empty => 'Заполните цену';

  @override
  String get form_error_title_empty => 'Заголовок не заполнен';

  @override
  String get form_error_city_empty => 'Выберите город';

  @override
  String get form_error_company_type_empty => 'Выберите тип';

  @override
  String get form_error_advert_category_empty => 'Выберите категорию';

  @override
  String get form_error_order_category_empty => 'Выберите категорию';

  @override
  String get form_error_services_empty => 'Добавьте хотя бы одну услугу';

  @override
  String get my_reviews => 'Мои отзывы';

  @override
  String get no_reviews_yet => 'Пока нет отзывов';

  @override
  String get reviews => 'Отзывы';

  @override
  String get store_reviews => 'Отзывы магазина';

  @override
  String get chat_unknown_companion => 'Неизвестный собеседник';

  @override
  String get file_open_error => 'Не удалось открыть файл';

  @override
  String get file => 'Файл';

  @override
  String get photo => 'Фото';

  @override
  String get camera => 'Камера';

  @override
  String get userProfileTitle => 'Профиль';

  @override
  String get userProfileNotFound => 'Пользователь не найден';

  @override
  String get userProfileTabAdverts => 'Объявления';

  @override
  String get userProfileTabServices => 'Услуги';

  @override
  String get userProfileTabOrders => 'Заказы';

  @override
  String get userProfileEmpty => 'Здесь пока пусто';

  @override
  String get userProfileRetry => 'Повторить';

  @override
  String get userProfileLoadError => 'Не удалось загрузить';

  @override
  String userProfileCompletedOrders(int count) {
    return 'Выполнено заказов: $count';
  }

  @override
  String userProfileMemberSince(String date) {
    return 'С нами с $date';
  }
}
