import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/ui/bloc/insights/insights_bloc.dart';
import 'package:icoc_admin_pannel/ui/screens/insights/widgets/insight_editor_screen.dart';

class EditInsightScreen extends StatelessWidget {
  const EditInsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPost = context.read<InsightsBloc>().currentPost.value;
    if (currentPost == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go('/insights');
        }
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    return InsightEditorScreen(initialPost: currentPost);
  }
}
