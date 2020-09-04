// the main part of the home page

import 'package:flutter/material.dart';

import 'wait.dart';
import 'package:lost/models/operation.dart';
import 'package:lost/models/person.dart';

import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';

//language support
import 'package:lost/app_localizations.dart';

class HomeData extends StatefulWidget {
  @override
  _HomeDataState createState() => _HomeDataState();
}

class _HomeDataState extends State<HomeData> {
  // the filters applied
  Map filters = {};

  List operations;
  List ages;

  @override
  void initState() {
    super.initState();
    // get the selected object
    String selectedObject =
        Provider.of<AppSettings>(context, listen: false).selectedObject;
    filters['object'] = selectedObject;

    // load the operations with the filters
    Provider.of<OperationData>(context, listen: false).loadData(filters);
  }

  @override
  Widget build(BuildContext context) {
    operations = Provider.of<OperationData>(context, listen: true).operations;

    // this for 'Person' object
    ages = Provider.of<AgeData>(context, listen: true).ages;

    // selected object now
    String selectedObject =
        Provider.of<AppSettings>(context, listen: true).selectedObject;

    return FutureBuilder(builder: (context, snapshot) {
      return operations == null
          ? wait()
          : operations.isEmpty
              ? noData(context)
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: operations.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/details', arguments: {
                          'operation': operations[index],
                          'age': selectedObject != 'Person'
                              ? null
                              : ages.firstWhere((element) =>
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
                        child: operations[index].objectType == 'Person'
                            ? DataCardPerson(
                                operation: operations[index],
                                age: ages.firstWhere((element) =>
                                    element.id ==
                                    operations[index].object.ageId),
                              )
                            : DataCardCar(
                                operation: operations[index],
                              ),
                      ),
                    );
                  },
                );
    });
  }
}

class DataCardPerson extends StatelessWidget {
  final Operations operation;
  final Age age;

  DataCardPerson({this.operation, this.age});

  @override
  Widget build(BuildContext context) {
    // photos
    List photos = operation.photos;

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
      title: Text(AppLocalizations.of(context).translate('homeData_Name') +
          '${operation.object.name}'),
      subtitle: Text(AppLocalizations.of(context).translate('homeData_Age') +
          '${age.minAge} - ${age.maxAge}'),
      isThreeLine: true,
    );
  }
}

class DataCardCar extends StatelessWidget {
  final Operations operation;

  DataCardCar({this.operation});

  @override
  Widget build(BuildContext context) {
    // photos
    List photos = operation.photos;

    return ListTile(
      leading: Hero(
        tag: operation.id.toString(),
        child: CircleAvatar(
          radius: 30,
          backgroundImage: photos == null || photos.isEmpty
              ? AssetImage(
                  'imeges/car.png',
                )
              : NetworkImage(
                  photos[0],
                ),
        ),
      ),
      title: Text('model:' + '${operation.object.model}'),
      subtitle: Text('brand' + '${operation.object.brand}'),
      isThreeLine: true,
    );
  }
}
