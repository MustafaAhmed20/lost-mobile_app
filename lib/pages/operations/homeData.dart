// the main part of the home page

import 'package:flutter/material.dart';

// tha cars
import 'package:lost/constants.dart';

import 'package:lost/pages/wait.dart';

// the models
import 'package:lost/models/models.dart';

import 'package:provider/provider.dart';

// the providers
import 'package:lost/models/appData.dart';

// language support
import 'package:lost/app_localizations.dart';

// the operaion card
import 'package:lost/pages/operations/opeartion_card.dart';

class HomeData extends StatefulWidget {
  // lost or found
  int typeId;
  HomeData({this.typeId});

  @override
  _HomeDataState createState() => _HomeDataState();
}

class _HomeDataState extends State<HomeData> {
  List<Operations> operations = [];
  List ages;

  @override
  void initState() {
    super.initState();

    // clear the operations
    Provider.of<OperationData>(context, listen: false).operations?.clear();
  }

  @override
  void didChangeDependencies() {
    bool isLoading =
        Provider.of<OperationData>(context, listen: true).isLoading;

    // this for 'Person' object
    ages = Provider.of<AgeData>(context, listen: true).ages;

    String selectedObject =
        Provider.of<AppSettings>(context, listen: false).selectedObject;

    if (!isLoading) {
      // filter

      // load the operations with the filters
      Provider.of<OperationData>(context, listen: false).filterData([
        (Operations operation) {
          // the type filter
          if (selectedObject == 'Accident') {
            // no type filter on Accident
            return true;
          }
          return operation.typeId == widget.typeId;
        },
        (Operations operation) {
          // the object filter

          // Person
          if (selectedObject == 'Person' && operation.object is Person)
            return true;
          // Accident
          if (selectedObject == 'Accident' && operation.object is Accident)
            return true;
          // Car
          if (selectedObject == 'Car' && operation.object is Car) return true;
          // PersonalBelongings
          if (selectedObject == 'PersonalBelongings' &&
              operation.object is PersonalBelongings) return true;

          return false;
        }
      ]);

      operations =
          Provider.of<OperationData>(context, listen: false).operations ?? [];
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading =
        Provider.of<OperationData>(context, listen: true).isLoading ?? true;

    // selected object now
    String selectedObject =
        Provider.of<AppSettings>(context, listen: true).selectedObject;

    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(bottom: 80),
      child: RefreshIndicator(
        onRefresh: () {
          return Provider.of<OperationData>(context, listen: false)
              .reLoad(context: context);
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
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: operations.length,
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
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
                          child: DataCard(
                            operation: operations[index],
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
