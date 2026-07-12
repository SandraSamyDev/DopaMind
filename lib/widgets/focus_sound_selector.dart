import 'package:flutter/material.dart';
import '../services/focus_sounds.dart';
import '../services/sound_service.dart';

class FocusSoundSelector extends StatefulWidget {
  final String? selectedSoundId;
  final Function(String) onSelected;

  const FocusSoundSelector({
    super.key,
    required this.selectedSoundId,
    required this.onSelected,
  });

  @override
  State<FocusSoundSelector> createState() => _FocusSoundSelectorState();
}

class _FocusSoundSelectorState extends State<FocusSoundSelector> {
  final SoundService soundService = SoundService();

  String? playingId;

  @override
  void dispose() {
    //soundService.stopSound();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: focusSounds.map((sound) {
        final isSelected = widget.selectedSoundId == sound.id;
        final isPlaying = playingId == sound.id;

        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 24,
                ),
                onPressed: () async {
                  if (isPlaying) {
                    await soundService.stopSound();

                    setState(() {
                      playingId = null;
                    });
                  } else {
                    await soundService.stopSound();

                    await soundService.startSound(sound.assetPath);

                    setState(() {
                      playingId = sound.id;
                    });
                  }
                },
              ),

              const SizedBox(width: 4),

              Expanded(
                child: Text(
                  sound.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),

              Transform.scale(
                scale: 0.8,
                child: Radio<String>(
                  value: sound.id,
                  groupValue: widget.selectedSoundId,
                  onChanged: (value) {
                    widget.onSelected(value!);
                  },
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
