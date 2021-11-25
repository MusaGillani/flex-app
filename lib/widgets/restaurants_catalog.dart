import 'package:flutter/material.dart';

import '../providers/firestore.dart' as firestore;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ResCatalog extends StatefulWidget {
  const ResCatalog({Key? key}) : super(key: key);

  @override
  _ResCatalogState createState() => _ResCatalogState();
}

class _ResCatalogState extends State<ResCatalog> {
  bool _isLoading = false;
  List<bool> _saving = [];
  late List<Map<String, String>> _res;
  // List<double> _ratings = [];
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
    _res.forEach((_) => _saving.add(false));
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
                        List<String> openT = data['openTime']!.split(':');
                        List<String> closeT = data['closeTime']!.split(':');
                        TimeOfDay openTime = TimeOfDay(
                          hour: int.parse(openT[0]),
                          minute: int.parse(openT[1]),
                        );
                        TimeOfDay closeTime = TimeOfDay(
                          hour: int.parse(closeT[0]),
                          minute: int.parse(closeT[1]),
                        );
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
                                      // SizedBox(height: 5),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ListItemText(
                                            child: Text(
                                              _isOpen(
                                                openTime: openTime,
                                                closeTime: closeTime,
                                              )
                                                  ? 'Open'
                                                  : 'Closed',
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                '/res/meals',
                                                arguments: data['id'] as String,
                                              );
                                            },
                                            child: Text('Meals'),
                                            style: ElevatedButton.styleFrom(
                                              onPrimary: Colors.white,
                                              elevation: 0,
                                              primary: Colors.pink.shade200,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            RatingBar.builder(
                                              initialRating:
                                                  double.parse(data['rating']!),
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: false,
                                              itemCount: 5,
                                              itemSize:
                                                  constraints.maxWidth * 0.055,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 2.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.pink.shade200,
                                              ),
                                              onRatingUpdate: (rating) {
                                                data['rating'] =
                                                    rating.toString();
                                                print(data['rating']);
                                              },
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                setState(() {
                                                  _saving[index] = true;
                                                });
                                                await firestore.addResRating(
                                                  data['id']!,
                                                  data['rating']!,
                                                );
                                                setState(() {
                                                  _saving[index] = false;
                                                });
                                              },
                                              iconSize:
                                                  constraints.maxWidth * 0.055,
                                              padding: const EdgeInsets.all(0),
                                              icon: _saving[index]
                                                  ? CircularProgressIndicator()
                                                  : Icon(
                                                      Icons.save,
                                                      color:
                                                          Colors.pink.shade200,
                                                    ),
                                            ),
                                          ],
                                        ),
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

  bool _isOpen({
    required TimeOfDay openTime,
    required TimeOfDay closeTime,
  }) {
    // print('${openTime.hour} : ${openTime.minute}');
    // print('${closeTime.hour} : ${closeTime.minute}');
    TimeOfDay now = TimeOfDay.now();
    if (now.hour > openTime.hour && now.hour < closeTime.hour) return true;
    if (now.hour == closeTime.hour && now.minute < closeTime.minute)
      return true;
    if (now.hour == openTime.hour && now.minute > openTime.minute) return true;
    return false;
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
