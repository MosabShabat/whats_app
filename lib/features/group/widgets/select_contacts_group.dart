import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../select_contant/controller/select_contant_controller.dart';
import '../controller/group_controller.dart';

final selectedGroupContacts = Rx<List<Contact>>([]);

class SelectContactsGroup extends StatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  State<SelectContactsGroup> createState() => _SelectContactsGroupState();
}

class _SelectContactsGroupState extends State<SelectContactsGroup> {
  var controller = Get.put(SelectContactController());
  var Groupcontroller = Get.put(GroupController());

  List<int> selectedContactsIndex = [];

  void selectContact(int index, Contact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    selectedGroupContacts.update((state) => [...?state, contact]);

    // ref
    //     .read(selectedGroupContacts.state)
    //     .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FutureBuilder(
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
          return Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final contact = snapshot.data![index];
                    return InkWell(
                      onTap: () {
                        selectContact(index, contact);
                        //  controller.selectContact(contact);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: ListTile(
                          leading: selectedContactsIndex.contains(index)
                              ? IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.done),
                                )
                              : null,
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
            ),
          );
        }
      },
    );
  }
}
