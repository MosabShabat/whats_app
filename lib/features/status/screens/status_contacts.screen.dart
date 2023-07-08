import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/features/status/screens/status_screen.dart';
import 'package:whats_app/models/status_model.dart';

import '../../../constants/colors.dart';
import '../controller/status_controller.dart';

class StatusContactsScreen extends StatelessWidget {
  const StatusContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(StatusController());
    print('========i here 11========');
    return FutureBuilder<List<Status>>(
      future: controller.getStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        print('========i here 12========');
        print(snapshot.data!.length);
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var statusData = snapshot.data![index];
            print('========i here========');
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => StatusScreen(status: statusData),
                        transition: Transition.downToUp);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        statusData.username,
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          statusData.profilePic,
                        ),
                        radius: 30,
                      ),
                    ),
                  ),
                ),
                const Divider(color: dividerColor, indent: 85),
              ],
            );
          },
        );
      },
    );
  }
}
