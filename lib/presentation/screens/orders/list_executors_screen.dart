import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/offers/list/offer_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/card/offer_card.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class ListExecutorsScreen extends StatefulWidget {
  const ListExecutorsScreen({required this.orderId, super.key});
  final int orderId;

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
  Widget build(BuildContext context) => Scaffold(
        // Шапка лежала в SliverToBoxAdapter с отступом 20 по бокам: она была
        // сдвинута от краёв и уезжала вместе со списком.
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: BlocBuilder<OfferScreenMainCubit, OfferScreenMainState>(
            builder: (context, state) {
              final l10n = AppLocalizations.of(context)!;
              final count =
                  state is OfferScreenMainSuccess ? state.offers.length : null;

              return HeaderAppBar(
                isBack: true,
                compactTitle: true,
                // Раньше сюда шёл ключ `executor` — «Исполнитель: », с
                // двоеточием внутри значения и в единственном числе.
                title: count == null
                    ? l10n.offersTitle
                    : '${l10n.offersTitle} · $count',
                onTrailing: _refresh,
                trailing: state is! OfferScreenMainLoader
                    ? const Icon(Icons.refresh, size: 26)
                    : const CupertinoActivityIndicator(),
              );
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: CupertinoScrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              child: BlocBuilder<OfferScreenMainCubit, OfferScreenMainState>(
                builder: (context, state) {
                  if (state is OfferScreenMainLoader) {
                    return const Loader();
                  }
                  if (state is OfferScreenMainError) {
                    return ErrorMessage(error: state.error);
                  }
                  if (state is OfferScreenMainSuccess) {
                    // Пустой список раньше давал пустой Column и белый экран.
                    if (state.offers.isEmpty) {
                      return _Empty(
                          text: AppLocalizations.of(context)!.noOffersYet);
                    }

                    return Column(
                      children: state.offers
                          .map((offer) =>
                              OfferCard(offer: offer, orderId: widget.orderId))
                          .toList(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      );
}

class _Empty extends StatelessWidget {
  const _Empty({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 40, color: scheme.secondary),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: scheme.secondary),
          ),
        ],
      ),
    );
  }
}
