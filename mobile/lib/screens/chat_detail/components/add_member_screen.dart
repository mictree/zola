import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  List<dynamic> users = [
    {"name": "Bob", "id": "1"},
    {"name": "Bob", "id": "2"},
    {"name": "Bob", "id": "3"},
    {"name": "Bob", "id": "4"},
    {"name": "Bob", "id": "5"},
    {"name": "Bob", "id": "6"},
  ];
  List<dynamic> selectedUsers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm thành viên"),
        actions: [
          IconButton(
            onPressed: () {
				context.pop();
			},
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //search bar
              SizedBox(
				height: 50.0,
				child: TextField(
				  decoration: InputDecoration(
					hintText: 'Tìm kiếm',
					prefixIcon: const Icon(Icons.search),
					border: OutlineInputBorder(
					  borderRadius: BorderRadius.circular(10.0),
					),
				  ),
				  onSubmitted: (String query) {
					// Thực hiện tìm kiếm với query
				  },
				),
			  ),

              //List of user to add
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Theme(
                      data: ThemeData(
                        unselectedWidgetColor: Colors.white,
                      ),
                      child: CheckboxListTile(
                        title: Text(
                          user["name"],
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        checkColor: Colors.black,
                        activeColor: Colors.white,
                        value: selectedUsers.contains(user),
                        secondary: CircleAvatar(
                          child: Text(user["name"]),
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedUsers.add(user);
                            } else {
                              selectedUsers.remove(user);
                            }
                          });
                        },
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
