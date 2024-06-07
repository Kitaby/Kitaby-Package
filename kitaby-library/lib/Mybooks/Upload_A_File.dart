import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Constants/Path.dart';
import 'package:kitabylib/Constants/widgets.dart';
import 'package:kitabylib/models/api_services.dart';

class UploadFile extends StatefulWidget {
  const UploadFile({
    super.key,
  });
  @override
  State<UploadFile> createState() => UploadFilestate();
}

class UploadFilestate extends State<UploadFile> {
  double _mediaQueryWidth = 0.0;
  double _mediaQueryHeight = 0.0;

  void didChangeDependencies() {
    super.didChangeDependencies();
    // Call updateMediaQuerySize in didChangeDependencies
    updateMediaQuerySize();
  }

  void updateMediaQuerySize() {
    setState(() {
      MediaQueryData mediaQueryData = MediaQuery.of(context);
      _mediaQueryWidth = mediaQueryData.size.width * 5 / 6;
      _mediaQueryHeight = mediaQueryData.size.height;
    });
  }

  final List<XFile> _list = [];

  bool _dragging = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if ((result != null) && (_list.length < 5)) {
      setState(() {
        _list.addAll(result.paths.map((path) => XFile(path!)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        height: _list.isEmpty
            ? _mediaQueryHeight * (2 / 3).h
            : _mediaQueryHeight * (3 / 4).h,
        width: _mediaQueryWidth / 2.w,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.all(_mediaQueryWidth / 100).w,
                    height: _mediaQueryWidth / 50.h,
                    child: Text(
                      'File Uploaded',
                      style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey900,
                          fontSize: _mediaQueryWidth / 60.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(_mediaQueryWidth / 100).w,
                    height: _mediaQueryWidth / 50.h,
                    child: Text(
                      'Add your documents here, and you can upload up to 5 files max',
                      style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey900,
                          fontSize: _mediaQueryWidth / 80.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  if (_list.length < 1)
                    DropTarget(
                      onDragDone: (detail) async {
                        for (final file in detail.files) {
                          // Check if the file extension is ".xlsx" or ".xls"
                          if (file.name.endsWith('.xlsx')) {
                            if (_list.length < 1) {
                              setState(() {
                                _list..add(file);
                              });
                            }
                            debugPrint('Added file: ${file.path}');
                          } else {
                            debugPrint(
                                'Rejected file: ${file.path} (Not an Excel file)');
                          }
                        }
                      },
                      onDragEntered: (detail) {
                        setState(() {
                          _dragging = true;
                        });
                      },
                      onDragExited: (detail) {
                        setState(() {
                          _dragging = false;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: _mediaQueryWidth / 80).w,
                        child: DottedBorder(
                          color: ColorPalette.bleumarino,
                          strokeWidth: 0.75,
                          dashPattern: [9, (_dragging) ? 0 : 5],
                          child: Container(
                            height: _mediaQueryHeight / 4.h,
                            width: _mediaQueryWidth / 2.5.w,
                            color: _dragging
                                ? Colors.blue.withOpacity(0.4)
                                : Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(Path.upload))),
                                  height: _mediaQueryHeight / 25.h,
                                ),
                                Text(
                                  'Drag your file(s) to start uploading',
                                  style: GoogleFonts.montserrat(
                                      color: ColorPalette.SH_Grey900,
                                      fontSize: _mediaQueryWidth / 80.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  width: _mediaQueryWidth / 6.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Container(
                                        height: 1.h,
                                        color: ColorPalette.SH_Grey500,
                                      )),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            'OR',
                                            style: GoogleFonts.montserrat(
                                                color: ColorPalette.SH_Grey900,
                                                fontSize: _mediaQueryWidth / 80.sp,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                            height: 1.h,
                                            color: ColorPalette.SH_Grey500),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                    onTap: _pickFile,
                                    child: WidgetsModels.button1(
                                        _mediaQueryHeight / 5.w,
                                        _mediaQueryHeight / 20.h,
                                        Colors.white,
                                        null,
                                        ColorPalette.bleumarino
                                            .withOpacity(0.8),
                                        'Browse files',
                                        border: true)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (_list.length < 1)
                    Container(
                      margin: EdgeInsets.all(_mediaQueryWidth / 100).w,
                      height: _mediaQueryWidth / 50.h,
                      child: Text(
                        'Only support xls and xlsx files',
                        style: GoogleFonts.montserrat(
                            color: ColorPalette.SH_Grey900,
                            fontSize: _mediaQueryWidth / 80.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  if (_list.isNotEmpty)
                    Container(
                        width: _mediaQueryWidth / 2.5.w,
                        height: (_list.length < 1)
                            ? _mediaQueryHeight / 6.h
                            : _mediaQueryHeight * (2 / 5).h,
                        child: ListView.builder(
                          itemCount: _list.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorPalette.SH_Grey500,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)).r),
                              margin: EdgeInsets.all(_mediaQueryHeight / 100).w,
                              padding: EdgeInsets.all(_mediaQueryHeight / 100).w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        Path.ExcelLogo,
                                        height: _mediaQueryHeight / 40.h,
                                      ), // Excel icon

                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: _mediaQueryWidth / 100).w,
                                        child: Text(
                                          _list[index].name,
                                          style: GoogleFonts.montserrat(
                                              color: ColorPalette.SH_Grey900,
                                              fontSize: _mediaQueryHeight / 70.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ), // Display file name
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _list.removeAt(index);
                                      });
                                    },
                                    child: Icon(
                                      FluentIcons.dismiss_circle_24_regular,
                                      size: _mediaQueryHeight / 40.sp,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        )),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(_mediaQueryHeight / 40).w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                              onTap: () {
                                if (_list.isNotEmpty) {
                                  setState(() {
                                    _list.clear();
                                  });
                                }
                              },
                              child: WidgetsModels.button1(
                                  _mediaQueryHeight / 8.w,
                                  _mediaQueryHeight / 20.h,
                                  Colors.white,
                                  null,
                                  ColorPalette.grissouris,
                                  'Cancel',
                                  border: true)),
                          GestureDetector(
                              onTap: () async {
                                await APISERVICES()
                                    .UploadFile(_list[0])
                                    .then((response) => {
                                          if (response.message == "success")
                                            {
                                              Navigator.pop(context),
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(WidgetsModels
                                                      .Dialog_Message(
                                                          "success",
                                                          "Uploading succeeded",
                                                          "Your fil has been uploaded successfuly")),
                                            }
                                          else
                                            {
                                              Navigator.pop(context),
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(WidgetsModels
                                                      .Dialog_Message(
                                                          "fail",
                                                          "Error ",
                                                          "Your file hasn't been uploaded successfuly")),
                                            }
                                        });
                              },
                              child: WidgetsModels.button1(
                                  _mediaQueryHeight / 8.w,
                                  _mediaQueryHeight / 20.h,
                                  ColorPalette.bleumarino.withOpacity(1),
                                  null,
                                  Colors.white,
                                  'Next'))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: _mediaQueryWidth / 60,
              right: _mediaQueryWidth / 60,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  FluentIcons.dismiss_12_filled,
                  size: _mediaQueryWidth / 40.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}