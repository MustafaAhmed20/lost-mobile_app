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
  Age age;

  var formatter = new DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context).settings.arguments;

    operation = arguments['operation'];
    age = arguments['age'];

    // photos
    photos = operation.object.photos;

    TypeOperation type = Provider.of<TypeOperationData>(context, listen: false)
        .typeOperation
        .firstWhere((element) => element.id == operation.typeId);

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
                : SizedBox.shrink(),
            photos.isNotEmpty ? sliderRow(_current) : SizedBox.shrink(),

            photos.isEmpty ? noPhotos(context) : SizedBox.shrink(),

            // the type name
            Center(
              child: Text(
                type.name.toUpperCase(),
                style: TextStyle(fontSize: 20),
              ),
            ),

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
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,

                  //border: TableBorder.symmetric(),
                  children: [
                    TableRow(children: [
                      Text(
                        AppLocalizations.of(context)
                            .translate('dataDetails_Name'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        '${operation.object.name}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                    TableRow(children: [
                      Text(
                        AppLocalizations.of(context)
                            .translate('dataDetails_age'),
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '${age.minAge} - ${age.minAge}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ]),
                    TableRow(children: [
                      Text(
                        AppLocalizations.of(context)
                            .translate('dataDetails_Date'),
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '${formatter.format(operation.date)}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ]),
                    TableRow(children: [
                      Text(
                        AppLocalizations.of(context)
                            .translate('dataDetails_details_filed'),
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox.shrink(),
                    ]),
                    TableRow(children: [
                      SizedBox.shrink(),
                      Text(
                        '${operation.details}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ]),
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0))),
                                        content: Container(
                                          width: 300,
                                          height: 300,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.account_circle,
                                                size: 70,
                                              ),
                                              SizedBox(
                                                height: 40,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text('Name:'),
                                                  Text(
                                                      '${operation.user.name}'),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
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
                  ],
                ),
              ),
            ),

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
