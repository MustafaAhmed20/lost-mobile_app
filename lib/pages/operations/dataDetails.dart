import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';

// import operation model
import 'package:lost/models/models.dart';

// use formatter
import 'package:intl/intl.dart';

// the comments
import 'package:lost/pages/comments.dart';

// the buttons
import 'package:lost/widgets/buttons.dart';

// the providers
import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';

// share location
import 'package:share/share.dart';

// api key
import 'package:lost/api.dart';

//language support
import 'package:lost/app_localizations.dart';

// the colors
import 'package:lost/constants.dart';

import 'package:url_launcher/url_launcher.dart';

List<String> photos;

class DataDetails extends StatefulWidget {
  @override
  _DataDetailsState createState() => _DataDetailsState();
}

class _DataDetailsState extends State<DataDetails> {
  int _current = 0;
  Map arguments;

  Operations operation;

  // open the comments page
  void openComments(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Comments(
          operation: operation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context).settings.arguments;

    operation = arguments['operation'];

    // selected object now
    String selectedObject = operation.objectType;

    // photos
    photos = operation.photos;

    // TypeOperation type = Provider.of<TypeOperationData>(context, listen: false)
    //     .typeOperation
    //     .firstWhere((element) => element.id == operation.typeId);

    Country country =
        Provider.of<CountryData>(context, listen: false).selectedCountry;

    // login state - true if user logged-in
    bool logged = Provider.of<UserData>(context, listen: true).token == null
        ? false
        : true;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate('dataDetails_details')),
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
              padding: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  // color: Colors.grey[200],
                  color: liteBackground,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  )),
              child: Padding(
                  padding: EdgeInsets.only(top: 15, left: 20, bottom: 8),
                  child: Column(
                    children: [
                      // contact box
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // messages button
                            Container(
                              width: 100,
                              child: Button50HBig(
                                function: openComments,
                                color: mainLiteColor,
                                text: 'التعليقات',
                                textColor: Colors.white,
                                textSize: 14,
                                image: 'imeges/chat.png',
                                iconSize: 25,
                              ),
                            ),

                            // phone button
                            Container(
                              width: 100,
                              child: Button50HBig(
                                function: (c) {
                                  // open phone call if the user logged-in
                                  logged
                                      ? launch("tel://0${operation.user.phone}")
                                      :
                                      // go to login page
                                      Navigator.pushNamed(context, '/login',
                                          arguments: {'showAlert': true});
                                },
                                color: mainLiteColor,
                                text: 'اتصال',
                                textColor: Colors.white,
                                textSize: 14,
                                image: 'imeges/call.png',
                              ),
                            ),
                          ],
                        ),
                      ),

                      // some space
                      SizedBox(height: 10),

                      // object Title
                      Text(
                        selectedObject == 'Person'
                            ? AppLocalizations.of(context)
                                .translate('personForm_operatioDetails')
                            : selectedObject == 'Car'
                                ? AppLocalizations.of(context)
                                    .translate('carForm_operatioDetails')
                                : selectedObject == 'Accident'
                                    ? AppLocalizations.of(context)
                                        .translate('accidentForm_details')
                                    : AppLocalizations.of(context)
                                        .translate('dataDetails_details'),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          // color: otherTextColor,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Divider(),
                      ),

                      // the object data
                      selectedObject == 'Person'
                          ? personTable(context, operation.object)
                          : selectedObject == 'Car'
                              ? carTable(context, operation.object)
                              : selectedObject == 'Accident'
                                  ? accidentTable(context, operation)
                                  : personalBelongingsTable(
                                      context, operation.object),

                      // operation Title
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('operatioForm_operatioDetails'),
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

List<Widget> imageSliders(List photos, BuildContext context) => photos
    .map((item) => InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FullScreenImege(item)));
          },
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    FadeInImage(
                      fit: BoxFit.cover,
                      width: 1000.0,
                      placeholder: AssetImage('imeges/loading.gif'),
                      image: NetworkImage(item),
                    ),
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
    items: imageSliders(photos, context),
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

class FullScreenImege extends StatelessWidget {
  final String link;
  FullScreenImege(this.link);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(link),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
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
            AppLocalizations.of(context).translate('operatioForm_state'),
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
            AppLocalizations.of(context).translate('operatioForm_city'),
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
        /*
        TableRow(
            // user info
            children: [
              Text(
                AppLocalizations.of(context).translate('dataDetails_publisher'),
                style: TextStyle(fontSize: 18),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Theme.of(context).primaryColor,
                child: Text(
                  AppLocalizations.of(context)
                      .translate('dataDetails_showPublisher'),
                  style: TextStyle(color: Colors.white, fontSize: 14),
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
      */
      ]);
}

