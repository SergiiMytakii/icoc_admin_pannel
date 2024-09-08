import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/feedback/feedback_bloc.dart';
import 'package:icoc_admin_pannel/ui/screens/feedback/widget/feedback_card.dart';
import 'package:icoc_admin_pannel/ui/screens/feedback/widget/one_feedback.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      final state = context.watch<FeedbackBloc>().state;
      return state.when(
          initial: () {
            getIt<FeedbackBloc>().add(const FeedbackEvent.get());
            return const SizedBox.shrink();
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Center(child: Text(message)),
          success: (feedbacks) {
            return Row(
              children: [
                Flexible(
                  child: ListView.builder(
                      itemCount: feedbacks.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () => context
                                .read<FeedbackBloc>()
                                .currentFeedback
                                .value = feedbacks[index],
                            child: ValueListenableBuilder(
                                valueListenable:
                                    getIt<FeedbackBloc>().currentFeedback,
                                builder: (context, currentFeedback, _) {
                                  return FeedbackCard(
                                    feedback: feedbacks[index],
                                    currentFeedbackId: currentFeedback.id,
                                  );
                                }));
                      }),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Flexible(
                    flex: 2,
                    child: ValueListenableBuilder(
                        valueListenable:
                            context.read<FeedbackBloc>().currentFeedback,
                        builder: (context, feedback, _) {
                          return OneFeedback(
                            feedbackModel: feedback,
                          );
                        }))
              ],
            );
          });
    }));
  }
}
