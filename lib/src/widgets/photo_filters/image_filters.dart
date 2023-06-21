import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:colorfilter_generator/presets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:screenshot/screenshot.dart';
import '../popup.dart';
import '../styles.dart';

/// Image filter for ImageEditor.
/// Use for add filter, emoticon.
class VImageFilters extends StatefulWidget {
  final Uint8List image;
  final bool useCache;

  const VImageFilters({
    Key? key,
    required this.image,
    this.useCache = true,
  }) : super(key: key);

  @override
  State<VImageFilters> createState() => _VImageFiltersState();
}

class _VImageFiltersState extends State<VImageFilters> {
  late img.Image decodedImage;
  ColorFilterGenerator selectedFilter = PresetFilters.none;
  Uint8List resizedImage = Uint8List.fromList([]);
  double filterOpacity = 1;
  Uint8List filterAppliedImage = Uint8List.fromList([]);
  ScreenshotController screenshotController = ScreenshotController();
  bool applied = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Styles.imageEditorTheme,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                Popup.loading();
                var data = await screenshotController.capture();
                Popup.pop();
                Get.back(result: data);
              },
            ).paddingSymmetric(horizontal: 8),
          ],
        ),
        body: Center(
          child: Screenshot(
            controller: screenshotController,
            child: Stack(
              children: [
                Image.memory(
                  widget.image,
                  fit: BoxFit.cover,
                ),
                FilterAppliedImage(
                  image: widget.image,
                  filter: selectedFilter,
                  fit: BoxFit.cover,
                  opacity: filterOpacity,
                  onProcess: (img) {
                    filterAppliedImage = img;
                    if (!applied) {
                      applied = true;
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: SizedBox(
            height: 160,
            child: Column(children: [
              SizedBox(
                height: 40,
                child: selectedFilter == PresetFilters.none
                    ? Container()
                    : selectedFilter.build(
                        Slider(
                          min: 0,
                          max: 1,
                          divisions: 100,
                          value: filterOpacity,
                          onChanged: (value) {
                            filterOpacity = value;
                            setState(() {});
                          },
                        ),
                      ),
              ),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    for (int i = 0; i < presetFiltersList.length; i++)
                      filterPreviewButton(
                        filter: presetFiltersList[i],
                        name: presetFiltersList[i].name,
                      ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget filterPreviewButton({required filter, required String name}) {
    return Column(children: [
      Container(
        height: 64,
        width: 64,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(48),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(48),
          child: FilterAppliedImage(
            image: widget.image,
            filter: filter,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Text(
        i18n(name),
        style: const TextStyle(fontSize: 12),
      ),
    ]).onTap(() {
      selectedFilter = filter;
      applied = false;
      setState(() {});
    });
  }
}
