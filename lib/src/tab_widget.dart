import 'package:provider/src/provider.dart';

import 'context_menu.dart';
import 'context_menu_item.dart';
import 'tab_panel.dart';
import 'package:flutter/material.dart' hide Tab, Icons;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:desktop/desktop.dart' show Icons;
import 'tab.dart';
import 'tab_panel_layout_delegate.dart';

class TabWidget extends StatelessWidget {
  final Tab tab;
  final bool selected;
  final bool feedback;
  final TabPanelLayoutDelegate? layout;

  const TabWidget(
    this.tab, {
    Key? key,
    this.selected = false,
    this.feedback = false,
    this.layout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layoutDelegate = layout ?? context.watch<TabPanelLayoutDelegate>();
    final lastPage = tab.pages.isNotEmpty ? tab.pages.last : null;

    final defaultIcon = layoutDelegate.defaultTabIcon;
    Widget icon;
    String title;
    if (lastPage is TabPageMixin) {
      final tabPage = lastPage as TabPageMixin;

      icon = tabPage.iconData != null
          ? Icon(tabPage.iconData,
              color: Theme.of(context).colorScheme.onSurface)
          : tabPage.icon;

      title = tabPage.title;
    } else {
      icon = defaultIcon;
      title =
          lastPage?.runtimeType.toString() ?? layoutDelegate.defaultTabTitle;
    }

    final _tab = layoutDelegate.buildTabWidgetContainer(
      selected,
      () => tab.panel.selectTab(tab.id),
      Observer(builder: (context) {
        return layoutDelegate.buildTabWidget(
            feedback
                ? icon
                : Draggable<Tab>(
                    data: tab,
                    feedback: TabWidget(
                      tab,
                      feedback: true,
                      layout: layoutDelegate,
                    ),
                    child: icon,
                  ),
            title,
            !tab.locked
                ? layoutDelegate.buildTabCloseButton(
                    !tab.locked ? () => tab.panel.closeTab(tab.id) : null,
                    selected)
                : null,
            selected);
      }),
    );

    if (feedback) return Material(child: _tab);

    return Observer(builder: (_) {
      final isLocked = tab.locked;
      return ContextMenu(
        showOnTap: false,
        menuItems: [
          ContextMenuItem(
            title: isLocked ? 'Unlock' : 'Lock',
            icon: isLocked ? Icons.lock : Icons.lock_open,
            onPressed: tab.toggleLock,
          ),
          ContextMenuItem(),
          ContextMenuItem(
            title: 'New tab',
            icon: Icons.add,
            onPressed: () => tab.panel.newTab(tabId: tab.id),
          ),
          ContextMenuItem(
            title: 'New tab to the left',
            icon: Icons.add,
            onPressed: () => tab.panel.newTab(
              tabId: tab.id,
              position: TabPosition.before,
            ),
          ),
          ContextMenuItem(),
          if (!isLocked)
            ContextMenuItem(
              title: 'Close',
              icon: Icons.close,
              onPressed: () => tab.panel.closeTab(tab.id),
            ),
          if (tab.panel.tabs.length > 1) ...[
            ContextMenuItem(
              title: 'Close others',
              icon: Icons.remove_circle,
              onPressed: () => tab.panel.closeOtherTabs(tab.id),
            ),
            ContextMenuItem(
              title: 'Close right',
              icon: Icons.remove_circle,
              onPressed: () => tab.panel.closeRight(tab.id),
            ),
            ContextMenuItem(
              title: 'Close left',
              icon: Icons.remove_circle,
              onPressed: () => tab.panel.closeLeft(tab.id),
            ),
          ]
        ],
        child: _tab,
      );
    });
  }
}
