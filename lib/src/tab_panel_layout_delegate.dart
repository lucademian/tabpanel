import 'package:flutter/widgets.dart';
import 'tab_panel.dart';
import 'tab.dart' as tab;

abstract class TabPanelLayoutDelegate {
  String get defaultTabTitle;
  Widget get defaultTabIcon;
  Widget buildTabWidget(
      Widget icon, String title, Widget? closeButton, bool selected);
  Widget buildTabWidgetContainer(
      bool selected, VoidCallback? onSelect, Widget tabContents);
  Widget buildTabCloseButton(VoidCallback? closeTab, bool selected);
  Widget buildTabBarMenuButton(TabPanel panel);
  Widget buildTabBarLeadingWidget(tab.Tab? selectedTab);
  Widget buildEmptyPanel(TabPanel panel);
  Widget buildTabBarContainer(Widget tabs);
  Widget buildNewTabButton(VoidCallback onPressed);
}
