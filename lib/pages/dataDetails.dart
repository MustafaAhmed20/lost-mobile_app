import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';

// import operation model
import 'package:lost/models/operation.dart';
import 'package:lost/models/person.dart';

// use formatter
import 'package:intl/intl.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text('details'),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CarouselSlider(
            items: imageSliders(photos),
            options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
          Row(
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
          ),
          // data
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                //border: Border(left: BorderSide(color: Colors.black)),
                //borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
            child: Card(
              margin: EdgeInsets.fromLTRB(15, 0, 20, 0),
              color: Colors.grey[200],
              child: Padding(
                padding: EdgeInsets.only(top: 8, left: 15, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Name: ${operation.object.name}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'age: ${age.minAge} - ${age.minAge}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Date: ${formatter.format(operation.date)}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
