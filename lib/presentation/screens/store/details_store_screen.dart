import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/repositories/store_repository.dart';
import 'package:megaladon/logic/screens/store/details/store_screen_details_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/picker/star_picker.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/list/file_download_list.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/snackbars/success_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:megaladon/presentation/widgets/tiles/contact_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsStoreScreen extends StatefulWidget {

  final int storeId;

  const DetailsStoreScreen({super.key, required this.storeId});

  @override
  State<DetailsStoreScreen> createState() => _DetailsStoreScreenState();
}

class _DetailsStoreScreenState extends State<DetailsStoreScreen> {
  late StarPickerController _starController;


  _call(StoreModel store) => () {
    String? phone;

    store.contacts?.forEach((element) {
      if(element.type == ContactType.home_phone || element.type == ContactType.phone) {
       phone = element.value;
      }
    });
    if(phone != null) {
      launchUrl(Uri(scheme: 'tel', path: phone));
    }
  };

  @override
  void initState() {
    _onRefresh();
    _starController = StarPickerController();
    super.initState();
  }

  _onRefresh() async {
    await context.read<StoreScreenDetailsCubit>().fetch(id: widget.storeId);
  }

  _rateStore(StoreModel store) => () {
    showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      elevation: 100,
      builder: (_) =>  RateStoreModal(store)
    );
  };

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  _onTrailing() => () {
    showModalBottomSheet(
        useRootNavigator: true,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return Container(
            color: Theme.of(context).colorScheme.background,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButtonApp(
                  child: Text('Изменить'),
                  onPressed: _toUpdate,
                ),
                SizedBox(height: 5),
              ],
            ),
          );
        }
    );
  };

  _toUpdate() {
    context.router.navigate(InitialRouter(
      children: [
        ProfileRouter(
          children: [
            ChangeStoreRoute()
          ]
        )
      ]
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool isBool) {
            return [
              BlocBuilder<StoreScreenDetailsCubit, StoreScreenDetailsState>(
                builder:  (context, state) {
                  if(state is StoreScreenDetailsSuccess) {
                    return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: HeaderAppBar(isBack: true, title: '${state.store.name}', onTrailing: _onTrailing),
                        )
                    );
                  } else {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: HeaderAppBar(isBack: true),
                      )
                    );
                  }

                }
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocBuilder<StoreScreenDetailsCubit, StoreScreenDetailsState>(
                builder: (context, state) {
                  if(state is StoreScreenDetailsSuccess) {
                    return Column(
                      children: [
                        const SizedBox(height: 20,),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            width: MediaQuery.of(context).size.width/3,
                            height: MediaQuery.of(context).size.width/3,
                            color: Theme.of(context).colorScheme.secondary,
                            child: CachedNetworkImage(
                              imageUrl:  state.store.photo ?? '',
                              progressIndicatorBuilder: (context, url, downloadProgress) => Icon(IconPack.market, size: MediaQuery.of(context).size.width / 5),
                              errorWidget:  (context, url, error) => Icon(IconPack.market, size: MediaQuery.of(context).size.width / 5),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        TextButton(child: Text('Оценить'), onPressed: _rateStore(state.store)),
                        const SizedBox(height: 20,),
                        DataTile(title: 'Address2'.tr(), data: state.store.fullAddress),
                        if(state.store.city != null) DataTile(title: 'City2'.tr(), data: state.store.city!.name),
                        if(state.store.bin != null) DataTile(title: 'BIN2'.tr(), data: state.store.bin.toString()),
                        ...state.store.contacts!.map((contact) {
                          return ContactTile(contact: contact);
                        }).toList(),
                        const SizedBox(height: 20,),

                        if(state.store.prices.isEmpty) SubTitleApp('No_price_list'.tr())
                        else ...[
                          SubTitleApp('Price_list'.tr()),
                          const SizedBox(height: 10,),
                          FileDownloadList(files: state.store.prices),
                        ],
                        const SizedBox(height: 20,),
                        if(state.store.hasPhone) ElevatedButtonApp(
                          text: 'Call'.tr(),
                          onPressed: _call(state.store),
                        ),
                      ],
                    );
                  }
                  else if(state is StoreScreenDetailsLoader) {
                    return const Loader(padding: 10,);
                  } else if(state is StoreScreenDetailsError) {
                    return ErrorMessage(error: state.error);
                  }
                  return Container();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RateStoreModal extends StatefulWidget {
  final StoreModel store;

  RateStoreModal(this.store);


  @override
  State<RateStoreModal> createState() => _RateStoreModalState();
}

class _RateStoreModalState extends State<RateStoreModal> {
  late StarPickerController _starPickerController;


  @override
  void initState() {
    _starPickerController = StarPickerController();
    super.initState();
  }

  @override
  void dispose() {
    _starPickerController.dispose();
    super.dispose();
  }

  _rate() {
    StoreRepository().rate(widget.store.id, _starPickerController.value).then((value) {
      context.router.pop();
      showSuccessSnackBar(context, 'Вы оценили магазин');
    }).catchError((error) {
      context.router.pop();
      if(error is DioError) {
        showErrorSnackBar(context, error.response?.data['message'] ?? 'Неизвестная ошибка');
      } else {
        showErrorSnackBar(context, 'Неизвестная ошибка');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StarPicker(controller: _starPickerController),
          SizedBox(height: 10),
          ElevatedButtonApp(onPressed: _rate, child: Text('Отправить'))
        ],
      ),
    );
  }
}