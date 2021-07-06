import 'package:flutter/material.dart';
import 'package:http_demo/models/issue.dart';
import 'package:http_demo/utils/color.dart';
import 'package:http_demo/utils/constant.dart';
import 'package:http_demo/utils/system.dart';


Widget buildItem(BuildContext context, Issue issue) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ],
    ),
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader(context, issue),
        SizedBox(height: 8),
        Container(height: 1, color: colorSperator),
        SizedBox(height: 4),
        buildContent(context, issue),
        SizedBox(height: 4),
        buildGridImages(context, issue),
      ],
    ),
  );
}

Widget buildHeader(BuildContext context, Issue issue) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      buildAvatar(context, issue.accountPublic!.avatar),
      SizedBox(width: 10),
      Expanded(
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: issue.createdBy,
              style: TextStyle(color: colorGrey),
            ),
            TextSpan(text: "\n"),
            TextSpan(
              text: issue.createdAt,
              style: TextStyle(color: colorGrey1),
            )
          ]),
        ),
      ),
      Column(
        children: [
          buildStatus(issue.status),
          Text(""),
          Text(""),
        ],
      )
    ],
  );
}

Widget buildAvatar(BuildContext context, String? url) {
  if(url == null || url.isEmpty) {
    url = defaultAvatar;
  }
  else {
    url = baseUrl + url;
  }

  return ClipRRect(
    borderRadius: BorderRadius.circular(500),
    child: Container(
      width: 48,
      height: 48,
      child: Image.network(url, fit: BoxFit.cover),
    ),
  );
}

Widget buildStatus(int? status) {
  switch (status) {
    case 0:
      {
        return Text("Đang chờ", style: TextStyle(color: Colors.grey));
      }
    case 1:
      {
        return Text("Đang xử lý", style: TextStyle(color: Colors.blue));
      }
    case 2:
      {
        return Text("Đã xong", style: TextStyle(color: Colors.green));
      }
    case 3:
      {
        return Text("Huỷ bỏ", style: TextStyle(color: Colors.red));
      }
    case 4:
      {
        return Text("Không duyệt", style: TextStyle(color: Colors.red));
      }
    default:
      {
        return Text("");
      }
  }
}

Widget buildContent(BuildContext context, Issue issue) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        issue.title ?? "",
        style: TextStyle(color: colorGrey, fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 8),
      Text(
        issue.content ?? "",
        style: TextStyle(color: colorGrey),
      ),
    ],
  );
}

Widget buildGridImages(BuildContext context, Issue issue) {
  if (issue.photos == null || issue.photos!.isEmpty) {
    return SizedBox(height: 0);
  }

  int showNum = issue.photos!.length >= 4 ? 4 : issue.photos!.length;
  int colNum = showNum == 4 ? 2 : showNum;

  double itemWidth = getScreenWidth(context) / colNum;
  double itemHeight = getScreenWidth(context) * 2 / 3;

  if (showNum == 4) {
    itemHeight = itemWidth;
  }

  return GridView.builder(
    padding: EdgeInsets.zero,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: colNum,
      childAspectRatio: itemWidth / itemHeight,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
    ),
    itemBuilder: (ctx, index) {
      return buildImages(ctx, issue, index);
    },
    itemCount: showNum,
    shrinkWrap: true,
    primary: false,
  );
}

Widget buildImages(BuildContext context, Issue issue, int index) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(baseUrl + issue.photos![index]),
        fit: BoxFit.cover,
      ),
    ),
    child: issue.photos!.length > 4 && index == 3
        ? Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: Text(
                "+${issue.photos!.length - 4}",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
            ),
          )
        : null,
  );
}
