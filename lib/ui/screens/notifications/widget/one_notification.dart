import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:icoc_admin_pannel/domain/model/notifications_model.dart';
import 'package:icoc_admin_pannel/ui/screens/notifications/widget/add_lang_tab.dart';
import 'package:icoc_admin_pannel/ui/widget/alert_dialog.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';

class OneNotification extends StatefulWidget {
  final NotificationsModel notificationsModel;

  OneNotification({
    super.key,
    required this.notificationsModel,
  });

  @override
  State<OneNotification> createState() => _OneNotificationState();
}

class _OneNotificationState extends State<OneNotification>
    with TickerProviderStateMixin {
  List<String> tabsKeys = [];

  late TabController tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tabsKeys = getAllKeys(widget.notificationsModel)..add('+');
    logger(tabsKeys);
    tabController = TabController(length: tabsKeys.length, vsync: this);
    return DefaultTabController(
      length: tabsKeys.length,
      child: Scaffold(
        appBar: _buildAppBar(
          context,
        ),
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            _tabBarBuilder(widget.notificationsModel),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
  ) {
    return AppBar(
      toolbarHeight: 45,
      actions: [
        MyTextButton(
          label: 'Add a new notification',
          onPressed: () async {
            context.go('/notifications/addnotification');
          },
        ),
      ],
      bottom: TabBar(
          isScrollable: true,
          controller: tabController,
          tabs: List.generate(
              tabsKeys.length, (index) => Tab(text: tabsKeys[index]))),
      elevation: 0,
    );
  }

  List<String> getAllKeys(NotificationsModel notificationsModel) {
    final keys = notificationsModel.notifications
        .map((notification) => notification.lang)
        .toList();
    return keys;
  }

  TabBarView _tabBarBuilder(NotificationsModel notificationsModel) {
    return TabBarView(
      controller: tabController,
      children: [
        for (final item in widget.notificationsModel.notifications)
          Tab(text: item.text),
        AddLangTab(notificationsModel)
      ],
    );
  }
}
