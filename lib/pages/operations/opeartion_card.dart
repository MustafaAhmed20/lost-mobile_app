import 'package:flutter/material.dart';

// the models
import 'package:lost/models/models.dart';

//language support
import 'package:lost/app_localizations.dart';

// the cars
import 'package:lost/constants.dart';

import 'package:intl/intl.dart';

// the providers
import 'package:lost/models/appData.dart';

import 'package:provider/provider.dart';

class DataCard extends StatelessWidget {
  final Operations operation;

  bool showBottomIdentifiers;

  DataCard({
    @required this.operation,
    this.showBottomIdentifiers = false,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<String> photos = operation.photos;
    String objectType = operation.objectType;

    // the status strings
    bool isOperationActive = operation.isActive();

    String statusString = isOperationActive ? 'متاح' : 'مغلق';

    return Container(
      width: screenSize.width,
      height: showBottomIdentifiers ? 100 : 80,
      decoration: BoxDecoration(
        color: liteBackground.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          width: 1.0,
          color: Colors.grey[200],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // the photo
          Container(
            // alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              border: Border.all(color: mainDarkColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                height: 70,
                width: 70,
                fit: BoxFit.cover,
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
          ),

          // the rest of the data
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              child: Column(
                children: [
                  // the object data
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

                  // the Bottom Identifiers
                  showBottomIdentifiers
                      ? Container(
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                color: hoverColor,
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context).translate(
                                    objectType == 'Accident'
                                        ? 'menu_accident'
                                        : objectType == 'Person'
                                            ? 'menu_people'
                                            : objectType == 'Car'
                                                ? 'menu_cars'
                                                : 'menu_PersonalBelongings',
                                  ),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                )),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                color: isOperationActive
                                    ? Colors.green
                                    : Colors.red,
                                child: Center(
                                    child: Text(
                                  statusString,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                )),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
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
    Age age = ages.firstWhere((element) => element.id == operation.object.ageId,
        orElse: () => null);

    return Container(
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
                  '${age?.minAge ?? ''} - ${age?.maxAge ?? ''}'),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // the time is utc - convarte it to local
              Text(formatter.format(operation.addDate.toLocal())),

              // is in shelter
              operation.object.shelter == true
                  ? Column(
                      children: [
                        Icon(
                          Icons.home,
                          color: Colors.red,
                          size: 20,
                        ),
                        Text(
                            AppLocalizations.of(context)
                                .translate('homeData_inShelter'),
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ],
                    )
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
