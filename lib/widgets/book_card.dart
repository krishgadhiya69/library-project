import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {

  final Map book;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BookCard({
    super.key,
    required this.book,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.all(10),

      child: ListTile(

        title: Text(book["title"]),

        subtitle: Text(book["author"]),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(book["issued"] ? "Issued" : "Available"),

            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),

            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            )

          ],
        ),

      ),
    );
  }
}