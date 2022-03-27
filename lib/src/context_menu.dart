import 'package:flutter/material.dart';

import 'context_menu_item.dart';

@immutable
class ContextMenu extends StatefulWidget {
  final Widget? child;
  final Widget? icon;
  final List<ContextMenuItem> menuItems;
  final double bottomOffsetHeight;
  final double menuOffset;
  final bool showOnTap;

  const ContextMenu({
    Key? key,
    required this.menuItems,
    this.icon,
    this.child,
    this.bottomOffsetHeight = 0,
    this.menuOffset = 0,
    this.showOnTap = false,
  }) : super(key: key);

  @override
  _ContextMenuState createState() => _ContextMenuState();
}

class _ContextMenuState extends State<ContextMenu> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset(0, 0);
  Size childSize = Size(0, 0);

  void getOffset() {
    final renderBox =
        containerKey.currentContext?.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: containerKey,
      onTap: widget.showOnTap ? _showMenu : null,
      onSecondaryTap: _showMenu,
      onLongPress: _showMenu,
      child: widget.child,
    );
  }

  void _showMenu() async {
    getOffset();

    var size = MediaQuery.of(context).size;

    final maxMenuHeight = size.height;
    final listHeight = widget.menuItems.length * (48.0);

    final maxMenuWidth = 200.0;
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    final leftOffset = (childOffset.dx + maxMenuWidth) < size.width
        ? childOffset.dx
        : (childOffset.dx - maxMenuWidth + childSize.width);
    final topOffset = (childOffset.dy + menuHeight + childSize.height) <
            size.height - widget.bottomOffsetHeight
        ? childOffset.dy + childSize.height + widget.menuOffset
        : childOffset.dy - menuHeight - widget.menuOffset;

    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, _) => Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(color: Colors.transparent),
                ),
                Positioned(
                  top: topOffset,
                  left: leftOffset,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxMenuHeight),
                    child: SingleChildScrollView(
                        child: SizedBox(
                      width: maxMenuWidth,
                      child: buildContextMenu(widget.menuItems
                          .map((i) => ContextMenuItem(
                                title: i.title,
                                icon: i.icon,
                                onPressed: () {
                                  if (i.onPressed != null) {
                                    Navigator.pop(context);
                                    i.onPressed!.call();
                                  }
                                },
                              ))
                          .toList()),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
        fullscreenDialog: true,
        opaque: false,
      ),
    );
  }

  Widget buildContextMenu(List<ContextMenuItem> menuItems) => Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          boxShadow: [
            const BoxShadow(
                color: Colors.black38, blurRadius: 10, spreadRadius: 1)
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Material(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: menuItems.map(_buildContextMenuItem).toList(),
            ),
          ),
        ),
      );
  Widget _buildContextMenuItem(ContextMenuItem item) {
    if (item.icon == null && item.title == null) {
      return Divider();
    }

    return InkWell(
      onTap: item.onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 8),
            if (item.icon != null) ...[Icon(item.icon!), SizedBox(width: 8)],
            Expanded(child: Text(item.title ?? '')),
            SizedBox(width: 8)
          ],
        ),
      ),
    );
  }
}
