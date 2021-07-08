import 'package:flutter/material.dart';
import 'package:http_demo/utils/color.dart';

void showValueBottomSheet({
  required BuildContext context,
  String? title,
  required List<String> values,
  Function(int, String)? onSelected,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return _Modal(
        title: title,
        values: values,
        onSelected: onSelected,
      );
    }, // From with TextField inside
  );
}

class _Modal extends StatelessWidget {
  final String? title;
  final List<String> values;
  final Function(int, String)? onSelected;

  const _Modal({Key? key, this.title, required this.values, this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - 200,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              buildListView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Visibility(
      visible: title != null && title!.isNotEmpty,
      child: Container(
        height: 50,
        color: Colors.grey[100],
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Text(
              title ?? '',
              style: TextStyle(fontSize: 16, color: colorGrey),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListView() {
    return ListView.separated(
      itemBuilder: (context, index) {
        final value = values[index];
        return GestureDetector(
          onTap: () {
            if (onSelected != null) {
              onSelected!(index, value);
            } else {
              Navigator.of(context).pop();
            }
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Center(child: Text(value)),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(),
      itemCount: values.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
    );
  }
}
