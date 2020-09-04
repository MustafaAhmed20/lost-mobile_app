import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';

// import operation model
import 'package:lost/models/operation.dart';
import 'package:lost/models/person.dart';

// use formatter
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';

// share location
import 'package:share/share.dart';

// api key
import 'secrets.dart';

//language support
import 'package:lost/app_localizations.dart';

List photos;

class DataDetails extends StatefulWidget {
  @override
  _DataDetailsState createState() => _DataDetailsState();
}

class _DataDetailsState extends State<DataDetails> {
  int _current = 0;
  Map arguments;

  Operations operation;

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context).settings.arguments;

    // selected object now
    String selectedObject =
        Provider.of<AppSettings>(context, listen: true).selectedObject;

    operation = arguments['operation'];

    // photos
    photos = operation.photos;

    // TypeOperation type = Provider.of<TypeOperationData>(context, listen: false)
    //     .typeOperation
    //     .firstWhere((element) => element.id == operation.typeId);

    dynamic country =
        Provider.of<CountryData>(context, listen: false).selectedCountry;
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate('dataDetails_details')),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Hero(
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //  show the slider only if there is photos
            //
            photos.isNotEmpty
                ? imegeSliderBuilder(context, setState, this)
                : noPhotos(context),
            photos.isNotEmpty ? sliderRow(_current) : SizedBox.shrink(),

            // the type name
            /*
            Center(
              child: Text(
                type.name.toUpperCase(),
                style: TextStyle(fontSize: 20),
              ),
            ),
            */

            // the operation data
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  )),
              child: Padding(
                  padding: EdgeInsets.only(top: 15, left: 20, bottom: 8),
                  child: Column(
                    children: [
                      // object Title
                      Text(
                        selectedObject == 'Person'
                            ? 'Person details'
                            : 'Car details',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Divider(),
                      ),

                      // the object data
                      selectedObject == 'Person'
                          ? personTable(context, operation)
                          : carTable(context, operation),

                      // operation Title
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          'ad details',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Divider(),
                      ),

                      // the operation data

                      operationTable(context, country, operation),
                    ],
                  )),
            ),
            // location image and share
            operation.lat == null
                ? noLocation(context)
                : Center(
                    child: InkWell(
                      onTap: () {
                        Share.share(
                            'https://www.google.com/maps/search/?api=1&query=${operation.lat},${operation.lng}');
                      },
                      child: Image.network(
                          'https://maps.googleapis.com/maps/api/staticmap?size=600x300&markers=color:red%7C${operation.lat},${operation.lng}&key=$mapsKey'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

List<Widget> imageSliders(List photos) => photos
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();

Widget imegeSliderBuilder(BuildContext context, Function setState, object) {
  return CarouselSlider(
    items: imageSliders(photos),
    options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2.0,
        onPageChanged: (index, reason) {
          setState(() {
            object._current = index;
          });
        }),
  );
}

Widget sliderRow(int _current) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: photos.map((url) {
      int index = photos.indexOf(url);
      return Container(
        width: 8.0,
        height: 8.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _current == index
              ? Color.fromRGBO(0, 0, 0, 0.9)
              : Color.fromRGBO(0, 0, 0, 0.4),
        ),
      );
    }).toList(),
  );
}

Widget noPhotos(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(top: 20, bottom: 60),
    child: Center(
        child: Text(
      AppLocalizations.of(context).translate('dataDetails_noPhotos'),
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    )),
  );
}

Widget noLocation(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(top: 20, bottom: 60),
    child: Center(
        child: Text(
      AppLocalizations.of(context).translate('dataDetails_noLocation'),
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    )),
  );
}

