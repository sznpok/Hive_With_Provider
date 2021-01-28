import 'package:firstapp/homepage/model/fakemodel.dart';
import 'package:firstapp/homepage/services/Services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SecondPage extends StatelessWidget{



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Services>(context);
    return ListView.builder(
      shrinkWrap: true,
      itemCount:provider.listData.length,itemBuilder: (c,i){
        return ListTile(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext cxt)=> new ThirdPage(provider.listData[i],i)));
          },
          title: Text(provider.listData[i].title),
          subtitle: Text(provider.listData[i].id.toString()),
        );
      },
    );
  }
}

class ThirdPage extends StatelessWidget{

  final int index;
  Datas datas;

  ThirdPage(this.datas,this.index);
  final text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Services>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Container(
             height: 50,
             width: MediaQuery.of(context).size.width,
             child: TextField(
               controller: TextEditingController(text: provider.listData[index].title),
               onChanged: (value){
                 provider.setText(value, index);
               },
               decoration: InputDecoration(
                 fillColor: Colors.grey,
                 suffixIcon: IconButton(
                   icon: Icon(Icons.cancel),
                   onPressed: (){
                     provider.clear(index);
                   },
                 )
               ),
             ),
           ),

            Center(
              child: IconButton(
                color: Colors.blue,
                  iconSize: 40,
                  icon: Icon(Icons.add), onPressed: (){
              provider.setId(index);
            }),),
            SizedBox(height: 20,),
           Center(
             child:  Text(provider.listData[index].id.toString(),style: TextStyle(fontSize: 20),),
           )
          ],
        ),
      ),
    );
  }
}