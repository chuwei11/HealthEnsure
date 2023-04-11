import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthensure/utils/config.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {Key? key, this.title, this.route, this.icon, this.actions})
      : super(key: key);

  final String? title;
  final String? route;
  final FaIcon? icon;
  final List<Widget>? actions;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Color.fromARGB(255, 238, 238, 238),
      elevation: 0.0,
      centerTitle: true,
      title: Text(widget.title!,
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
      leading: widget.icon != null
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Config.primaryColor,
              ),
              child: IconButton(
                onPressed: () {
                  // if route given, icon button navigate to the route
                  if (widget.route != null) {
                    Navigator.of(context).pushNamed(widget.route!);
                  }
                  // else pop back to prev page
                  else {
                    Navigator.of(context).pop();
                  }
                },
                icon: widget.icon!,
                iconSize: 15,
                color: Colors.white60,
              ),
            )
          // return null if the icon not set
          : null,
      // return null if actions not set
      actions: widget.actions ?? null,
    );
  }
}
