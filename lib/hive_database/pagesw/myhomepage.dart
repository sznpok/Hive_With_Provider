import 'package:firstapp/hive_database/client/hive_names.dart';
import 'package:firstapp/hive_database/model/todo.dart';
import 'package:firstapp/hive_database/providers/model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePageState();
  }

}
class _MyHomePageState extends State<MyHomePage>{


  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TodoProvider>(context,listen: false);
    provider.getItem();

  }

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final nameController = TextEditingController();
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //context.watch<TodoProvider>().getItem();
    var provider = Provider.of<TodoProvider>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                final snackBar = SnackBar(content: Text(
                   'All item Deleted'
                ));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                provider.deleteAll(provider.getList);
              },
              child: Text(
                'Delete All',
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
          TextButton(
            onPressed: () {
              titleController.clear();
              descriptionController.clear();
              nameController.clear();
              inputItemDialog(context, 'add',);
            },
            child: Text(
              'Add',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.white),
            child: TextField(
              controller: searchController,
              onChanged: (value){
                provider.searchItem(value);
              },
              decoration: InputDecoration(
                  hintText: 'search item',
                prefixIcon: Icon(Icons.search,),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: (){
                    provider.clearText(searchController);
                  },
                )
              ),
            ),
            //width: MediaQuery.of(context).size.width,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemCount: provider.getList.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    separatorBuilder: (c,i){
                      return Divider();
                    },
                    itemBuilder: (c, i) {
                      print(provider.getList.length);
                      return ListTileTheme(
                        tileColor: Colors.white,
                        child: ExpansionTile(
                          title: Text(
                            provider.getList[i].title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.green),
                          ),
                          trailing: Text(
                            provider.getList[i].name,
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                          subtitle: Text(provider.getList[i].description,
                              style: TextStyle(color: Colors.blue)),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      nameController.text = provider.getList[i].name;
                                      titleController.text = provider.getList[i].title;
                                      descriptionController.text =
                                          provider.getList[i].description;
                                      inputItemDialog(context, 'update', i);
                                    },
                                    child: Text('Update',
                                        style: TextStyle(color: Colors.white)),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                            Colors.green),
                                        padding:
                                        MaterialStateProperty.all<EdgeInsetsGeometry>(
                                            EdgeInsets.symmetric(
                                              horizontal: 30,
                                            ))),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      provider.deleteItem(i);
                                    },
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all<Color>(Colors.red),
                                        padding:
                                        MaterialStateProperty.all<EdgeInsetsGeometry>(
                                            EdgeInsets.symmetric(horizontal: 30))),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: Text('Data table are:',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ),
                SecondList()
              ],
            ),
          )
        ],
      ),
    );
  }

  inputItemDialog(BuildContext context, String action, [int index]) {
    var provider = Provider.of<TodoProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action == 'add' ? 'Add Item' : 'Update Item',
                        style: TextStyle(
                            fontSize: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Item name cannot be empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.grey.shade300,
                            filled: true,
                            labelText: 'Item name',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: TextFormField(
                          controller: titleController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Item Title cannot be empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Item title',
                            border: InputBorder.none,
                            fillColor: Colors.grey.shade300,
                            filled: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: TextFormField(
                          controller: descriptionController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Item Description cannot be empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Item Description',
                            border: InputBorder.none,
                            fillColor: Colors.grey.shade300,
                            filled: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              if (action == 'add') {
                                provider.addItem(Todo(
                                    title: titleController.text,
                                    description: descriptionController.text,
                                    name: nameController.text));
                              } else {
                                provider.updateItem(
                                    index,
                                    Todo(
                                        name: nameController.text,
                                        title: titleController.text,
                                        description:
                                            descriptionController.text));
                              }
                              nameController.clear();
                              descriptionController.clear();
                              titleController.clear();
                              provider.getItem();
                              Navigator.pop(context);
                            }
                          },
                          child: Text(action == 'add' ? 'Add' : 'Update'),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class SecondList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TodoProvider>(context);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: DataTable(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        columns: [
          DataColumn(
            label: Text('Name',  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text('Title',  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text('Description',  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
        rows: provider.getList.map((list) {
         return  DataRow(
            cells: [
              DataCell(Text(list.name)),
              DataCell(Text(list.title)),
              DataCell(Text(list.description)),
            ],
          );
        }).toList()
    ),
      );
  }
}

