import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/model/insights/post.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/insights/insights_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/screens/insights/widgets/insight_card.dart';
import 'package:icoc_admin_pannel/domain/helpers/show_menu.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Insights', style: TextStyle(fontSize: 20)),
                const Spacer(),
                MyTextButton(
                  onPressed: () => context.go('/insights/add'),
                  label: 'Add',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<InsightsBloc, InsightsState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    initial: () {
                      final isAuthed = context.read<AuthBloc>().state.maybeWhen(
                          authenticated: (_) => true, orElse: () => false);
                      if (isAuthed) {
                        context
                            .read<InsightsBloc>()
                            .add(const InsightsEvent.get());
                      }
                      return const SizedBox.shrink();
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    success: (posts) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                final p = posts[index];
                                return GestureDetector(
                                  onTap: () => context
                                      .read<InsightsBloc>()
                                      .currentPost
                                      .value = p,
                                  onSecondaryTapDown: (details) {
                                    showContextMenu(
                                      context,
                                      details.globalPosition,
                                      () {
                                        context.read<InsightsBloc>().add(
                                              InsightsEvent.delete(
                                                user: context
                                                    .read<AuthBloc>()
                                                    .icocUser,
                                                id: p.id,
                                              ),
                                            );
                                        context
                                            .read<InsightsBloc>()
                                            .currentPost
                                            .value = null;
                                      },
                                    );
                                  },
                                  child: ValueListenableBuilder<Post?>(
                                    valueListenable: context
                                        .read<InsightsBloc>()
                                        .currentPost,
                                    builder: (context, current, _) {
                                      return InsightCard(
                                        post: p,
                                        currentPostId: current?.id ?? '',
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          const VerticalDivider(thickness: 1, width: 1),
                          Expanded(
                            flex: 3,
                            child: ValueListenableBuilder<Post?>(
                              valueListenable:
                                  context.read<InsightsBloc>().currentPost,
                              builder: (context, current, _) {
                                if (current == null)
                                  return const SizedBox.shrink();
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Text(current.title ?? '',
                                            style:
                                                const TextStyle(fontSize: 18)),
                                        const SizedBox(height: 8),
                                        const Spacer(),
                                        MyTextButton(
                                          onPressed: () =>
                                              context.go('/insights/edit'),
                                          label: 'Edit',
                                        ),
                                      ]),
                                      const SizedBox(height: 8),
                                      if (current.content != null)
                                        Expanded(
                                            child: SingleChildScrollView(
                                                child: Text(current.content!))),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    error: (msg) => Center(child: Text(msg)),
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
