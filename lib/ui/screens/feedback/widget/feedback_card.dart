import 'package:flutter/material.dart';
import 'package:icoc_admin_pannel/domain/model/feedback/feedback_model.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/feedback/feedback_bloc.dart';
import 'package:intl/intl.dart';

class FeedbackCard extends StatelessWidget {
  final FeedbackModel feedback;
  final String currentFeedbackId;

  FeedbackCard({
    super.key,
    required this.feedback,
    required this.currentFeedbackId,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentFeedbackId == feedback.id;
    return Column(
      children: [
        ListTile(
          selectedColor: Theme.of(context).primaryColor,
          selected: isSelected,
          horizontalTitleGap: 12,
          leading: const SizedBox(
            width: 20,
          ),
          title: Text(
            feedback.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w500,
                color: isSelected ? Theme.of(context).primaryColor : null),
          ),
          subtitle: Text(
            DateFormat('MMM d, yyyy HH:mm')
                .format(DateTime.parse(feedback.date)),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: isSelected ? Theme.of(context).primaryColor : null),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              getIt<FeedbackBloc>().add(FeedbackEvent.delete(
                  user: getIt<AuthBloc>().icocUser, feedbackId: feedback.id));
              getIt<FeedbackBloc>().currentFeedback.value =
                  FeedbackModel.defaultFeedback();
            },
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        const Divider(
          indent: 50,
          thickness: 1.2,
        ),
      ],
    );
  }
}