Widget personTable(BuildContext context, object) {
  List ages = Provider.of<AgeData>(context, listen: true).ages;
  Age age = ages.firstWhere((element) => element.id == object.ageId);
  List skins = Provider.of<AppSettings>(context, listen: true).skins;
  Map genders =
      Provider.of<AppSettings>(context, listen: true).availableGenders;
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
          '${object.name}',
          style: TextStyle(fontSize: 20),
        ),
      ]),
      // gender
      TableRow(children: [
        Text(
          AppLocalizations.of(context).translate('personForm_gender'),
          style: TextStyle(fontSize: 20),
        ),
        Text(
          AppLocalizations.of(context).translate(genders[object.gender]),
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
          AppLocalizations.of(context).translate('personForm_skinApprox'),
          style: TextStyle(fontSize: 20),
        ),
        object.skin != null
            ? Row(
                children: [
                  Image.asset(
                    "imeges/person/${skins[(object.skin) - 1][0]}",
                    width: 50,
                  ),
                  Text(
                      AppLocalizations.of(context)
                          .translate(skins[object.skin - 1][1]),
                      style: TextStyle(color: Colors.black, fontSize: 13)),
                ],
              )
            : SizedBox.shrink(),
      ]),
    ],
  );
}

Widget carTable(BuildContext context, object) {
  //List cars = Provider.of<AppSettings>(context, listen: true).cars;
  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    border: TableBorder.symmetric(inside: BorderSide(width: 0.08)),
    children: [
      // brand
      TableRow(children: [
        Text(
          AppLocalizations.of(context).translate('carForm_brand'),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          object.brand != null ? '${object.brand}' : '',
          style: TextStyle(fontSize: 20),
        ),
      ]),
      // model
      TableRow(children: [
        Text(
          AppLocalizations.of(context).translate('carForm_model'),
          style: TextStyle(fontSize: 20),
        ),
        Text(
          object.model != null ? '${object.model}' : "",
          style: TextStyle(fontSize: 18),
        ),
      ]),
      // car type - not used now

      /*
      TableRow(children: [
        Text(
          AppLocalizations.of(context).translate('carForm_type'),
          style: TextStyle(fontSize: 20),
        ),
        RichText(
          // the emoji
          text: TextSpan(style: TextStyle(fontSize: 18), children: [
            TextSpan(
              text: "${cars[object.type - 1][0]}",
            ),
            TextSpan(
                text: "(${cars[object.type - 1][1]})",
                style: TextStyle(color: Colors.black, fontSize: 13)),
          ]),
        ),
      ]),
      */
      // plate number
      TableRow(children: [
        Text(
          AppLocalizations.of(context).translate('carForm_plate'),
          style: TextStyle(fontSize: 20),
        ),
        Text(
          '${object.plateNumberLettrs.toUpperCase()} - ${object.plateNumberNumbers}',
          style: TextStyle(fontSize: 18, letterSpacing: 2),
        ),
      ]),
    ],
  );
}

Widget accidentTable(BuildContext context, operation) {
  List cars = operation.object.cars;
  List persons = operation.object.persons;
  final formatter = DateFormat('yyyy/MM/dd - HH:mm');
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
          // Accident date and time
          Text(
            '${AppLocalizations.of(context).translate('dataDetails_AccidentTime')} ${formatter.format(operation.addDate.toLocal())}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          // cars titel
          cars.length != 0
              ? Text(
                  AppLocalizations.of(context)
                      .translate('dataDetails_CarsInvolved'),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )
              : SizedBox.shrink(),
        ] +
        // cars list
        cars.map((e) {
          int index = cars.indexOf(e);
          return ExpansionTile(
              title: Text(
                  AppLocalizations.of(context).translate('accidentForm_car') +
                      '${index + 1}:',
                  style: TextStyle(color: Colors.black)),
              children: [carTable(context, e)]);
        }).toList() +
        [
          // persons titel
          persons.length != 0
              ? Text(
                  AppLocalizations.of(context)
                      .translate('dataDetails_PersonsInvolved'),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )
              : SizedBox.shrink()
        ] +
        // persons list
        persons.map((e) {
          int index = persons.indexOf(e);
          return ExpansionTile(
              title: Text(
                  AppLocalizations.of(context)
                          .translate('accidentForm_person') +
                      '${index + 1}:',
                  style: TextStyle(color: Colors.black)),
              children: [personTable(context, e)]);
        }).toList(),
  );
}

Widget personalBelongingsTable(BuildContext context, object) {
  List<List> types = Provider.of<AppSettings>(context, listen: false)
      .availablePersonalBelongingsTypes;
  var selectedType = types[object.type - 1];

  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    border: TableBorder.symmetric(inside: BorderSide(width: 0.08)),
    children: [
      // type
      TableRow(children: [
        Text(
          AppLocalizations.of(context).translate('belongingsForm_type'),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          AppLocalizations.of(context).translate(selectedType[0]),
          style: TextStyle(fontSize: 20),
        ),
      ]),
      // subtype
      TableRow(children: [
        Text(
          AppLocalizations.of(context).translate('belongingsForm_subtype'),
          style: TextStyle(fontSize: 20),
        ),
        Text(
          selectedType[1].length > 0
              ? AppLocalizations.of(context)
                  .translate(selectedType[1][object.subtype - 1])
              : '',
          style: TextStyle(fontSize: 18),
        ),
      ]),
    ],
  );
}
