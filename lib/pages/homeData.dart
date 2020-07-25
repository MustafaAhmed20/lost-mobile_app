// the main part of the home page

import 'package:flutter/material.dart';

import 'wait.dart';
import 'package:lost/models/operation.dart';
import 'package:lost/models/person.dart';

import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';

class HomeData extends StatefulWidget {
  @override
  _HomeDataState createState() => _HomeDataState();
}

class _HomeDataState extends State<HomeData> {
  // the filters applied
  Map filters = {};

  List operations;
  List ages;

  String server;

  @override
  void initState() {
    super.initState();

    // load the operations with the filters
    Provider.of<OperationData>(context, listen: false).loadData(filters);
    server = Provider.of<AppData>(context, listen: false).serverAddress;
  }

  @override
  Widget build(BuildContext context) {
    operations = Provider.of<OperationData>(context, listen: true).operations;

    ages = Provider.of<AgeData>(context, listen: true).ages;

    return FutureBuilder(builder: (context, snapshot) {
      return operations == null
          ? wait()
          : operations.isEmpty
              ? noData()
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: operations.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/details', arguments: {
                          'operation': operations[index],
                          'age': ages.firstWhere((element) =>
                              element.id == operations[index].object.ageId)
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.purple[800],
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DataCard(
                          operation: operations[index],
                          age: ages.firstWhere((element) =>
                              element.id == operations[index].object.ageId),
                        ),
                      ),
                    );
                  },
                );
    });
  }
}

class DataCard extends StatelessWidget {
  final Operations operation;
  final Age age;

  DataCard({this.operation, this.age});

  @override
  Widget build(BuildContext context) {
    // photos
    List photos = operation.object.photos;

    return ListTile(
      leading: Hero(
        tag: operation.id.toString(),
        child: CircleAvatar(
          radius: 30,
          backgroundImage: photos == null || photos.isEmpty
              ? AssetImage(
                  'imeges/profile.png',
                )
              : NetworkImage(
                  photos[0],
                ),
        ),
      ),
      title: Text('Name: ${operation.object.name}'),
      subtitle: Text('Age: ${age.minAge} - ${age.maxAge}'),
      isThreeLine: true,
    );
  }
}
