import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:nibbles/constants/icons.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/controllers/notification_controller.dart';
import 'package:nibbles/models/notification_model.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import 'package:nibbles/views/widgets/loading.dart';
import 'package:nibbles/views/widgets/no_data.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'components/notifications_tile.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: SizeConfig.heightMultiplier * 5,
            ),
            Text(
              "Activity",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.textMultiplier * 3.8),
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 3,
            ),
            Expanded(
                child: PaginateFirestore(
                    query: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(Get.find<AuthController>().userss!.uid)
                        .collection("Notifications")
                        .orderBy("Date", descending: true),
                    itemBuilderType: PaginateBuilderType.listView,
                    padding: EdgeInsets.zero,
                    onEmpty: NoDataWidget(
                        noDataText: "No Activity Yet!",
                        height: SizeConfig.heightMultiplier * 65),
                    itemBuilder: (_, snap, i) {
                      var data =
                          NotificationModel.fromDocumentSnapshot(snap[i]);
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: SizeConfig.heightMultiplier * 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NotificationTile(
                              icon: data.type == "reward"
                                  ? reward
                                  : data.type == "like"
                                      ? heart
                                      : data.type == "update"
                                          ? pencil
                                          : data.type == "reserve"
                                              ? reservation
                                              : data.type == "community"
                                                  ? community
                                                  : data.type ?? "",
                              title: data.title ?? "",
                              subtitle: data.body ?? "",
                              time: timeago.format(data.date!),
                            ),
                          ],
                        ),
                      );
                    })),
            SizedBox(
              height: SizeConfig.heightMultiplier * 7,
            )
          ],
        ),
      ),
    );
  }
}
