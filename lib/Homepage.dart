// ignore_for_file: file_names, non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'BiodataService.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Biodataservice? service;
  String? selectedDocId;

  @override
  void initState() {
    super.initState();
    service = Biodataservice(FirebaseFirestore.instance);
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void _addOrUpdateBiodata() async {
    String name = nameController.text.trim();
    String age = ageController.text.trim();
    String address = addressController.text.trim();

    if (name.isEmpty || age.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields must be filled')),
      );
      return;
    }

    if (selectedDocId != null) {
      // Update data jika ada selectedDocId
      await service?.update(selectedDocId!, {
        'name': name,
        'age': age,
        'address': address,
      });
      selectedDocId = null;
    } else {
      // Tambah data baru jika selectedDocId null
      await service?.add({'name': name, 'age': age, 'address': address});
    }

    // Bersihkan input setelah menambah/memperbarui
    nameController.clear();
    ageController.clear();
    addressController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Form Biodata",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(hintText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(hintText: 'Address'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder(
                  stream: service?.getBiodata(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.none) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData ||
                        snapshot.data?.docs.isEmpty == true) {
                      return const Center(child: Text('No data available'));
                    }
                    final documents = snapshot.data?.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: documents?.length,
                      itemBuilder: (context, index) {
                        final docId = documents?[index].id;
                        final data = documents?[index].data();

                        return ListTile(
                          title: Text(data?['name'] ?? 'No Name'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Age: ${data?['age'] ?? 'N/A'}'),
                              Text('Address: ${data?['address'] ?? 'N/A'}'),
                            ],
                          ),
                          onTap: () {
                            nameController.text = data?['name'] ?? '';
                            ageController.text = data?['age'] ?? '';
                            addressController.text = data?['address'] ?? '';
                            selectedDocId = docId;
                          },
                          trailing: IconButton(
                            onPressed: () {
                              if (docId != null) {
                                service?.delete(docId);
                              }
                            },
                            icon: const Icon(Icons.delete),
                          ),
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
        onPressed: _addOrUpdateBiodata,
        child: const Icon(Icons.add),
      ),
    );
  }
}