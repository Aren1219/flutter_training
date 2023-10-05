import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training/components/my_button.dart';
import 'package:training/components/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:training/dialog/dialog_util.dart';
import 'package:training/screens/home/categories.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class CreateCategory extends ConsumerWidget {
  CreateCategory({super.key});

  final nameController = TextEditingController();
  final idController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create Category"),
          //backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              MyTextField(
                textInputAction: TextInputAction.next,
                controller: idController,
                hint: 'Category Id',
              ),
              const SizedBox(height: 12),
              MyTextField(
                textInputAction: TextInputAction.done,
                controller: nameController,
                hint: 'Category Name',
                onSubmitted: (value) => onSubmit(context, ref),
              ),
              const SizedBox(height: 36),
              MyButton(
                onTap: () => onSubmit(context, ref),
                text: "Create",
              ),
              const SizedBox(height: 36),
            ],
          ),
        ));
  }

  void onSubmit(BuildContext context, WidgetRef ref) => createCategory(context, ref);

  void createCategory(BuildContext context, WidgetRef ref) async {
    DialogUtil.showLoading(context, content: 'Creating Category');
    final user = FirebaseAuth.instance.currentUser!;
    CollectionReference category = FirebaseFirestore.instance.collection('categories-${user.uid}');
    category.add({
      'name': nameController.text, // John Doe
      'id': idController.text
    }).then((value) {
      print("Category Added");
      navService.pop();
      DialogUtil.showSnackBar(context, "Category created successfully");
    }).catchError((error) {
      print("Failed to add user: $error");
      navService.pop();
    });
  }
}
