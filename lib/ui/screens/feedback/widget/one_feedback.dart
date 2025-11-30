import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/model/feedback/feedback_model.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';

class OneFeedback extends StatefulWidget {
  final FeedbackModel feedbackModel;

  const OneFeedback({
    super.key,
    required this.feedbackModel,
  });

  @override
  State<OneFeedback> createState() => _OneFeedbackState();
}

class _OneFeedbackState extends State<OneFeedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 45,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MyTextButton(
            label: 'Edit',
            onPressed: () {
              context.go('/feedbacks/edit');
            },
          ),
        ),
      ],
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.feedbackModel.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(widget.feedbackModel.text),
          const SizedBox(height: 150),
          const Text('Comment from developer:',
              style:
                  TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
          Text(widget.feedbackModel.comment ?? ''),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
