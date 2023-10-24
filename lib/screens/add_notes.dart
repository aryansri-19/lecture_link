import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lecture_link/widgets/snack_bar.dart';
import 'dart:io';

import '../utils/colors.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  List<File>? files;
  Future<void> uploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'png', 'jpg', 'jpeg'],
          allowMultiple: true);
      if (result != null) {
        setState(() {
          files = result.paths.map((path) => File(path!)).toList();
        });
      }
    } catch (e) {
      showSnackBar(context, "Error occured, try again");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: files != null
            ? Scaffold(
                appBar: AppBar(
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [bannerBackground, bannerBackground2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        files = null;
                      });
                    },
                  ),
                  actions: [
                    TextButton(
                      child: const Text(
                        'Add',
                        style: TextStyle(fontSize: 17),
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
                body: Container(
                    child: files!.isNotEmpty
                        ? Row(children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: files!.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                        title: Text(
                                            files![index].path.split('/').last),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            setState(() {
                                              files!.removeAt(index);
                                            });
                                          },
                                        ));
                                  }),
                            ),
                          ])
                        : const Center(child: Text("Nothing to upload"))),
              )
            : Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.45),
                alignment: Alignment.center,
                child: Column(children: [
                  IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    icon: const Icon(
                      Icons.upload,
                      size: 50,
                    ),
                    onPressed: uploadFile,
                  ),
                  const Text(
                    'Upload Notes',
                    style: TextStyle(fontSize: 20),
                  ),
                ])));
  }
}
