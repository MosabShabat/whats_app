import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../controller/select_contant_controller.dart';

class SelectContactsScreen extends StatelessWidget {
  static const routeName = '/select-contact';

  const SelectContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SelectContactController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: 'Select contact'.text.white.size(20).make(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: FutureBuilder(
        future: controller.getContacts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: "No Contacts yet!".text.white.size(30).make(),
            );
          } else {
            return SingleChildScrollView(
              child: SizedBox(
                width: size.width,
                // height: size.height,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final contact = snapshot.data![index];
                    return InkWell(
                      onTap: () {
                        controller.selectContact(contact);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: ListTile(
                          leading: contact.photo == null
                              ? null
                              : CircleAvatar(
                                  radius: 30,
                                  backgroundImage: MemoryImage(contact.photo!),
                                ),
                          title: Text(
                            contact.displayName,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
