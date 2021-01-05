import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungfunny/models/ebook_model.dart';
import 'package:ungfunny/states/read_ebook.dart';

class ShowEbook extends StatefulWidget {
  @override
  _ShowEbookState createState() => _ShowEbookState();
}

class _ShowEbookState extends State<ShowEbook> {
  List<Widget> widgets = List();
  List<EbookModel> ebookModels = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      // print('initialWorkd');
      await FirebaseFirestore.instance
          .collection('ebook')
          .snapshots()
          .listen((event) {
        // print('event ==>> ${event.toString()}');
        int index = 0;
        for (var snapshot in event.docs) {
          // print('name11 = ${snapshot.data()['name']}');
          EbookModel model = EbookModel.fromMap(snapshot.data());
          print('name = ${model.name}');
          setState(() {
            widgets.add(createWidget(model, index));
            ebookModels.add(model);
          });
          index++;
        }
      });
    });
  }

  Widget createWidget(EbookModel model, int index) {
    return GestureDetector(
      onTap: () {
        print('You Click eBook => ${ebookModels[index].name}');
        dilogConfirm(ebookModels[index]);
      },
      child: Card(
        child: Container(padding: EdgeInsets.all(8),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(margin: EdgeInsets.only(bottom: 16),
                width: 80,
                height: 100,
                child: Image.network(model.cover),
              ),
              Text(
                shortName(model.name),
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets.length == 0
          ? CircularProgressIndicator()
          : GridView.extent(
              maxCrossAxisExtent: 220,
              children: widgets,
            ),
    );
  }

  String shortName(String name) {
    String string = name;
    if (string.length >= 50) {
      string = string.substring(0, 50);
      string = '$string ...';
    }
    return string;
  }

  Future<Null> dilogConfirm(EbookModel ebookModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: Image.asset('images/logo.png'),
          title: Text('Do you want to read eBook ?'),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.network(ebookModel.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(ebookModel.name),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReadPdf(ebookModel: ebookModel,),
                        ));
                  },
                  child: Text('Read Ebook')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
            ],
          ),
        ],
      ),
    );
  }
}
