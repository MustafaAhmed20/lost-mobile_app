import 'package:flutter/material.dart';

// the models
import 'package:lost/models/models.dart';

// the providers
import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';

// the operaion card
import 'package:lost/pages/operations/opeartion_card.dart';

class MyOperationsPage extends StatefulWidget {
  @override
  _MyOperationsPageState createState() => _MyOperationsPageState();
}

class _MyOperationsPageState extends State<MyOperationsPage> {
  List<Operations> operations = [];

  @override
  void didChangeDependencies() {
    operations =
        Provider.of<OperationData>(context, listen: true).operations ?? [];

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            forceElevated: true,
            // floating: true,
            pinned: true,
            expandedHeight: 80.0,
            leading: IconButton(
              icon: Icon(Icons.filter_alt_outlined),
              iconSize: 30.0,
              onPressed: () {},
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text('منشوراتي'),
            ),
            // actions: <Widget>[
            //   IconButton(
            //     icon: Icon(Icons.add),
            //     iconSize: 30.0,
            //     onPressed: () {},
            //   ),
            // ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: DataCard(
                    operation: operations[index],
                  ),
                );
              },
              childCount: operations?.length ?? 0,
            ),
          ),
        ],
      ),
    );
  }
}
