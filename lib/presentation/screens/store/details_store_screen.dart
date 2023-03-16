import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/store/details/store_screen_details_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/list/file_download_list.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:megaladon/presentation/widgets/tiles/contact_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';

class DetailsStoreScreen extends StatefulWidget {

  final int storeId;

  const DetailsStoreScreen({super.key, required this.storeId});

  @override
  State<DetailsStoreScreen> createState() => _DetailsStoreScreenState();
}

class _DetailsStoreScreenState extends State<DetailsStoreScreen> {

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
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: HeaderAppBar(isBack: true),
                )
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
                        TitleApp('${state.store.type?.name} "${state.store.name}"'),
                        SizedBox(height: 20,),
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 6,
                          backgroundColor:  Colors.grey.shade300,
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
                          FileDownloadList(),
                          SizedBox(height: 10,),

                        ],
                        SizedBox(height: 20,),
                        if(state.store.hasPhone) ElevatedButtonApp(text: 'Позвонить'),
                        OutlinedButtonApp(text: 'Написать'),
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