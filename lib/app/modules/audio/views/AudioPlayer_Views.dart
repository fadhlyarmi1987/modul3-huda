import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/AudioPlayer_Controller.dart';
import 'package:lottie/lottie.dart'; // Import Lottie for additional animation

class AudioPlayerPage extends StatelessWidget {
  final AudioPlayerController controller = Get.put(AudioPlayerController());

  // Static audio URL
  final String audioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        // Gradient background for a modern look
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Lottie animation for play action (optional)
              Obx(() {
                if (controller.isPlaying.value) {
                  return Lottie.asset('assets/record.json', width: 150, height: 150);
                } else {
                  return SizedBox.shrink(); // Do not show when paused
                }
              }),

              SizedBox(height: 30),

              // Button to play audio from a URL
              ElevatedButton.icon(
                onPressed: () {
                  controller.playAudioFromUrl(audioUrl);
                },
                icon: Icon(Icons.cloud_download),
                label: Text('Play dari URL Statis'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Button to choose a local audio file
              ElevatedButton.icon(
                onPressed: controller.pickAudioFile,
                icon: Icon(Icons.folder_open),
                label: Text('Pilih Audio dari Penyimpanan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Display the audio source status
              Obx(() => Text(
                    controller.sourceType.value == 'URL'
                        ? 'Memutar dari URL: ${controller.url.value}'
                        : controller.sourceType.value == 'Local'
                            ? 'Memutar dari File: ${controller.selectedFile.value}'
                            : 'Pilih sumber audio untuk memulai',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),

              SizedBox(height: 20),

              // Audio progress slider
              Obx(() => Slider(
                    value: controller.currentPosition.value,
                    max: controller.totalDuration.value > 0
                        ? controller.totalDuration.value
                        : 1.0,
                    onChanged: (value) {
                      controller.audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                  )),

              Obx(() => Text(
                    'Posisi: ${controller.currentPosition.value.toStringAsFixed(0)}s / ${controller.totalDuration.value.toStringAsFixed(0)}s',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
              SizedBox(height: 20),

              // Audio control buttons (play, pause, stop)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(() => ElevatedButton.icon(
                        onPressed: () {
                          if (!controller.isPlaying.value &&
                              controller.sourceType.isNotEmpty) {
                            if (controller.sourceType.value == 'URL') {
                              controller.playAudioFromUrl(controller.url.value);
                            } else if (controller.sourceType.value == 'Local') {
                              controller.playAudioFromFile(controller.selectedFile.value);
                            }
                          }
                        },
                        icon: Icon(Icons.play_arrow),
                        label: Text("Play"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isPlaying.value ? Colors.grey : Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      )),
                  Obx(() => ElevatedButton.icon(
                        onPressed: () {
                          if (controller.isPlaying.value) {
                            controller.pauseAudio();
                          }
                        },
                        icon: Icon(Icons.pause),
                        label: Text("Pause"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isPlaying.value ? Colors.orange : Colors.grey,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      )),
                  Obx(() => ElevatedButton.icon(
                        onPressed: () {
                          if (controller.isPlaying.value || controller.isPaused.value) {
                            controller.stopAudio();
                          }
                        },
                        icon: Icon(Icons.stop),
                        label: Text("Stop"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (controller.isPlaying.value || controller.isPaused.value)
                              ? Colors.red
                              : Colors.grey,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