Widget operationTable(BuildContext context, country, operation) {
  var formatter = new DateFormat('yyyy-MM-dd');
  return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.symmetric(inside: BorderSide(width: 0.08)),
      children: [
        // date

        TableRow(children: [
          Text(
            AppLocalizations.of(context).translate('dataDetails_Date'),
            style: TextStyle(fontSize: 20),
          ),
          Text(
            '${formatter.format(operation.date)}',
            style: TextStyle(fontSize: 18),
          ),
        ]),

        // state
        TableRow(children: [
          Text(
            'state',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            '${operation.state}',
            style: TextStyle(fontSize: 18),
          ),
        ]),
        // city
        TableRow(children: [
          Text(
            'city',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            '${operation.city}',
            style: TextStyle(fontSize: 18),
          ),
        ]),
        // details
        TableRow(children: [
          Text(
            AppLocalizations.of(context).translate('dataDetails_details_filed'),
            style: TextStyle(fontSize: 20),
          ),
          Text(
            operation.details != null ? '${operation.details}' : '',
            style: TextStyle(fontSize: 18),
          ),
        ]),
        // publisher info
        TableRow(
            // user info
            children: [
              Text(
                "publisher",
                style: TextStyle(fontSize: 18),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Theme.of(context).primaryColor,
                child: Text(
                  'Show publisher info',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: AlertDialog(
                            backgroundColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.0))),
                            content: Container(
                              width: 300,
                              height: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.account_circle,
                                    size: 70,
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Name:'),
                                      Text('${operation.user.name}'),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: Colors.green[300],
                                        size: 40,
                                      ),
                                      Text(
                                          '+${country.phoneCode} ${operation.user.phone}'),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
              ),
            ]),
      ]);
}

Widget personTable(BuildContext context, operation) {
  List ages = Provider.of<AgeData>(context, listen: true).ages;
  Age age = ages.firstWhere((element) => element.id == operation.object.ageId);
  List skins = Provider.of<AppSettings>(context, listen: true).skins;
  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    border: TableBorder.symmetric(inside: BorderSide(width: 0.08)),
    children: [
      // name
      TableRow(children: [
        Text(
          AppLocalizations.of(context).translate('dataDetails_Name'),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          '${operation.object.name}',
          style: TextStyle(fontSize: 20),
        ),
      ]),
      // gender
      TableRow(children: [
        Text(
          'Gender',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          '${operation.object.gender}',
          style: TextStyle(fontSize: 18),
        ),
      ]),
      // age
      TableRow(children: [
        Text(
          AppLocalizations.of(context).translate('dataDetails_age'),
          style: TextStyle(fontSize: 20),
        ),
        Text(
          '${age.minAge} - ${age.minAge}',
          style: TextStyle(fontSize: 18),
        ),
      ]),
      // skin
      TableRow(children: [
        Text(
          'skin',
          style: TextStyle(fontSize: 20),
        ),
        RichText(
          // the emoji
          text: TextSpan(style: TextStyle(fontSize: 18), children: [
            TextSpan(
              text: "${skins[operation.object.skin - 1][0]}",
            ),
            TextSpan(
                text: "(${skins[operation.object.skin - 1][1]})",
                style: TextStyle(color: Colors.black, fontSize: 13)),
          ]),
        ),
      ]),
    ],
  );
}

Widget carTable(BuildContext context, operation) {
  List cars = Provider.of<AppSettings>(context, listen: true).cars;
  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    border: TableBorder.symmetric(inside: BorderSide(width: 0.08)),
    children: [
      // brand
      TableRow(children: [
        Text(
          'Brand',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          '${operation.object.brand}',
          style: TextStyle(fontSize: 20),
        ),
      ]),
      // model
      TableRow(children: [
        Text(
          'Model',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          '${operation.object.model}',
          style: TextStyle(fontSize: 18),
        ),
      ]),
      // car type
      TableRow(children: [
        Text(
          'car type',
          style: TextStyle(fontSize: 20),
        ),
        RichText(
          // the emoji
          text: TextSpan(style: TextStyle(fontSize: 18), children: [
            TextSpan(
              text: "${cars[operation.object.type - 1][0]}",
            ),
            TextSpan(
                text: "(${cars[operation.object.type - 1][1]})",
                style: TextStyle(color: Colors.black, fontSize: 13)),
          ]),
        ),
      ]),
      // plate number
      TableRow(children: [
        Text(
          'plate number',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          '${operation.object.plateNumberLettrs} - ${operation.object.plateNumberNumbers}',
          style: TextStyle(fontSize: 18, letterSpacing: 2),
        ),
      ]),
    ],
  );
}
