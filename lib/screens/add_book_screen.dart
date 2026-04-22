import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {

  final formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final author = TextEditingController();
  final isbn = TextEditingController();
  final quantity = TextEditingController();

  bool loading = false;

  Future<void> save() async {

    if(!formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    try{

      await FirebaseFirestore.instance.collection("books").add({

        "title": title.text,
        "author": author.text,
        "isbn": isbn.text,
        "quantity": int.parse(quantity.text),
        "issued": false,
        "createdAt": FieldValue.serverTimestamp()

      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book Added Successfully"))
      );

      Navigator.pop(context);

    }catch(e){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
      );

    }

    setState(() {
      loading = false;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Add Book"),
        centerTitle: true,
      ),

      body: Center(

        child: SingleChildScrollView(

          child: Container(

            width: 400,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(25),

            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0,4),
                )
              ],
            ),

            child: Form(
              key: formKey,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Icon(
                    Icons.menu_book,
                    size: 60,
                    color: Theme.of(context).primaryColor,
                  ),

                  const SizedBox(height:10),

                  Text(
                    "Add New Book",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height:25),

                  TextFormField(
                    controller: title,
                    decoration: const InputDecoration(
                      labelText: "Book Title",
                      prefixIcon: Icon(Icons.book),
                    ),
                    validator: (v)=>v!.isEmpty ? "Enter Title" : null,
                  ),

                  const SizedBox(height:15),

                  TextFormField(
                    controller: author,
                    decoration: const InputDecoration(
                      labelText: "Author",
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v)=>v!.isEmpty ? "Enter Author" : null,
                  ),

                  const SizedBox(height:15),

                  TextFormField(
                    controller: isbn,
                    decoration: const InputDecoration(
                      labelText: "ISBN Number",
                      prefixIcon: Icon(Icons.qr_code),
                    ),
                    validator: (v)=>v!.isEmpty ? "Enter ISBN" : null,
                  ),

                  const SizedBox(height:15),

                  TextFormField(
                    controller: quantity,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Quantity",
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    validator: (v)=>v!.isEmpty ? "Enter Quantity" : null,
                  ),

                  const SizedBox(height:30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton.icon(

                      onPressed: loading ? null : save,

                      icon: const Icon(Icons.save),

                      label: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Save Book",
                              style: TextStyle(fontSize:16),
                            ),

                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}