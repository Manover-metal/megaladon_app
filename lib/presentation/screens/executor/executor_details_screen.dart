import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/chats/chat_cubit.dart';
import 'package:megaladon/logic/screens/executors/details/executor_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/widgets/avatar/avatar.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/rating/rating_stars.dart';
import 'package:megaladon/presentation/widgets/review/user_reviews_section.dart';
import 'package:megaladon/presentation/widgets/section/content_section.dart';

class DetailsExecutorScreen extends StatefulWidget {
  const DetailsExecutorScreen({required this.executorId, super.key});
  final int executorId;

  @override
  State<DetailsExecutorScreen> createState() => _DetailsExecutorScreenState();
}

class _DetailsExecutorScreenState extends State<DetailsExecutorScreen> {
  static const double _sectionGap = 18;

  @override
  void initState() {
    context
        .read<ExecutorScreenDetailsCubit>()
        .fetch(executorId: widget.executorId);
    super.initState();
  }

  /// Отдаём кнопке Future запроса — «Написать» держит крутилку и не
  /// принимает второе нажатие. Переписку открывает ChatOpenListener.
  Future<void> _toChat(int userId) =>
      context.read<ChatCubit>().openChatWith(userId);

  @override
  Widget build(BuildContext context) => Scaffold(
        // Заголовка в шапке не было вообще: HeaderAppBar вызывался без title.
        appBar: HeaderAppBar(
          isBack: true,
          compactTitle: true,
          title: AppLocalizations.of(context)!.executorLabel,
        ),
        body:
            BlocBuilder<ExecutorScreenDetailsCubit, ExecutorScreenDetailsState>(
          builder: (context, state) {
            if (state is ExecutorScreenDetailsLoader) {
              return const Loader(padding: 10);
            }
            if (state is ExecutorScreenDetailsError) {
              return ErrorMessage(error: state.error);
            }
            if (state is ExecutorScreenDetailsSuccess) {
              return _ExecutorBody(executor: state.executor, gap: _sectionGap);
            }
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar:
            BlocBuilder<ExecutorScreenDetailsCubit, ExecutorScreenDetailsState>(
          builder: (context, state) {
            if (state is! ExecutorScreenDetailsSuccess) {
              return const SizedBox.shrink();
            }

            return _ContactBar(
              executor: state.executor,
              onWrite: _toChat,
            );
          },
        ),
      );
}

/// Визитка: крупный аватар, имя, звёзды и три показателя в ряд. Раньше имя
/// выводилось дважды — в тайле «Исполнитель: …» и следом строкой
/// «Организация», — а рейтинг печатался числом «0.0».
class _ExecutorBody extends StatelessWidget {
  const _ExecutorBody({required this.executor, required this.gap});
  final ExecutorModel executor;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final rows = <List<String>>[
      if (executor.bin != null && executor.bin!.isNotEmpty)
        [l10n.bIN, executor.bin!],
      if (executor.fullAddress != null && executor.fullAddress!.isNotEmpty)
        [l10n.address, executor.fullAddress!],
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Avatar(
                  name: executor.name,
                  photoUrl: executor.photo,
                  size: 88,
                ),
                const SizedBox(height: 10),
                Text(
                  executor.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                    fontStyle: executor.isDeleted ? FontStyle.italic : null,
                    color: executor.isDeleted
                        ? theme.disabledColor
                        : theme.textTheme.bodyMedium?.color,
                  ),
                ),
                if (!executor.isDeleted) ...[
                  const SizedBox(height: 8),
                  if (executor.rating != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RatingStars(rate: executor.rating!, size: 15),
                        const SizedBox(width: 6),
                        Text(
                          executor.rating!.toStringAsFixed(1),
                          style:
                              TextStyle(fontSize: 12, color: scheme.secondary),
                        ),
                      ],
                    )
                  else
                    Text(
                      l10n.noRatings,
                      style: TextStyle(fontSize: 12, color: scheme.secondary),
                    ),
                ],
              ],
            ),
          ),
          if (!executor.isDeleted) ...[
            SizedBox(height: gap),
            _Metrics(executor: executor),
            if (executor.description != null &&
                executor.description!.isNotEmpty) ...[
              SizedBox(height: gap),
              ContentSection(
                title: l10n.description,
                child: Text(
                  executor.description!,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ],
            if (executor.services.isNotEmpty) ...[
              SizedBox(height: gap),
              ContentSection(
                title: l10n.services,
                padding: const EdgeInsets.all(11),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: executor.services
                      .map((service) => _Chip(text: service.name))
                      .toList(),
                ),
              ),
            ],
            if (rows.isNotEmpty) ...[
              SizedBox(height: gap),
              ContentSection(
                title: l10n.requisitesLabel,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < rows.length; i++) ...[
                      if (i > 0) const SizedBox(height: 9),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 96,
                            child: Text(
                              rows[i].first,
                              style: TextStyle(
                                  fontSize: 13, color: scheme.secondary),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              rows[i].last,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
            // Отзывы привязаны к аккаунту, поэтому нужен user_id: у чужого
            // исполнителя он приходит только начиная с правки
            // ExecutorPresenter — без него секцию просто не рисуем.
            if (executor.userId != null) ...[
              SizedBox(height: gap),
              UserReviewsSection(userId: executor.userId!),
            ],
          ],
        ],
      ),
    );
  }
}

/// Заказы, рейтинг и число услуг одной строкой. Показатель без данных
/// показывает прочерк, а не ноль: «0 заказов» и «нет заказов» — разное.
class _Metrics extends StatelessWidget {
  const _Metrics({required this.executor});
  final ExecutorModel executor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final items = <List<String>>[
      [executor.countOrders?.toString() ?? '—', l10n.metricOrders],
      [executor.rating?.toStringAsFixed(1) ?? '—', l10n.metricRating],
      [executor.services.length.toString(), l10n.metricServices],
    ];

    return CardBox(
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) Container(width: 1, color: scheme.onTertiary),
              Expanded(
                child: _Metric(value: items[i].first, label: items[i].last),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              height: 1.2,
              fontWeight: FontWeight.w700,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(fontSize: 10.5, color: theme.colorScheme.secondary),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.onTertiary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, height: 1.3, color: scheme.secondary),
      ),
    );
  }
}

/// Закреплённое действие. Со страницы исполнителя раньше нельзя было сделать
/// ничего: кнопка «Чат» в карточке лежала закомментированной.
class _ContactBar extends StatelessWidget {
  const _ContactBar({required this.executor, required this.onWrite});
  final ExecutorModel executor;
  final void Function(int userId) onWrite;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
        builder: (context, stateUser) {
          final userId = executor.userId;

          // Гостю писать нечем, себе самому — незачем, у удалённого аккаунта
          // чата уже нет. И без user_id с бэкенда чат не завести.
          if (userId == null ||
              executor.isDeleted ||
              stateUser.user == null ||
              stateUser.user!.id == userId) {
            return const SizedBox.shrink();
          }

          final scheme = Theme.of(context).colorScheme;

          return Container(
            decoration: BoxDecoration(
              color: scheme.tertiary,
              border: Border(top: BorderSide(color: scheme.onTertiary)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                // Колонка с min: кнопка держит текст в Container с
                // alignment и иначе растягивается на всю высоту, которую
                // даёт bottomNavigationBar.
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButtonApp(
                      text: AppLocalizations.of(context)!.writeMessage,
                      onPressed: () => onWrite(userId),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
