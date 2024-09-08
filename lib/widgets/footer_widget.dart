import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color.fromARGB(197, 162, 208, 225),
        child: Row(
          children: [
            // Column for text items
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text("Privacy Policy",
                      style: TextStyle(color: Colors.black)),
                ),
                SizedBox(width: 16), // Space between items
                TextButton(
                  onPressed: () {},
                  child: Text("Terms of Service",
                      style: TextStyle(color: Colors.black)),
                ),
                SizedBox(width: 16), // Space between items
                TextButton(
                  onPressed: () {},
                  child:
                      Text("Contact Us", style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            Spacer(), // Pushes the copyright notice to the right
            Text(
              '© 2024 TransitFlow. All Rights Reserved.',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
