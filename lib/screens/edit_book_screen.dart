import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBookScreen extends StatefulWidget {

  final Map book;

  const EditBookScreen({
    super.key,
    required this.book,
  });

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {

  final formKey = GlobalKey<FormState>();

  late TextEditingController title;
  late TextEditingController author;
  late TextEditingController isbn;
  late TextEditingController quantity;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    title = TextEditingController(text: widget.book["title"]);
    author = TextEditingController(text: widget.book["author"]);
    isbn = TextEditingController(text: widget.book["isbn"]);
    quantity =
        TextEditingController(text: widget.book["quantity"].toString());
  }

  // 🔥 UPDATE BOOK IN FIRESTORE
  Future<void> updateBook() async {

    if (!formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    try {

      await FirebaseFirestore.instance
          .collection("books")
          .doc(widget.book["id"])
          .update({

        "title": title.text.trim(),
        "author": author.text.trim(),
        "isbn": isbn.text.trim(),
        "quantity": int.parse(quantity.text),

      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book Updated Successfully")),
      );

      Navigator.pop(context, true);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
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
        title: const Text("Edit Book"),
      ),

      body: Center(

        child: SingleChildScrollView(

          child: Container(

            width: 400,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(25),

            decoration: BoxDecoration(
              color: Colors.white,
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

                  const Icon(
                    Icons.edit,
                    size: 60,
                    color: Colors.blue,
                  ),

                  const SizedBox(height:10),

                  const Text(
                    "Update Book",
                    style: TextStyle(
                      fontSize:20,
                      fontWeight: FontWeight.bold,
                    ),
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

                      onPressed: loading ? null : updateBook,

                      icon: const Icon(Icons.update),

                      label: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Update Book"),

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