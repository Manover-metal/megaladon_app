import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kk'),
    Locale('ru')
  ];

  /// No description provided for @main_screen.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get main_screen;

  /// No description provided for @element.
  ///
  /// In en, this message translates to:
  /// **'Element'**
  String get element;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @add_title.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add_title;

  /// No description provided for @create_title.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create_title;

  /// No description provided for @name_field.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name_field;

  /// No description provided for @description_field.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description_field;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @cut.
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get cut;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @theshops.
  ///
  /// In en, this message translates to:
  /// **'Rolled metal'**
  String get theshops;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @in_rocessing.
  ///
  /// In en, this message translates to:
  /// **'In rocessing'**
  String get in_rocessing;

  /// No description provided for @in_work.
  ///
  /// In en, this message translates to:
  /// **'In work'**
  String get in_work;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @field_of_activity.
  ///
  /// In en, this message translates to:
  /// **'Field of activity'**
  String get field_of_activity;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating '**
  String get rating;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @create_an_order.
  ///
  /// In en, this message translates to:
  /// **'Create an order'**
  String get create_an_order;

  /// No description provided for @select_a_category.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get select_a_category;

  /// No description provided for @job_title.
  ///
  /// In en, this message translates to:
  /// **'Job title'**
  String get job_title;

  /// No description provided for @description_of_work.
  ///
  /// In en, this message translates to:
  /// **'Description of work'**
  String get description_of_work;

  /// No description provided for @choose_city.
  ///
  /// In en, this message translates to:
  /// **'Choose city'**
  String get choose_city;

  /// No description provided for @desired_budget.
  ///
  /// In en, this message translates to:
  /// **'Desired budget (optional)'**
  String get desired_budget;

  /// No description provided for @allowed_budget.
  ///
  /// In en, this message translates to:
  /// **'Allowed budget (optional)'**
  String get allowed_budget;

  /// No description provided for @attach_files.
  ///
  /// In en, this message translates to:
  /// **'Attach files'**
  String get attach_files;

  /// No description provided for @add_file.
  ///
  /// In en, this message translates to:
  /// **'Add file'**
  String get add_file;

  /// No description provided for @create_order.
  ///
  /// In en, this message translates to:
  /// **'Create order'**
  String get create_order;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @creating_an_ad.
  ///
  /// In en, this message translates to:
  /// **'Creating an ad'**
  String get creating_an_ad;

  /// No description provided for @headline.
  ///
  /// In en, this message translates to:
  /// **'Headline'**
  String get headline;

  /// No description provided for @description_of_your_offer.
  ///
  /// In en, this message translates to:
  /// **'Description of your offer'**
  String get description_of_your_offer;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @create_ad.
  ///
  /// In en, this message translates to:
  /// **'Create ad'**
  String get create_ad;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @telephone.
  ///
  /// In en, this message translates to:
  /// **'Telephone'**
  String get telephone;

  /// No description provided for @artist_data.
  ///
  /// In en, this message translates to:
  /// **'Artist data'**
  String get artist_data;

  /// No description provided for @organization.
  ///
  /// In en, this message translates to:
  /// **'Name organization'**
  String get organization;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @store_data.
  ///
  /// In en, this message translates to:
  /// **'Store data'**
  String get store_data;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @price_lists.
  ///
  /// In en, this message translates to:
  /// **'Price lists'**
  String get price_lists;

  /// No description provided for @authorization.
  ///
  /// In en, this message translates to:
  /// **'Authorization'**
  String get authorization;

  /// No description provided for @your_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Your phone number'**
  String get your_phone_number;

  /// No description provided for @your_password.
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get your_password;

  /// No description provided for @forgot_your_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password ?'**
  String get forgot_your_password;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get sign_in;

  /// No description provided for @you_need_to_log_into_the_application.
  ///
  /// In en, this message translates to:
  /// **'You need to log into the application{suffix}'**
  String you_need_to_log_into_the_application(String suffix);

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @for_this_request_ended.
  ///
  /// In en, this message translates to:
  /// **' for this request ended'**
  String get for_this_request_ended;

  /// No description provided for @what_is_your_name.
  ///
  /// In en, this message translates to:
  /// **'What is your name'**
  String get what_is_your_name;

  /// No description provided for @choose_password.
  ///
  /// In en, this message translates to:
  /// **'Choose password'**
  String get choose_password;

  /// No description provided for @confirm_the_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm the password'**
  String get confirm_the_password;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @registerAsExecutor.
  ///
  /// In en, this message translates to:
  /// **'Register as Executor'**
  String get registerAsExecutor;

  /// No description provided for @ad.
  ///
  /// In en, this message translates to:
  /// **'Ad'**
  String get ad;

  /// No description provided for @no_attached_files.
  ///
  /// In en, this message translates to:
  /// **'No attached files'**
  String get no_attached_files;

  /// No description provided for @attached_files.
  ///
  /// In en, this message translates to:
  /// **'Attached files'**
  String get attached_files;

  /// No description provided for @price_up_to.
  ///
  /// In en, this message translates to:
  /// **'Price: up to '**
  String get price_up_to;

  /// No description provided for @priceUpToAmount.
  ///
  /// In en, this message translates to:
  /// **'Price: up to {amount} ₸'**
  String priceUpToAmount(String amount);

  /// No description provided for @priceAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} ₸'**
  String priceAmount(String amount);

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @ask_a_question_in_the_chat.
  ///
  /// In en, this message translates to:
  /// **'Ask a question in the chat'**
  String get ask_a_question_in_the_chat;

  /// No description provided for @my_announcement.
  ///
  /// In en, this message translates to:
  /// **'My announcements'**
  String get my_announcement;

  /// No description provided for @ads.
  ///
  /// In en, this message translates to:
  /// **'Ads'**
  String get ads;

  /// No description provided for @marketplace.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get marketplace;

  /// No description provided for @artist_registration.
  ///
  /// In en, this message translates to:
  /// **'Artist registration'**
  String get artist_registration;

  /// No description provided for @bIN.
  ///
  /// In en, this message translates to:
  /// **'BIN/IIN'**
  String get bIN;

  /// No description provided for @full_address.
  ///
  /// In en, this message translates to:
  /// **'Full address'**
  String get full_address;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @by_clicking_on_the_Continue_button_you_accept.
  ///
  /// In en, this message translates to:
  /// **'By clicking on the \'Continue\' button you accept '**
  String get by_clicking_on_the_Continue_button_you_accept;

  /// No description provided for @user_Agreement_Terms.
  ///
  /// In en, this message translates to:
  /// **'user agreement terms'**
  String get user_Agreement_Terms;

  /// No description provided for @shop_registration.
  ///
  /// In en, this message translates to:
  /// **'Shop registration'**
  String get shop_registration;

  /// No description provided for @names.
  ///
  /// In en, this message translates to:
  /// **'Names'**
  String get names;

  /// No description provided for @type_of_business.
  ///
  /// In en, this message translates to:
  /// **'Type of business'**
  String get type_of_business;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @password_recovery.
  ///
  /// In en, this message translates to:
  /// **'Password recovery'**
  String get password_recovery;

  /// No description provided for @send_password.
  ///
  /// In en, this message translates to:
  /// **'Send password'**
  String get send_password;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get change_password;

  /// No description provided for @enter_6digit_code_from_SMS.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit code from SMS'**
  String get enter_6digit_code_from_SMS;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @send_code_again.
  ///
  /// In en, this message translates to:
  /// **'Send code again'**
  String get send_code_again;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @noMessagesInChat.
  ///
  /// In en, this message translates to:
  /// **'No messages in this chat yet'**
  String get noMessagesInChat;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @executor.
  ///
  /// In en, this message translates to:
  /// **'Executor: '**
  String get executor;

  /// No description provided for @additional_Phone.
  ///
  /// In en, this message translates to:
  /// **'Additional phone'**
  String get additional_Phone;

  /// No description provided for @edit_ad.
  ///
  /// In en, this message translates to:
  /// **'Edit ad'**
  String get edit_ad;

  /// No description provided for @editService.
  ///
  /// In en, this message translates to:
  /// **'Edit service'**
  String get editService;

  /// No description provided for @response_to_order.
  ///
  /// In en, this message translates to:
  /// **'Response to order №'**
  String get response_to_order;

  /// No description provided for @responseToOrderId.
  ///
  /// In en, this message translates to:
  /// **'Response to order №{id}'**
  String responseToOrderId(String id);

  /// No description provided for @responseSent.
  ///
  /// In en, this message translates to:
  /// **'Response sent'**
  String get responseSent;

  /// No description provided for @actual_until.
  ///
  /// In en, this message translates to:
  /// **'Actual until'**
  String get actual_until;

  /// No description provided for @time_to_work.
  ///
  /// In en, this message translates to:
  /// **'Time to work'**
  String get time_to_work;

  /// No description provided for @respond.
  ///
  /// In en, this message translates to:
  /// **'Respond'**
  String get respond;

  /// No description provided for @header.
  ///
  /// In en, this message translates to:
  /// **'Header'**
  String get header;

  /// No description provided for @change_order.
  ///
  /// In en, this message translates to:
  /// **'Change order'**
  String get change_order;

  /// No description provided for @artists_suggestion.
  ///
  /// In en, this message translates to:
  /// **'Artists suggestion'**
  String get artists_suggestion;

  /// No description provided for @price2.
  ///
  /// In en, this message translates to:
  /// **'Price: '**
  String get price2;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms: '**
  String get terms;

  /// No description provided for @createChat.
  ///
  /// In en, this message translates to:
  /// **'Create chat'**
  String get createChat;

  /// No description provided for @location2.
  ///
  /// In en, this message translates to:
  /// **'Location: '**
  String get location2;

  /// No description provided for @description2.
  ///
  /// In en, this message translates to:
  /// **'Description: '**
  String get description2;

  /// No description provided for @executorAddedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Executor added to favorites'**
  String get executorAddedToFavorites;

  /// No description provided for @executorSuggestedPrice.
  ///
  /// In en, this message translates to:
  /// **'Executor\'s suggested price: '**
  String get executorSuggestedPrice;

  /// No description provided for @executionDate.
  ///
  /// In en, this message translates to:
  /// **'Execution date: '**
  String get executionDate;

  /// No description provided for @cityName.
  ///
  /// In en, this message translates to:
  /// **'city {name}'**
  String cityName(String name);

  /// No description provided for @set_as_executor.
  ///
  /// In en, this message translates to:
  /// **'Set as executor'**
  String get set_as_executor;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order №'**
  String get order;

  /// No description provided for @orderWithId.
  ///
  /// In en, this message translates to:
  /// **'Order №{id}'**
  String orderWithId(String id);

  /// No description provided for @desired_budget_up_to.
  ///
  /// In en, this message translates to:
  /// **'Desired budget: up to '**
  String get desired_budget_up_to;

  /// No description provided for @desiredBudgetUpToAmount.
  ///
  /// In en, this message translates to:
  /// **'Desired budget: up to {amount} ₸'**
  String desiredBudgetUpToAmount(String amount);

  /// No description provided for @valid_to.
  ///
  /// In en, this message translates to:
  /// **'Valid to: '**
  String get valid_to;

  /// No description provided for @validToAmount.
  ///
  /// In en, this message translates to:
  /// **'Valid to: {amount} ₸'**
  String validToAmount(String amount);

  /// No description provided for @offer_services.
  ///
  /// In en, this message translates to:
  /// **'Offer services'**
  String get offer_services;

  /// No description provided for @discuss_in_chat.
  ///
  /// In en, this message translates to:
  /// **'Discuss in chat'**
  String get discuss_in_chat;

  /// No description provided for @offers.
  ///
  /// In en, this message translates to:
  /// **'Offers: '**
  String get offers;

  /// No description provided for @offersCount.
  ///
  /// In en, this message translates to:
  /// **'Offers ({count} new)'**
  String offersCount(String count);

  /// No description provided for @offersWithCount.
  ///
  /// In en, this message translates to:
  /// **'Offers: {count}'**
  String offersWithCount(String count);

  /// No description provided for @discuss_in_chat2.
  ///
  /// In en, this message translates to:
  /// **'Discuss in chat (5 new)'**
  String get discuss_in_chat2;

  /// No description provided for @to_finish_work.
  ///
  /// In en, this message translates to:
  /// **'To finish work'**
  String get to_finish_work;

  /// No description provided for @my_orders.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get my_orders;

  /// No description provided for @as_a_user.
  ///
  /// In en, this message translates to:
  /// **'As a user'**
  String get as_a_user;

  /// No description provided for @as_a_executor.
  ///
  /// In en, this message translates to:
  /// **'As an executor'**
  String get as_a_executor;

  /// No description provided for @asAStore.
  ///
  /// In en, this message translates to:
  /// **'As a store'**
  String get asAStore;

  /// No description provided for @feedback_on_order.
  ///
  /// In en, this message translates to:
  /// **'Feedback on order'**
  String get feedback_on_order;

  /// No description provided for @feedbackOnOrderId.
  ///
  /// In en, this message translates to:
  /// **'Feedback on order №{id}'**
  String feedbackOnOrderId(String id);

  /// No description provided for @leave_feedback.
  ///
  /// In en, this message translates to:
  /// **'Leave feedback'**
  String get leave_feedback;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @password_changed_successfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get password_changed_successfully;

  /// No description provided for @phone_number_changed_successfully.
  ///
  /// In en, this message translates to:
  /// **'Phone number changed successfully'**
  String get phone_number_changed_successfully;

  /// No description provided for @change_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Change phone number'**
  String get change_phone_number;

  /// No description provided for @old_phone.
  ///
  /// In en, this message translates to:
  /// **'Old phone'**
  String get old_phone;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @new_phone.
  ///
  /// In en, this message translates to:
  /// **'New phone'**
  String get new_phone;

  /// No description provided for @submit_Code.
  ///
  /// In en, this message translates to:
  /// **'Submit code'**
  String get submit_Code;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @storeRated.
  ///
  /// In en, this message translates to:
  /// **'You rated the store'**
  String get storeRated;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @add_price.
  ///
  /// In en, this message translates to:
  /// **'Add price'**
  String get add_price;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @about_the_application.
  ///
  /// In en, this message translates to:
  /// **'About the application'**
  String get about_the_application;

  /// No description provided for @aboutText.
  ///
  /// In en, this message translates to:
  /// **'\"Orders\" — a list of orders placed on the platform to find the best offer from executors.\n\"Rolled metal\" — a list of companies selling finished products.\n\"+\" (Order) — create an order to find executors.\n\"+\" (Services) — create services to promote your offerings.\n\"+\" (Ad) — create an ad to sell goods or provide mechanical engineering services.\n\"Marketplace\" — a list of ads for selling goods or providing mechanical engineering services.\n\"Profile\" — user profile.'**
  String get aboutText;

  /// No description provided for @introOrders.
  ///
  /// In en, this message translates to:
  /// **'A list of orders placed on the platform to find the best offer from executors.'**
  String get introOrders;

  /// No description provided for @introStores.
  ///
  /// In en, this message translates to:
  /// **'A list of companies selling finished products.'**
  String get introStores;

  /// No description provided for @introAds.
  ///
  /// In en, this message translates to:
  /// **'A list of ads for selling goods or providing mechanical engineering services.'**
  String get introAds;

  /// No description provided for @introProfile.
  ///
  /// In en, this message translates to:
  /// **'User profile.'**
  String get introProfile;

  /// No description provided for @change_artist_details.
  ///
  /// In en, this message translates to:
  /// **'Change artist details'**
  String get change_artist_details;

  /// No description provided for @rating2.
  ///
  /// In en, this message translates to:
  /// **'Rating: '**
  String get rating2;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @price_from.
  ///
  /// In en, this message translates to:
  /// **'Price from: '**
  String get price_from;

  /// No description provided for @price_to.
  ///
  /// In en, this message translates to:
  /// **'To: '**
  String get price_to;

  /// No description provided for @last_period.
  ///
  /// In en, this message translates to:
  /// **'For the last period'**
  String get last_period;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @order2.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order2;

  /// No description provided for @to_create_an_ad_or_order.
  ///
  /// In en, this message translates to:
  /// **' to create an ad or order'**
  String get to_create_an_ad_or_order;

  /// No description provided for @more_details.
  ///
  /// In en, this message translates to:
  /// **'More details'**
  String get more_details;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @change_executor.
  ///
  /// In en, this message translates to:
  /// **'Change executor'**
  String get change_executor;

  /// No description provided for @change_store.
  ///
  /// In en, this message translates to:
  /// **'Change store'**
  String get change_store;

  /// No description provided for @add_contact.
  ///
  /// In en, this message translates to:
  /// **'Add contact'**
  String get add_contact;

  /// No description provided for @add_image.
  ///
  /// In en, this message translates to:
  /// **'Add image'**
  String get add_image;

  /// No description provided for @add_service.
  ///
  /// In en, this message translates to:
  /// **'Add category service'**
  String get add_service;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @contact_name.
  ///
  /// In en, this message translates to:
  /// **'Contact name'**
  String get contact_name;

  /// No description provided for @posted_projects.
  ///
  /// In en, this message translates to:
  /// **'Posted projects: '**
  String get posted_projects;

  /// No description provided for @customer2.
  ///
  /// In en, this message translates to:
  /// **'Customer: '**
  String get customer2;

  /// No description provided for @no_description.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get no_description;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @select_category.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get select_category;

  /// No description provided for @select_city.
  ///
  /// In en, this message translates to:
  /// **'Select city'**
  String get select_city;

  /// No description provided for @add_at_least_one_contact.
  ///
  /// In en, this message translates to:
  /// **'Add at least one contact'**
  String get add_at_least_one_contact;

  /// No description provided for @contacts_are_not_fully_filled_out.
  ///
  /// In en, this message translates to:
  /// **'Contacts are not fully filled out'**
  String get contacts_are_not_fully_filled_out;

  /// No description provided for @add_at_least_one_service.
  ///
  /// In en, this message translates to:
  /// **'Add at least one service'**
  String get add_at_least_one_service;

  /// No description provided for @category_is_not_filled_out.
  ///
  /// In en, this message translates to:
  /// **'Category is not filled out'**
  String get category_is_not_filled_out;

  /// No description provided for @type_is_not_specified.
  ///
  /// In en, this message translates to:
  /// **'Type is not specified'**
  String get type_is_not_specified;

  /// No description provided for @bIN_is_not_filled.
  ///
  /// In en, this message translates to:
  /// **'BIN/IIN is not filled'**
  String get bIN_is_not_filled;

  /// No description provided for @bIN_is_not_fully_filled.
  ///
  /// In en, this message translates to:
  /// **'BIN/INN is not fully filled'**
  String get bIN_is_not_fully_filled;

  /// No description provided for @bIN_maximum_12_digits.
  ///
  /// In en, this message translates to:
  /// **'BIN/INN maximum 12 digits'**
  String get bIN_maximum_12_digits;

  /// No description provided for @work_time_is_not_filled.
  ///
  /// In en, this message translates to:
  /// **'Work time is not filled'**
  String get work_time_is_not_filled;

  /// No description provided for @description_exceeds_1000_characters.
  ///
  /// In en, this message translates to:
  /// **'Description exceeds 1000 characters'**
  String get description_exceeds_1000_characters;

  /// No description provided for @not_an_email.
  ///
  /// In en, this message translates to:
  /// **'Not an email'**
  String get not_an_email;

  /// No description provided for @email_is_empty.
  ///
  /// In en, this message translates to:
  /// **'Email is empty'**
  String get email_is_empty;

  /// No description provided for @response_relevance_is_not_filled.
  ///
  /// In en, this message translates to:
  /// **'Response relevance is not filled'**
  String get response_relevance_is_not_filled;

  /// No description provided for @latitude_not_filled.
  ///
  /// In en, this message translates to:
  /// **'Latitude is not filled'**
  String get latitude_not_filled;

  /// No description provided for @latitude_cannot_be_less_than_90.
  ///
  /// In en, this message translates to:
  /// **'Latitude cannot be less than -90°'**
  String get latitude_cannot_be_less_than_90;

  /// No description provided for @latitude_cannot_be_greater_than_90.
  ///
  /// In en, this message translates to:
  /// **'Latitude cannot be greater than +90°'**
  String get latitude_cannot_be_greater_than_90;

  /// No description provided for @longitude_is_not_filled.
  ///
  /// In en, this message translates to:
  /// **'Longitude is not filled'**
  String get longitude_is_not_filled;

  /// No description provided for @longitude_cannot_be_less_than_180.
  ///
  /// In en, this message translates to:
  /// **'Longitude cannot be less than -180°'**
  String get longitude_cannot_be_less_than_180;

  /// No description provided for @longitude_cannot_be_greater_than_180.
  ///
  /// In en, this message translates to:
  /// **'Longitude cannot be greater than 180°'**
  String get longitude_cannot_be_greater_than_180;

  /// No description provided for @name_is_empty.
  ///
  /// In en, this message translates to:
  /// **'Name is empty'**
  String get name_is_empty;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @password_must_be_at_least_8_characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get password_must_be_at_least_8_characters;

  /// No description provided for @password_is_empty.
  ///
  /// In en, this message translates to:
  /// **'Password is empty'**
  String get password_is_empty;

  /// No description provided for @phone_number_is_empty.
  ///
  /// In en, this message translates to:
  /// **'Phone number is empty'**
  String get phone_number_is_empty;

  /// No description provided for @code_is_empty.
  ///
  /// In en, this message translates to:
  /// **'Code is empty'**
  String get code_is_empty;

  /// No description provided for @code_is_6_characters.
  ///
  /// In en, this message translates to:
  /// **'Code is 6 characters'**
  String get code_is_6_characters;

  /// No description provided for @fill_in_the_price.
  ///
  /// In en, this message translates to:
  /// **'Fill in the price'**
  String get fill_in_the_price;

  /// No description provided for @header_is_empty.
  ///
  /// In en, this message translates to:
  /// **'Header is empty'**
  String get header_is_empty;

  /// No description provided for @days_3.
  ///
  /// In en, this message translates to:
  /// **'3 days'**
  String get days_3;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get month;

  /// No description provided for @by_creation.
  ///
  /// In en, this message translates to:
  /// **'By creation'**
  String get by_creation;

  /// No description provided for @by_date.
  ///
  /// In en, this message translates to:
  /// **'By date'**
  String get by_date;

  /// No description provided for @by_status.
  ///
  /// In en, this message translates to:
  /// **'By status'**
  String get by_status;

  /// No description provided for @by_category.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get by_category;

  /// No description provided for @mobile_phone.
  ///
  /// In en, this message translates to:
  /// **'Mobile phone'**
  String get mobile_phone;

  /// No description provided for @home_phone.
  ///
  /// In en, this message translates to:
  /// **'Home phone'**
  String get home_phone;

  /// No description provided for @additional_data.
  ///
  /// In en, this message translates to:
  /// **'Additional data'**
  String get additional_data;

  /// No description provided for @unknown_error.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknown_error;

  /// No description provided for @the_number_of_orders.
  ///
  /// In en, this message translates to:
  /// **'The number of orders'**
  String get the_number_of_orders;

  /// No description provided for @city2.
  ///
  /// In en, this message translates to:
  /// **'City: '**
  String get city2;

  /// No description provided for @bIN2.
  ///
  /// In en, this message translates to:
  /// **'BIN/IIN: '**
  String get bIN2;

  /// No description provided for @no_price_list.
  ///
  /// In en, this message translates to:
  /// **'No price list'**
  String get no_price_list;

  /// No description provided for @price_list.
  ///
  /// In en, this message translates to:
  /// **'Price list'**
  String get price_list;

  /// No description provided for @write.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get write;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @artist2.
  ///
  /// In en, this message translates to:
  /// **'Artist: '**
  String get artist2;

  /// No description provided for @address2.
  ///
  /// In en, this message translates to:
  /// **'Address: '**
  String get address2;

  /// No description provided for @en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get en;

  /// No description provided for @ru.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get ru;

  /// No description provided for @kk.
  ///
  /// In en, this message translates to:
  /// **'Kazakh'**
  String get kk;

  /// No description provided for @add_to_Favorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorite'**
  String get add_to_Favorite;

  /// No description provided for @creating_an_service.
  ///
  /// In en, this message translates to:
  /// **'Creating a service'**
  String get creating_an_service;

  /// No description provided for @create_service.
  ///
  /// In en, this message translates to:
  /// **'Create service'**
  String get create_service;

  /// No description provided for @service_category.
  ///
  /// In en, this message translates to:
  /// **'Service category'**
  String get service_category;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @days_count.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String days_count(String count);

  /// No description provided for @activate_for_free.
  ///
  /// In en, this message translates to:
  /// **'Activate for free'**
  String get activate_for_free;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @subscribed_for_days.
  ///
  /// In en, this message translates to:
  /// **'You subscribed for {count} days'**
  String subscribed_for_days(String count);

  /// No description provided for @tenge_price.
  ///
  /// In en, this message translates to:
  /// **'{amount} ₸'**
  String tenge_price(String amount);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
