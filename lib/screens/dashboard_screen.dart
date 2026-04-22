import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_book_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  List books = [];
  List filteredBooks = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  // LOAD BOOKS
  Future<void> loadBooks() async {

    final snapshot =
        await FirebaseFirestore.instance.collection("books").get();

    books = snapshot.docs.map((doc) {
      var data = doc.data();
      data["id"] = doc.id;
      return data;
    }).toList();

    filteredBooks = books;

    setState(() {
      loading = false;
    });
  }

  // DELETE BOOK
  Future<void> deleteBook(int index) async {

    await FirebaseFirestore.instance
        .collection("books")
        .doc(books[index]["id"])
        .delete();

    loadBooks();
  }

  // ISSUE BOOK
  Future<void> toggleIssue(int index) async {

    bool newStatus = !books[index]["issued"];

    await FirebaseFirestore.instance
        .collection("books")
        .doc(books[index]["id"])
        .update({
      "issued": newStatus
    });

    loadBooks();
  }

  // LOGOUT
  Future<void> logout() async {

    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, "/login");
  }

  // SEARCH
  void searchBook(String value) {

    setState(() {

      filteredBooks = books.where((book) {

        return book["title"]
            .toString()
            .toLowerCase()
            .contains(value.toLowerCase());

      }).toList();

    });
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    return Scaffold(

      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6366F1),
        title: const Text("📚 Library Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6366F1),
        onPressed: () async {

          await Navigator.pushNamed(context, "/addBook");
          loadBooks();
        },
        child: const Icon(Icons.add),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [

          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              onChanged: searchBook,
              decoration: InputDecoration(
                hintText: "Search books...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 📦 GRID VIEW
          Expanded(
            child: GridView.builder(

              padding: const EdgeInsets.all(20),

              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                crossAxisCount: width > 1200
                    ? 4
                    : width > 900
                    ? 3
                    : width > 600
                    ? 2
                    : 1,

                crossAxisSpacing: 15,
                mainAxisSpacing: 15,

                // 🔥 FIXED HEIGHT (NO OVERFLOW)
                mainAxisExtent: width < 600 ? 230 : 200,
              ),

              itemCount: filteredBooks.length,

              itemBuilder: (context, i) {

                final b = filteredBooks[i];

                return Container(

                  padding: const EdgeInsets.all(15),

                  decoration: BoxDecoration(

                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: const Offset(0,5),
                      )
                    ],

                  ),

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      // TITLE
                      Text(
                        b["title"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // DETAILS
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Author: ${b["author"] ?? ""}"),
                          Text("ISBN: ${b["isbn"] ?? ""}"),
                          Text("Quantity: ${b["quantity"] ?? ""}"),
                        ],
                      ),

                      // STATUS + ACTIONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5
                              ),
                              decoration: BoxDecoration(
                                color: b["issued"]
                                    ? Colors.red.shade100
                                    : Colors.green.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                b["issued"] ? "Issued" : "Available",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: b["issued"]
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            ),
                          ),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              IconButton(
                                icon: const Icon(Icons.swap_horiz, size: 20),
                                onPressed: () => toggleIssue(i),
                              ),

                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () async {

                                  final updated =
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditBookScreen(book: b),
                                    ),
                                  );

                                  if(updated != null){
                                    loadBooks();
                                  }

                                },
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                onPressed: () => deleteBook(i),
                              ),

                            ],
                          )

                        ],
                      )

                    ],
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}