import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';

void showContextMenu(
    BuildContext context, Offset tapPosition, VoidCallback callback) {
  final user = context.read<AuthBloc>().icocUser;
  if (user != null && user.isAdmin) {
    final OverlayState? overlayState = Overlay.of(context);
    if (overlayState == null) {
      return;
    }

    final RenderBox overlay =
        overlayState.context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        tapPosition,
        tapPosition,
      ),
      Offset.zero & overlay.size,
    );
    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
            onTap: callback,
            child: const Text(
              'Delete',
              style: TextStyle(color: ScreenColors.songBook),
            )),
      ],
    );
  }
}
