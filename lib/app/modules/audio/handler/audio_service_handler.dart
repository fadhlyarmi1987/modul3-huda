// import 'package:audio_service/audio_service.dart';
// import 'package:just_audio/just_audio.dart';

// class AudioServiceHandler extends BaseAudioHandler {
//   final AudioPlayer player;

//   AudioServiceHandler(this.player) {
//     // Update playback state for notifications
//     player.playerStateStream.listen((state) {
//       playbackState.add(PlaybackState(
//         controls: [
//           MediaControl.skipToPrevious,
//           if (state.playing) MediaControl.pause else MediaControl.play,
//           MediaControl.stop,
//         ],
//         androidCompactActionIndices: [0, 1, 2],
//         playing: state.playing,
//         processingState: _mapProcessingState(state.processingState),
//       ));
//     });

//     // Update media iatem for notifications
//     player.durationStream.listen((duration) {
//       mediaItem.add(MediaItem(
//         id: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
//         album: 'Sample Album',
//         title: 'Sample Song',
//         duration: duration,
//         artUri: Uri.parse('https://via.placeholder.com/150'), // Cover art
//       ));
//     });
//   }

//   PlaybackState _mapProcessingState(ProcessingState state) {
//     switch (state) {
//       case ProcessingState.idle:
//         return PlaybackState.stopped;
//       case ProcessingState.loading:
//         return PlaybackState.buffering;
//       case ProcessingState.ready:
//         return PlaybackState.playing;
//       case ProcessingState.completed:
//         return PlaybackState.stopped;
//       default:
//         return PlaybackState.none;
//     }
//   }

//   @override
//   Future<void> play() async {
//     await player.play();
//   }

//   @override
//   Future<void> pause() async {
//     await player.pause();
//   }

//   @override
//   Future<void> stop() async {
//     await player.stop();
//     playbackState.add(PlaybackState(
//       controls: [],
//       androidCompactActionIndices: [],
//       playing: false,
//       processingState: PlaybackState.stopped,
//     ));
//   }
// }
