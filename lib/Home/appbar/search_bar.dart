import 'package:matrimony_flutter/Utils/importFiles.dart';
import 'package:iconsax/iconsax.dart';

TextEditingController searchController = TextEditingController();
Widget isSearchBarHide(widget,context,changeStateOfSearchBar,onChangeSearchData) {

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 300), // Smooth animation duration
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: widget.search
          ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.07,
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                fillColor: Colors.grey.shade100,
                filled: true,
                hintText: "Search",
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.text="";
                    widget.search = false;
                    changeStateOfSearchBar();
                  },
                  icon: const Icon(Iconsax.close_circle),
                ),
                prefixIcon: const Icon(Iconsax.search_status),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
              ),
              onChanged: (value) {
                String searchData = value.toLowerCase();
                onChangeSearchData(searchData);
              },
            ),
          ),
        ],
      )
          : const SizedBox.shrink(),
    ),
  );
}