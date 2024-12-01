import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:new_todolist/components/button.dart';
import 'package:new_todolist/components/taksfield.dart';




class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  //for work with fire store
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;
  Stream<QuerySnapshot>? _todos;



 // sign out
  void UserSingOut(){
    FirebaseAuth.instance.signOut();
  }


  // for sort and filter
  bool _isSorted = false;
  bool _isFilted = false;


  //update list with tasks
  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  // create tasks' list and a sorted list and a filted list
  void _fetchTodos() {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);

    var query = db.collection('my-todolist').where('email', isEqualTo: user.email);

    // for filter
    if (_isFilted == true) {
      print(startOfDay);
      print(user.email);
      query = query.where('data', isGreaterThan: startOfDay);
    }

    // for sorted
    if (_isSorted==true) {
      query = query.orderBy('name', descending: true);
    }

    _todos = query.snapshots();
  }

  //for data selectDate for tasks
  String? value;
  DateTime? myselectedDate;
  Future<void> _selectDate() async {
    DateTime? _picket = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2050),
    );

    if(_picket != null){
      setState(() {
        myselectedDate=_picket;
        dateController.text=_picket.toString().split(" ")[0];
      });
    }

  }

  // list checkboxs
  List<bool> _checkedItems = [];


  //user sings out


  // controllers for tasks' fields
  final nameController = TextEditingController();
  final mydescriptionController = TextEditingController();
  final dateController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: FloatingActionButton(
          backgroundColor: Colors.red[300],
          onPressed: () {
            //click on bottom for creating or updating task
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return showBottomSheet(context, false, null);
              },
            );
          },
          child: const Icon(
            Icons.add,
            color: Color(0xFFF6ECEC),
            size: 35,
          ),
        ),
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Color(0xFFB6B6B6),
          leading: IconButton(// sing out user
            onPressed: UserSingOut,
            icon: Icon(Icons.arrow_back_ios_outlined),
            color: Colors.grey[100],
          ) ,
          title: Text('Tasks',
            style: TextStyle(
                fontSize: 24,
                color: Colors.grey[100],
                fontWeight: FontWeight.bold
            ),),
          actions: [
          IconButton(// button for sort
            icon: Icon( _isSorted ? Icons.sort : Icons.arrow_downward),
            color: Colors.white,
            onPressed: () {
              setState(() {
                _isSorted = !_isSorted;
                _fetchTodos();
              });
            },
          ),
            IconButton(// button for filter
              icon: Icon( _isFilted ? Icons.filter_alt : Icons.filter_alt_off_rounded),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  _isFilted = !_isFilted;
                  _fetchTodos();
                });
              },
            ),
          ],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [// stream for snapshot from fire store
                StreamBuilder<QuerySnapshot>(
                    stream: _todos,
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return   Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 30,),
                                Text('No data found')],
                            )
                           );

                      }

                      //checkboxs
                      // Инициализируем список чекбоксов
                      if (_checkedItems.length != snapshot.data!.docs.length) {
                        _checkedItems = List.generate(snapshot.data!.docs.length,
                                (index) => snapshot.data!.docs[index]['checked'] ?? false);
                      }


                      return    Container(
                        height: MediaQuery.of(context).size.height * 0.95,
                        child:  ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, int index) {
                              DocumentSnapshot documentSnapshot = snapshot.data.docs[index];

                              //data to timestamp
                              final Timestamp timestamp = documentSnapshot['data'];
                              final DateTime dateTime = timestamp.toDate();
                              final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

                              return ListTile(
                                leading: Checkbox(
                                  value:  _checkedItems[index],
                                  activeColor: Color.fromRGBO(250, 128, 114, 1),
                                  onChanged: (newBool){
                                    setState(() {
                                      _checkedItems[index] = newBool!;

                                      // update in fire store
                                      db.collection('my-todolist').doc(documentSnapshot.id).update({
                                        'checked': newBool,
                                      });
                                    });
                                  },
                                ),
                                title: Text(documentSnapshot['name'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(documentSnapshot['mydescription']),
                                    Text(formattedDate,
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),

                                //click on tasks gor updating task
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return showBottomSheet(context, true, documentSnapshot);
                                    },
                                  );
                                },
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Color.fromRGBO(250, 128, 114, 1),
                                  ),
                                  onPressed: () {
                                    //click delete-button for delete task
                                    db.collection('my-todolist').doc(documentSnapshot.id).delete();
                                  },
                                ),
                              );
                            }),
                      );



                    }),

              ],
            ),
          ),

        ),



    );
  }



// botton for create or update task
  Widget showBottomSheet( BuildContext context, bool isUpdate, DocumentSnapshot? documentSnapshot) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [

          MyTaskField(
              controller: nameController,
              mylabelText: isUpdate ? "Update Name" : "Name",
              hintText: "Enter a name"),

          SizedBox(height: 20,),

          MyTaskField(
              controller: mydescriptionController,
              mylabelText:  isUpdate ? 'Update Description' : "Description",
              hintText: "Enter a description"),

          SizedBox(height: 20,),

          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText:  isUpdate ? "Update Date" :"Date",
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none
                  ),

                  hintStyle: TextStyle(
                    color: Color(0xFFB6B6B6),
                    fontWeight: FontWeight.bold,
                  ),

                ),
                readOnly: true,
                onTap: (){
                  _selectDate();
                },
              ),
            ),
          ),

          SizedBox(height: 30,),

          TextButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Color.fromRGBO(250, 128, 114, 1))),
              onPressed: () {
                Timestamp timestamp = Timestamp.fromDate(myselectedDate!);


                // if isUpdate is true then update the value else add the task
                // !!!  user should rewrite ALL fields
                if (isUpdate) {
                  db.collection('my-todolist').doc(documentSnapshot?.id).update({
                    'name': nameController.text,
                    'mydescription':mydescriptionController.text,
                    'email':user.email,
                    'data':timestamp
                  });

                  nameController.clear();
                  mydescriptionController.clear();
                  dateController.clear();

                } else {
                  db.collection('my-todolist').add({'name': nameController.text,'mydescription':mydescriptionController.text,'email':user.email,'data':timestamp,'checked':false});
                  nameController.clear();
                  mydescriptionController.clear();
                  dateController.clear();
                }
                Navigator.pop(context);
              },
              child: isUpdate
                  ? const Text(
                'UPDATE',
                style: TextStyle(color: Colors.white),
              )
                  : const Text('ADD', style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }



}





