import 'package:flutter/material.dart';

class AppSelectionBottomSheet extends StatefulWidget {
  final List<dynamic> installedApps;
  final List<String> initialSelectedApps;
  final Function(String) onAppSelected;
  final Function(String) onAppUnselected;

  const AppSelectionBottomSheet({
    super.key,
    required this.installedApps,
    required this.initialSelectedApps,
    required this.onAppSelected,
    required this.onAppUnselected,
  });

  @override
  State<AppSelectionBottomSheet> createState() => _AppSelectionBottomSheetState();
}

class _AppSelectionBottomSheetState extends State<AppSelectionBottomSheet> {
  late List<String> _localSelectedApps;

  @override
  void initState() {
    super.initState();
    // Create a local copy of selected apps to handle UI changes inside the sheet
    _localSelectedApps = List.from(widget.initialSelectedApps);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.installedApps.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text("No apps found on this device."),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Select Distractions to Block", 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: widget.installedApps.length,
              itemBuilder: (context, index) {
                final app = widget.installedApps[index];
                final String pkgName = app["packageName"] ?? "";
                final String appName = app["appName"] ?? "Unknown App";
                final bool isChecked = _localSelectedApps.contains(pkgName);

                return CheckboxListTile(
                  title: Text(appName),
                  subtitle: Text(
                    pkgName, 
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  value: isChecked,
                  onChanged: (bool? val) {
                    setState(() {
                      if (val == true) {
                        _localSelectedApps.add(pkgName);
                        widget.onAppSelected(pkgName);
                      } else {
                        _localSelectedApps.remove(pkgName);
                        widget.onAppUnselected(pkgName);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}