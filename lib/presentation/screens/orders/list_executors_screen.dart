import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/offers/list/offer_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/card/offer_card.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class ListExecutorsScreen extends StatefulWidget {
  final int orderId;

  const ListExecutorsScreen({super.key, required this.orderId});

  @override
  State<ListExecutorsScreen> createState() => _ListExecutorsScreenState();
}

class _ListExecutorsScreenState extends State<ListExecutorsScreen> {
  late ScrollController _scrollController;


  @override
  void initState() {
    _scrollController = ScrollController();
    _refresh();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future _refresh() async {
    await context.read<OfferScreenMainCubit>().fetch(orderId: widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: HeaderAppBar(isBack: true, title: 'Исполнители'),
                ),
              )
            ];
          },
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: CupertinoScrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      BlocBuilder<OfferScreenMainCubit, OfferScreenMainState>(
                        builder: (context, state) {
                          if(state is OfferScreenMainSuccess) {
                            return Column(
                              children: state.offers.map((offer) {
                                return OfferCard(offer: offer, orderId: widget.orderId);
                              }).toList(),
                            );
                          }else if(state is OfferScreenMainLoader) {
                            return const Loader();
                          } else if(state is OfferScreenMainError) {
                            return ErrorMessage(error: state.error);
                          }
                          return Container();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// return OfferCard();
