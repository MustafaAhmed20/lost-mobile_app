// the main part of the home page

import 'package:flutter/material.dart';

import 'wait.dart';
import 'package:lost/models/operation.dart';
import 'package:lost/models/person.dart';

import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';

//language support
import 'package:lost/app_localizations.dart';

import 'package:intl/intl.dart';

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

    if (operations == null) {
      operations = [];
    }

    bool isLoading =
        Provider.of<OperationData>(context, listen: true).isLoading;

    // this for 'Person' object
    ages = Provider.of<AgeData>(context, listen: true).ages;

    // selected object now
    String selectedObject =
        Provider.of<AppSettings>(context, listen: true).selectedObject;

    return RefreshIndicator(
      onRefresh: () {
        return Provider.of<OperationData>(context, listen: false).reLoad({});
      },
      child: isLoading
          ? wait(context)
          : operations.isEmpty
              ? ListView(
                  // use list view to be able to refrsh with pull
                  children: [noData(context)],
                )
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
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                              vertical: BorderSide(
                            color: Colors.grey,
                            width: 0.2,
                          )),
                        ),
                        child: operations[index].objectType == 'Person'
                            ? DataCardPerson(
                                // if the object is person
                                operation: operations[index],
                                age: ages.firstWhere((element) =>
                                    element.id ==
                                    operations[index].object.ageId),
                              )
                            : operations[index].objectType == 'Car'
                                ? DataCardCar(
                                    // if the object is car
                                    operation: operations[index],
                                  )
                                : DataCardAccident(
                                    // if the object is accident
                                    operation: operations[index],
                                  ),
                      ),
                    );
                  },
                ),
    );
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
          backgroundColor: Colors.white,
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
      title: Text(AppLocalizations.of(context).translate('carForm_model') +
          (operation.object.model != null
              ? ': ${operation.object.model}'
              : ": ")),
      subtitle: Text(AppLocalizations.of(context).translate('carForm_brand') +
          (operation.object.brand != null
              ? ': ${operation.object.brand}'
              : ": ")),
      isThreeLine: true,
    );
  }
}

class DataCardAccident extends StatelessWidget {
  final Operations operation;

  DataCardAccident({this.operation});

  final formatter = DateFormat('yyyy/MM/dd - HH:mm');

  @override
  Widget build(BuildContext context) {
    // photos
    List photos = operation.photos;

    var cars = operation.object.cars;

    var persons = operation.object.persons;

    return ListTile(
      leading: Hero(
        tag: operation.id.toString(),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 30,
          backgroundImage: photos == null || photos.isEmpty
              ? AssetImage(
                  'imeges/accident.png',
                )
              : NetworkImage(
                  photos[0],
                ),
        ),
      ),
      title: Text(
          '${cars.length} ${AppLocalizations.of(context).translate('homeData_cars')} - ${persons.length} ${AppLocalizations.of(context).translate('homeData_persons')}'),
      // the time is utc - convarte it to local
      subtitle: Text(formatter.format(operation.addDate.toLocal())),
      isThreeLine: true,
    );
  }
}
