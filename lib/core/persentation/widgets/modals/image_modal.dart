// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class SliderShowFullmages extends StatefulWidget {
//   final List listImagesModel;
//   final int current;
//   const SliderShowFullmages({
//     required Key key,
//     required this.listImagesModel,
//     this.current = 0,
//   }) : super(key: key);
//   @override
//   _SliderShowFullmagesState createState() => _SliderShowFullmagesState();
// }

// class _SliderShowFullmagesState extends State<SliderShowFullmages> {
//   int _current = 0;
//   bool _stateChange = false;
//   @override
//   void initState() {
//     super.initState();
//   }

//   List<T> map<T>(List list, Function handler) {
//     List<T> result = [];
//     for (var i = 0; i < list.length; i++) {
//       result.add(handler(i, list[i]));
//     }
//     return result;
//   }

//   @override
//   Widget build(BuildContext context) {
//     _current = (_stateChange == false) ? widget.current : _current;
//     return Container(
//       color: Colors.transparent,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           //title: const Text('Transaction Detail'),
//         ),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             CarouselSlider(
//               options: CarouselOptions(
//                 autoPlay: false,
//                 height: MediaQuery.of(context).size.height / 1.3,
//                 viewportFraction: 1.0,
//                 onPageChanged: (index, data) {
//                   setState(() {
//                     _stateChange = true;
//                     _current = index;
//                   });
//                 },
//                 initialPage: widget.current,
//               ),
//               items: map<Widget>(widget.listImagesModel, (index, url) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Container(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.all(Radius.circular(0.0)),
//                         child: Image.asset(
//                           url,
//                           fit: BoxFit.fill,
//                           height: 400.0,
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//             ),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: map<Widget>(widget.listImagesModel, (index, url) {
//                 return Container(
//                   width: 10.0,
//                   height: 9.0,
//                   margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: (_current == index) ? Colors.redAccent : Colors.grey,
//                   ),
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FlutterFlowExpandedImageView extends StatelessWidget {
  const FlutterFlowExpandedImageView({
    required this.image,
    this.allowRotation = false,
    this.useHeroAnimation = true,
    this.tag,
  });

  final Widget image;
  final bool allowRotation;
  final bool useHeroAnimation;
  final Object? tag;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            Container(
              height: screenSize.height,
              width: screenSize.width,
              child: PhotoView.customChild(
                minScale: 1.0,
                maxScale: 3.0,
                enableRotation: allowRotation,
                heroAttributes:
                    useHeroAnimation
                        ? PhotoViewHeroAttributes(tag: tag!)
                        : null,
                onScaleEnd: (context, details, value) {
                  if (value.scale! < 0.3) {
                    Navigator.pop(context);
                  }
                },
                child: image,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: IconButton(
                    color: Colors.black,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
