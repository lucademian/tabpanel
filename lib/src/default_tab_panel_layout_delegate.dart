import 'package:flutter/material.dart';
import 'package:tabpanel/src/context_menu.dart';
import 'package:tabpanel/src/tab_panel_widget.dart';

import 'context_menu_item.dart';
import 'tab_panel.dart';
import 'tab.dart' as tab;
import 'tab_panel_layout_delegate.dart';

class DefaultTabPanelLayoutDelegate implements TabPanelLayoutDelegate {
  DefaultTabPanelLayoutDelegate(BuildContext context)
      : theme = Theme.of(context);

  final ThemeData theme;

  @override
  Widget get defaultTabIcon =>
      Icon(Icons.tab, color: theme.colorScheme.onSurface);

  @override
  String get defaultTabTitle => 'Tab';

  @override
  Widget buildTabCloseButton(VoidCallback? closeTab, bool selected) =>
      IconButton(
        icon: Icon(Icons.close),
        onPressed: closeTab,
        color: theme.colorScheme.onSurface,
      );

  @override
  Widget buildTabWidget(
    Widget icon,
    String title,
    Widget? closeButton,
    bool selected,
  ) =>
      Row(children: [
        VerticalDivider(width: 1),
        SizedBox(width: 8),
        icon,
        SizedBox(width: 8),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 75),
          child: Tooltip(
            message: title,
            child: Text(
              title,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: theme.textTheme.button?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
        SizedBox(width: 8),
        if (closeButton != null) closeButton,
        SizedBox(width: 8),
        VerticalDivider(width: 1),
      ]);

  @override
  Widget buildTabWidgetContainer(
          bool selected, VoidCallback? onSelect, Widget tabContents) =>
      MaterialButton(
        onPressed: onSelect,
        hoverColor: Colors.red,
        color: selected
            ? theme.colorScheme.primary.withOpacity(0.5)
            : theme.colorScheme.secondary,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 40),
          child: tabContents,
        ),
      );

  @override
  Widget buildTabBarLeadingWidget(tab.Tab? selectedTab) => IconButton(
        icon: Icon(Icons.chevron_left),
        onPressed:
            (selectedTab?.pages.length ?? 0) > 1 ? selectedTab!.pop : null,
      );

  @override
  Widget buildTabBarMenuButton(TabPanel panel) => ContextMenu(
        showOnTap: true,
        menuItems: [
          ContextMenuItem(
            title: 'New Tab',
            icon: Icons.edit,
            onPressed: () => panel.newTab(),
          ),
          ContextMenuItem(),
          ContextMenuItem(
            title: 'Split right',
            icon: Icons.arrow_right,
            onPressed: () => panel.splitPanel(
              panelId: panel.id,
              axis: Axis.horizontal,
              position: TabPosition.after,
            ),
          ),
          ContextMenuItem(
            title: 'Split left',
            icon: Icons.arrow_left,
            onPressed: () => panel.splitPanel(
              panelId: panel.id,
              axis: Axis.horizontal,
              position: TabPosition.before,
            ),
          ),
          ContextMenuItem(
            title: 'Split down',
            icon: Icons.arrow_drop_down,
            onPressed: () => panel.splitPanel(
              panelId: panel.id,
              axis: Axis.vertical,
              position: TabPosition.after,
            ),
          ),
          ContextMenuItem(
            title: 'Split up',
            icon: Icons.arrow_drop_up,
            onPressed: () => panel.splitPanel(
              panelId: panel.id,
              axis: Axis.vertical,
              position: TabPosition.before,
            ),
          ),
          if (panel.parent != null) ...[
            ContextMenuItem(),
            ContextMenuItem(
              title: 'Close',
              icon: Icons.close,
              onPressed: panel.closePanel,
            ),
          ],
        ],
        child: Icon(Icons.more_horiz),
      );

  @override
  Widget buildEmptyPanel(TabPanel panel) => EmptyPanel(panel);

  @override
  Widget buildTabBarContainer(Widget tabs) => Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1,
                  style: BorderStyle.solid,
                  color: theme.colorScheme.onSurface.withOpacity(.2)))),
      child: tabs);

  @override
  Widget buildNewTabButton(VoidCallback onPressed) =>
      IconButton(onPressed: onPressed, icon: Icon(Icons.add));
}
