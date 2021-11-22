import 'package:flutter/material.dart';

import '../providers/firestore.dart' as firestore;

class ResCatalog extends StatefulWidget {
  const ResCatalog({Key? key}) : super(key: key);

  @override
  _ResCatalogState createState() => _ResCatalogState();
}

class _ResCatalogState extends State<ResCatalog> {
  bool _isLoading = false;
  late List<Map<String, String>> _res;

  @override
  void initState() {
    getRes();
    super.initState();
  }

  void getRes() async {
    setState(() {
      _isLoading = true;
    });
    _res = await firestore.fetchAllRes();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink.shade50,
          title: Text(
            'Restaurants',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }

              Navigator.of(context).pop();
            },
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : LayoutBuilder(builder: (ctx, constraints) {
                return Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: ListView.builder(
                      itemCount: _res.length,
                      itemBuilder: (ctx, index) {
                        final data = _res[index];
                        return Card(
                          margin: const EdgeInsets.all(10),
                          // color: Colors.pink.shade50,
                          color: Colors.orange.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            // side: BorderSide(
                            //     color: Colors.orange.shade200, width: 5),
                          ),
                          // color: Theme.of(context)
                          //     .primaryColorLight.,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 15),
                            width: constraints.maxWidth,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(10),
                            //   border: Border.all(
                            //       color: Colors.orange.shade200, width: 5),
                            // ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: constraints.maxHeight * 0.25,
                                  width: constraints.maxWidth * 0.4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      '${data['imageUrl']}',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      loadingBuilder: (ctx, child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: LinearProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // SizedBox(width: constraints.maxWidth * 0.015),
                                Container(
                                  height: constraints.maxHeight * 0.25,
                                  width: constraints.maxWidth * 0.49,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListItemText(
                                          child: Text(data['resName']!)),
                                      // SizedBox(height: 5),
                                      ListItemText(child: Text('Status: ')),
                                      // SizedBox(height: 5),
                                      Row(
                                        children: [
                                          ListItemText(
                                              child: Text(data['openTime']!)),
                                          // Spacer(),
                                          SizedBox(width: 5),
                                          ListItemText(
                                              child: Text(data['closeTime']!)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                );
              }),
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
      padding: const EdgeInsets.all(15),
      child: child,
    );
  }
}
