import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../styles/color.dart';

class ListAdvokatScreen extends StatefulWidget {
  const ListAdvokatScreen({super.key});

  @override
  State<ListAdvokatScreen> createState() => _ListAdvokatScreenState();
}

class _ListAdvokatScreenState extends State<ListAdvokatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Advokat", style:
          TextStyle(
            color: AppColor.descColor,
            fontSize: 17,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
        ),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 150,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Boy Raja P.Marpaung, SH, MH",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.grey,size: 14,),
                                SizedBox(width: 5,),
                                Text(
                                  "Kabupaten Toba",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.primaryColor,
                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.white,size: 14,),
                                      SizedBox(width: 5,),
                                      Text(
                                        "4.00",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.shopping_bag_sharp, color: Colors.grey,size: 14,),
                                      SizedBox(width: 5,),
                                      Text(
                                        "6 Tahun",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Text(
                                  "Rp. 35.000",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                // Expanded(child: Container(),),
                                ElevatedButton(
                                  onPressed: (){},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primaryColor,
                                  ),
                                  child: const Text(
                                    'Chat',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ),
    );
  }
}
