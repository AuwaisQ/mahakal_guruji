import 'package:flutter/material.dart';

class AstroSearchView extends StatefulWidget {
  const AstroSearchView({super.key});

  @override
  State<AstroSearchView> createState() => _AstroSearchViewState();
}

class _AstroSearchViewState extends State<AstroSearchView> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search",
          style: TextStyle(color: Colors.amber),
        ),
        centerTitle: true,
        // actions: [
        //   BouncingWidgetInOut(
        //     onPressed: () {
        //       setState(() {
        //         isTranslate = !isTranslate;
        //       });
        //     },
        //     bouncingType: BouncingType.bounceInAndOut,
        //     child: Container(
        //       height: 25,
        //       width: 25,
        //       decoration: BoxDecoration(
        //           borderRadius:
        //           BorderRadius.circular(4.0),
        //           color: isTranslate
        //               ? Colors.amber
        //               : Colors.white,
        //           border: Border.all(
        //               color: Colors.amber,
        //               width: 2)),
        //       child: Center(
        //         child: Icon(
        //           Icons.translate,
        //           color: isTranslate
        //               ? Colors.white
        //               : Colors.amber,
        //           size: 18,
        //         ),
        //       ),
        //     ),
        //   ),
        //   SizedBox(width: 10,),
        // ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: searchController,
                  // onChanged: (value) => getSearchData(value),
                  decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: Colors.grey),
                      suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              searchController.clear();
                            });
                          },
                          child: const Icon(Icons.close)),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        color: Colors.amber,
                        height: 18,
                        width: 3,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        "Recent's",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                searchController.clear();
                                // searchController.text = _recentSearches[reversedIndex];
                              });
                              // getSearchData(_recentSearches[reversedIndex]);
                              // _performSearch(_recentSearches[reversedIndex]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Expanded(
                                    flex: 0,
                                    child: Icon(
                                      Icons.history,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Recent",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      // _removeSearch(reversedIndex);
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey.shade400,
                          ),
                        ],
                      );
                    }),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        color: Colors.amber,
                        height: 18,
                        width: 3,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        "Search Result's",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      // final item = combinedList[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              // print(item['id']);
                              // print(item['type']);
                              // routeScreeen("${item['id']}", "${item['slug']}", "${item['type']}", "${item['date']}");
                              // _performSearch(searchController.text.trim());
                              // _performSearch;
                              // combinedList.clear();
                              // searchController.clear();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 0,
                                    child: Icon(
                                      Icons.location_pin,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "ujjain",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey.shade400,
                          ),
                        ],
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
