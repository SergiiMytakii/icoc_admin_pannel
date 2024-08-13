import 'package:flutter/material.dart';
import 'package:icoc_admin_pannel/domain/model/feedback/feedback_model.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/feedback/feedback_bloc.dart';
import 'package:intl/intl.dart';

class FeedbackCard extends StatelessWidget {
  final FeedbackModel feedback;

  FeedbackCard({
    super.key,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          horizontalTitleGap: 12,
          leading: const SizedBox(
            width: 20,
          ),
          title: Text(
            feedback.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            DateFormat('MMM d, yyyy HH:mm')
                .format(DateTime.parse(feedback.date)),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyMedium,
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
