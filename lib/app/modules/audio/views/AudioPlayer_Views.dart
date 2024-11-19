import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart'; // Untuk animasi Lottie
import '../controllers/AudioPlayer_Controller.dart'; // Pastikan file controller Anda sudah benar

class AudioPlayerPage extends StatelessWidget {
  final AudioPlayerController controller = Get.put(AudioPlayerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Audio Player',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
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
              Obx(() {
                if (controller.isPlaying.value) {
                  return Lottie.asset('assets/record.json',
                      width: 150, height: 150);
                } else {
                  return Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                  );
                }
              }),
              SizedBox(height: 30),

              Obx(() {
                return Slider(
                  value: controller.currentPosition.value,
                  max: controller.totalDuration.value > 0
                      ? controller.totalDuration.value
                      : 1.0,
                  onChanged: (value) {
                    controller.seekAudio(Duration(seconds: value.toInt()));
                  },
                );
              }),

              Obx(() => Text(
                    'Posisi: ${controller.currentPosition.value.toStringAsFixed(0)}s / ${controller.totalDuration.value.toStringAsFixed(0)}s',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  )),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Tombol Play
                  Obx(() => ElevatedButton.icon(
                        onPressed: () {
                          if (!controller.isPlaying.value) {
                            controller.playAudioFromUrl(controller.getAudioUrl());
                          }
                        },
                        icon: Icon(Icons.play_arrow),
                        label: Text("Play"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isPlaying.value
                              ? Colors.grey
                              : Colors.green, 
                        ),
                      )),

                  // Tombol Pause
                  Obx(() => ElevatedButton.icon(
                        onPressed: () {
                          if (controller.isPlaying.value) {
                            controller.pauseAudio();
                          }
                        },
                        icon: Icon(Icons.pause),
                        label: Text("Pause"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isPlaying.value
                              ? Colors.orange
                              : Colors.grey,
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
                          backgroundColor: (controller.isPlaying.value ||
                                  controller.isPaused.value)
                              ? Colors.red
                              : Colors.grey, 
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
