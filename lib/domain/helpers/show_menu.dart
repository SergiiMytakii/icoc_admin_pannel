import 'package:flutter/material.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';

void showContextMenu(
    BuildContext context, Offset tapPosition, VoidCallback callback) {
  final user = getIt<AuthBloc>().icocUser;
  if (user != null && user.isAdmin) {
    print('User is admin');
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

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
