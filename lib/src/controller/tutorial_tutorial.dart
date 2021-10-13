library tutorial;

import 'package:flutter/material.dart';
import 'package:tutorial/src/models/tutorial_itens.dart';
import 'package:tutorial/src/painter/painter.dart';

class Tutorial {
  static showTutorial(BuildContext context, List<TutorialItens> children, Function function) async {
    int count = 0;
    var size = MediaQuery.of(context).size;
    OverlayState overlayState = Overlay.of(context);
    List<OverlayEntry> entrys = [];
    children.forEach((element) async {
      var offset = _capturePositionWidget(element.globalKey);
      var sizeWidget = _getSizeWidget(element.globalKey);
      entrys.add(
        OverlayEntry(
          builder: (context) {
            return GestureDetector(
              onTap: element.touchScreen == true
                  ? () async {
                      entrys[count].remove();
                      function(count);
                      count++;
                      if (count != entrys.length) {
                        overlayState.insert(entrys[count]);
                      }
                    }
                  : () {},
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    CustomPaint(
                      size: size,
                      painter: HolePainter(
                          shapeFocus: element.shapeFocus,
                          dx: (offset?.dx ?? 0) + ((sizeWidget?.width ?? size?.width) / 2),
                          dy: (offset?.dy ?? 0) + ((sizeWidget?.height ?? size?.height) / 2),
                          width: sizeWidget?.width ?? size?.width,
                          height: sizeWidget?.height ?? size?.height),
                    ),
                    Positioned(
                      top: element.top,
                      bottom: element.bottom,
                      left: element.left,
                      right: element.right,
                      child: Container(
                        width: size?.width * 0.8,
                        child: Column(
                          crossAxisAlignment: element.crossAxisAlignment,
                          mainAxisAlignment: element.mainAxisAlignment,
                          children: [
                            ...element.children,
                            GestureDetector(
                              child: element.widgetNext ??
                                  Text(
                                    "NEXT",
                                    style: TextStyle(color: Colors.white),
                                  ),
                              onTap: () async {
                                entrys[count].remove();
                                function(count);
                                count++;
                                if (count != entrys.length) {
                                  overlayState.insert(entrys[count]);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
    
    overlayState.insert(entrys[0]);
  }


  static Offset _capturePositionWidget(GlobalKey key) {
    try{
      RenderBox renderPosition = key?.currentContext?.findRenderObject() as RenderBox;
      return renderPosition?.localToGlobal(Offset.zero);
    }catch(e){
      return null;
    }
  }

  static Size _getSizeWidget(GlobalKey key) {
    try{
      RenderBox renderSize = key?.currentContext?.findRenderObject() as RenderBox;
      return renderSize?.size;
    }catch(e){
      return null;
    }
  }
}
