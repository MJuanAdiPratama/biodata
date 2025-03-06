// ignore_for_file: unused_import, annotate_overrides
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'BiodataService.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // panggil model
  Biodataservice? service;

  @override
  void initState() {
    service = Biodataservice(FirebaseFirestore.instance);
    super.initState();
  }

  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final addresController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(hintText: 'Age'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: addresController,
                decoration: const InputDecoration(hintText: 'Address'),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: service?.getBiodata(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.none) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError){
                      return Text('Error fetching data: ${snapshot.data}');
                    } else if (snapshot.hasData && snapshot.data?.docs.isEmpty == true) {
                      return const Center(child: Text('Empty document'));
                    }
                    final documents = snapshot.data?.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: documents?.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title:  Text(documents?[index] ['name']),
                          subtitle: Text(documents?[index] ['age']),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // ignore: non_constant_identifier_names
          final Name = nameController.text.trim();
          // ignore: non_constant_identifier_names
          final Age = ageController.text.trim();
          // ignore: non_constant_identifier_names
          final Addres = addresController.text.trim();

          service?.add({'name': Name, 'age': Age, 'addres': Addres});
        },
      ),
    );
  }
}
