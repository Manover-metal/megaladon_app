import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/logic/screens/store/details/store_screen_details_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/list/file_download_list.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
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

  _toChat() {
    context.router.navigate(DetailsChatRouter());
  }

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
    context.read<StoreScreenDetailsCubit>().fetch(id: widget.storeId);
    super.initState();
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
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: HeaderAppBar(isBack: true, title: '${state.store.type?.name} "${state.store.name}"'),
                        )
                    );
                  } else return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: HeaderAppBar(isBack: true),
                      )
                  );

                }
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: BlocBuilder<StoreScreenDetailsCubit, StoreScreenDetailsState>(
                builder: (context, state) {
                  if(state is StoreScreenDetailsSuccess) {
                    return Column(
                      children: [
                        SizedBox(height: 20,),
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
                        SizedBox(height: 20,),
                        DataTile(title: 'Адрес:', data: state.store.fullAddress),
                        if(state.store.city != null) DataTile(title: 'Город:', data: state.store.city!.name),
                        if(state.store.bin != null) DataTile(title: 'БИН:', data: state.store.bin.toString()),
                        ...state.store.contacts!.map((contact) {
                          return ContactTile(contact: contact);
                        }).toList(),
                        SizedBox(height: 20,),

                        if(state.store.prices!.isEmpty) SubTitleApp('Нет прайс листа')
                        else ...[
                          SubTitleApp('Прайс лист'),
                          SizedBox(height: 10,),
                          // FileDownloadList(),
                          // SizedBox(height: 10,),

                        ],
                        SizedBox(height: 20,),
                        if(state.store.hasPhone) ElevatedButtonApp(
                          text: 'Позвонить',
                          onPressed: _call(state.store),
                        ),
                        OutlinedButtonApp(
                          text: 'Написать',
                          onPressed: _toChat,
                        ),
                      ],
                    );
                  }
                  else if(state is StoreScreenDetailsLoader) {
                    return Loader(padding: 10,);
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