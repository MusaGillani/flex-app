import 'package:flutter/material.dart';

class MealsView extends StatefulWidget {
  const MealsView({Key? key}) : super(key: key);

  @override
  _MealsViewState createState() => _MealsViewState();
}

class _MealsViewState extends State<MealsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        title: Text(
          'Meals',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (
          ctx,
          constraints,
        ) =>
            Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (
                          ctx,
                        ) =>
                            SimpleDialog(
                          title: Text('Sort By:'),
                          children: [
                            SimpleDialogOption(
                              onPressed: () =>
                                  Navigator.pop(context, 'some data'),
                              child: Text('Date added'),
                            ),
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.sort_sharp),
                          Text('sort'),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.pink.shade50),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(Icons.filter_alt_sharp),
                          Text('filter'),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.pink.shade50),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (ctx, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(
                      thickness: 5.0,
                    ),
                  ),
                  itemCount: 14,
                  itemBuilder: (
                    ctx,
                    i,
                  ) =>
                      //   Card(
                      // margin: const EdgeInsets.all(10),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(25),
                      // ),
                      // child:
                      Container(
                    width: constraints.maxWidth,
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListItemText(child: Text('meal')),
                              SizedBox(height: 10),
                              ListItemText(child: Text('details of the meal')),
                              Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      ListItemText(child: Text('meal')),
                                      SizedBox(height: 10),
                                      ListItemText(child: Text('detail')),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // ),
      ),
    );
  }
}

class ListItemText extends StatelessWidget {
  const ListItemText({Key? key, required this.child}) : super(key: key);
  final Text child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: child,
    );
  }
}
