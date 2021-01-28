import 'package:firstapp/homepage/model/fakemodel.dart';
import 'package:firstapp/homepage/presentation/secondPage.dart';
import 'package:firstapp/homepage/services/Services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    final model = Provider.of<Services>(context,listen: false);
    model.getApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<Services>(context);

    return Scaffold(
        appBar: AppBar(
         leading:  IconButton(icon: Icon(Icons.add,size:30),onPressed: (){
          // Navigator.push(context, MaterialPageRoute(builder: (BuildContext cxt)=> new ThirdPage()));
         },)
        ),
        body:provider.listData==null?Center(
          child: CircularProgressIndicator(),
        ): Column(
          children: [
            Container(
              height: 50,
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: provider.listData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (c,i){
                  return Container(
                    child: Center(child: Text(provider.listData[i].id.toString(),style: TextStyle(fontSize: 18),),),
                  );
                },),
            ),
            Divider(),
            Expanded(
                child: SecondPage(),
            ),

          ],
        )

    );
  }
}
