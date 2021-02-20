// the main part of the home page

import 'package:flutter/material.dart';
import 'package:lost/constants.dart';

import 'wait.dart';
import 'package:lost/models/operation.dart';
import 'package:lost/models/person.dart';

import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';

//language support
import 'package:lost/app_localizations.dart';

import 'package:intl/intl.dart';

class HomeData extends StatefulWidget {
  // lost or found
  int typeId;
  HomeData({this.typeId});

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

    // the country
    filters['country_id'] =
        Provider.of<CountryData>(context, listen: false).selectedCountry?.id;

    // the type(lost or flund) if any
    if (widget.typeId != null) filters['type_id'] = widget.typeId;

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

    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(bottom: 80),
      // color: Colors.red,
      child: RefreshIndicator(
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
                : Container(
                    // margin: EdgeInsets.only(top: 20),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: operations.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/details',
                                arguments: {
                                  'operation': operations[index],
                                  'age': selectedObject != 'Person'
                                      ? null
                                      : ages.firstWhere((element) =>
                                          element.id ==
                                          operations[index].object.ageId)
                                });
                          },
                          child: Container(
                            color: liteBackground,
                            // decoration: BoxDecoration(
                            //   border: Border.symmetric(
                            //       vertical: BorderSide(
                            //     color: Colors.grey,
                            //     width: 0.2,
                            //   )),
                            // ),
                            margin: EdgeInsets.only(bottom: 8),
                            child: DataCard(
                              operation: operations[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}

class DataCard extends StatelessWidget {
  final Operations operation;
  String objectType;
  DataCard({
    @required this.operation,
  }) {
    objectType = operation.objectType;
  }
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List photos = operation.photos;
    return Container(
      width: screenSize.width,
      height: 70,
      padding: EdgeInsets.only(right: 5, top: 5, bottom: 5),
      // color: Colors.red,
      child: Row(
        children: [
          // the photo
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              border: Border.all(color: mainDarkColor),
            ),
            child: Image(
              fit: BoxFit.fill,
              image: photos == null || photos.isEmpty
                  ? AssetImage(
                      objectType == 'Person'
                          ? 'imeges/profile.png'
                          : objectType == 'Car'
                              ? 'imeges/car.png'
                              : objectType == 'Accident'
                                  ? 'imeges/accident.png'
                                  :
                                  //Personal Belongings
                                  'imeges/belongings.png',
                    )
                  : NetworkImage(
                      photos[0],
                    ),
            ),
          ),

          // the rest of the data
          Expanded(
            child: objectType == 'Person'
                ? DataCardPerson(
                    operation: operation,
                  )
                : objectType == 'Car'
                    ? DataCardCar(
                        operation: operation,
                      )
                    : objectType == 'Accident'
                        ? DataCardAccident(
                            operation: operation,
                          )
                        :
                        //Personal Belongings
                        DataCardPersonalBelongings(
                            operation: operation,
                          ),
          ),
        ],
      ),
    );
  }
}

class DataCardPerson extends StatelessWidget {
  final Operations operation;

  DataCardPerson({
    @required this.operation,
  });
  final formatter = DateFormat('yyyy/MM/dd - HH:mm');
  @override
  Widget build(BuildContext context) {
    // this for 'Person' object
    List ages = Provider.of<AgeData>(context, listen: true).ages ?? [];
    Age age =
        ages.firstWhere((element) => element.id == operation.object.ageId);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // name & age
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // name

              Text(AppLocalizations.of(context).translate('homeData_Name') +
                  '${operation.object.name}'),

              // age
              Text(AppLocalizations.of(context).translate('homeData_Age') +
                  '${age.minAge} - ${age.maxAge}'),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // the time is utc - convarte it to local
              Text(formatter.format(operation.addDate.toLocal())),

              // is in shelter
              operation.object.shelter == true
                  ? Text(
                      AppLocalizations.of(context)
                          .translate('homeData_inShelter'),
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold))
                  : SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}

class DataCardCar extends StatelessWidget {
  final Operations operation;

  DataCardCar({@required this.operation});

  final formatter = DateFormat('yyyy/MM/dd - HH:mm');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context).translate('carForm_model') +
                  (operation.object.model != null
                      ? ': ${operation.object.model}'
                      : ": ")),
              Text(AppLocalizations.of(context).translate('carForm_brand') +
                  (operation.object.brand != null
                      ? ': ${operation.object.brand}'
                      : ": ")),
            ],
          ),

          // date
          Row(
            children: [
              // the time is utc - convarte it to local
              Text(formatter.format(operation.addDate.toLocal())),
            ],
          ),
        ],
      ),
    );
  }
}

class DataCardAccident extends StatelessWidget {
  final Operations operation;

  DataCardAccident({@required this.operation});

  final formatter = DateFormat('yyyy/MM/dd - HH:mm');

  @override
  Widget build(BuildContext context) {
    var cars = operation.object.cars;

    var persons = operation.object.persons;

    return Column(
      children: [
        // the date
        // the time is utc - convarte it to local
        Text(formatter.format(operation.addDate.toLocal())),

        // the cars & persons numbrt
        Text(
            '${cars.length} ${AppLocalizations.of(context).translate('homeData_cars')} - ${persons.length} ${AppLocalizations.of(context).translate('homeData_persons')}'),
      ],
    );

    // ListTile(
    //   title: Text(
    //       '${cars.length} ${AppLocalizations.of(context).translate('homeData_cars')} - ${persons.length} ${AppLocalizations.of(context).translate('homeData_persons')}'),
    //   // the time is utc - convarte it to local
    //   subtitle: Text(formatter.format(operation.addDate.toLocal())),
    //   isThreeLine: true,
    // );
  }
}

class DataCardPersonalBelongings extends StatelessWidget {
  final Operations operation;

  DataCardPersonalBelongings({@required this.operation});

  final formatter = DateFormat('yyyy/MM/dd - HH:mm');

  @override
  Widget build(BuildContext context) {
    List<List> types = Provider.of<AppSettings>(context, listen: false)
        .availablePersonalBelongingsTypes;

    var selectedType = types[operation.object.type - 1];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(AppLocalizations.of(context)
                  .translate(selectedType[0].toString())),
              selectedType[1].length > 0
                  ? Text('/' +
                      AppLocalizations.of(context).translate(selectedType[1]
                              [operation.object.subtype - 1]
                          .toString()))
                  : SizedBox.shrink(),
            ],
          ),
          Row(
            children: [
              // the date
              // the time is utc - convarte it to local
              Text(formatter.format(operation.addDate.toLocal())),
            ],
          ),
        ],
      ),
    );
  }
}
