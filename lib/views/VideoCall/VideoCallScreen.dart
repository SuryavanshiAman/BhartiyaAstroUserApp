// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:BharatiyAstro/utils/global.dart' as global;
//
// import '../../controllers/VedioCallController.dart';
//
// class VideoCallScreen extends StatefulWidget {
//   const VideoCallScreen({ Key? key }) : super(key: key);
//
//   @override
//   _VideoCallScreenState createState() => _VideoCallScreenState();
// }
//
// class _VideoCallScreenState extends State<VideoCallScreen> {
//       VedioController vedioController = Get.put(VedioController());
//     late AgoraClient client = AgoraClient(
//     agoraConnectionData: AgoraConnectionData(
//       appId: "${global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)}",
//         channelName: "${vedioController.channelName.value}",
//         // channelName: "testchannel",
//       username: "user0",
//       // rtmChannelName: "${vedioController.channelName.value}",
//       // tempRtmToken:'${vedioController.vedioToken.value}' ,
//       // tempToken: "007eJxTYGizzppQX/DrnlRbcdIX/z3d82SZey97y2754CCv3BB10V6BIdEkJdXI3MwwzdDc3CTFyNTSyNAkzTTJ0jQx2dIiyTI18HtiakMgI4OxoQQTIwMEgviiDInFJUX5TolFJZmVqc6JOTnmRvHmRgwMAFS7I+k="
//       // tokenUrl: '${vedioController.vedioToken.value}' ,
//       tempToken: '${vedioController.vedioToken.value}'
//     ),
//   );
//
// // getPermissions()async{
// //       await [Permission.microphone, Permission.camera].request();
// //      vedioController.isPersmission.value = true;
//
//
// // }
// void initAgora() async {
//   await client.initialize();
// }
//
// void disposeData() async{
//   await client.release();
//
// }
//
//  @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     initAgora();
//     // getPermissions();
//   }
//
//
// @override
//   void dispose() {
//     // TODO: implement dispose
//
//     disposeData();
//         super.dispose();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//       body:Stack(
//           children: [
//             AgoraVideoViewer(client: client),
//             AgoraVideoButtons(client: client
//
//             ),
//           ],
//         )
//       ),
//     );
//   }
// }

import 'package:BharatiyAstro/controllers/VedioCallController.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _isMuted = false;
  bool _isCameraFront = true;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();
//create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(
        appId: "a4de2761f1774d259214f5b95ac98b9e",
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: "007eJxTYGA5EOBQKDnja/3bDT4HjeY9r2BsOtXWs/ZSrMGTOhvLiNsKDIkmKalG5maGaYbm5iYpRqaWRoYmaaZJlqaJyZYWSZappc3/0hoCGRmM1JwZGRkgEMTnY3DKSCxKLMmsVHAsLinKZ2AAALwBIyY=",
      channelId: "Bharatiy Astro",
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

// Toggle microphone mute
  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _engine.muteLocalAudioStream(_isMuted);
  }

// Switch camera between front and back
  void _switchCamera() {
    _engine.switchCamera();
    setState(() {
      _isCameraFront = !_isCameraFront;
    });
  }

// End the call
  void _endCall() {
    _dispose();
    Navigator.pop(context);
  }

// Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
        actions: [
          IconButton(
            icon: Icon(Icons.call_end, color: Colors.red),
            onPressed: _endCall,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
          _toolbar(),
        ],
      ),
    );
  }

// Display remote user's video
  Widget _remoteVideo() {
    VedioController vedioController = Get.put(VedioController());
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: "Bharatiy Astro"),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

// Toolbar for video call options
  Widget _toolbar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RawMaterialButton(
              onPressed: _toggleMute,
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: _isMuted ? Colors.redAccent : Colors.white,
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                _isMuted ? Icons.mic_off : Icons.mic,
                color: _isMuted ? Colors.white : Colors.blueAccent,
                size: 20.0,
              ),
            ),
            RawMaterialButton(
              onPressed: _switchCamera,
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.white,
              padding: const EdgeInsets.all(12.0),
              child: const Icon(
                Icons.switch_camera,
                color: Colors.blueAccent,
                size: 20.0,
              ),
            ),
            RawMaterialButton(
              onPressed: _endCall,
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.redAccent,
              padding: const EdgeInsets.all(12.0),
              child: const Icon(
                Icons.call_end,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// class VideoCallScreen extends StatefulWidget {
//   const VideoCallScreen({super.key});
//
//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }
//
// class _VideoCallScreenState extends State<VideoCallScreen> {
//   int? _remoteUid;
//   bool _localUserJoined = false;
//   late RtcEngine _engine;
//
//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }
//
//   Future<void> initAgora() async {
//     // retrieve permissions
//     await [Permission.microphone, Permission.camera].request();
//
//     //create the engine
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(const RtcEngineContext(
//       appId: "Bharatiy Astro",
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));
//
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           debugPrint("local user ${connection.localUid} joined");
//           setState(() {
//             _localUserJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           debugPrint("remote user $remoteUid joined");
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           debugPrint("remote user $remoteUid left channel");
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//         onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//           debugPrint(
//               '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
//         },
//       ),
//     );
//
//     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     await _engine.enableVideo();
//     await _engine.startPreview();
//
//     await _engine.joinChannel(
//       token: "007eJxTYDgXduT/+70Xp0q/niX8Mq7AUvHBQcPudL8G/dgdNWv3d95TYEg0SUk1MjczTDM0NzdJMTK1NDI0STNNsjRNTLa0SLJM3RL6L60hkJFBqlSBmZEBAkF8PganjMSixJLMSgXH4pKifAYGAHDKJPc=",
//       channelId: "Bharatiy Astro",
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//
//     _dispose();
//   }
//
//   Future<void> _dispose() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//   }
//
//   // Create UI with local view and remote view
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Agora Video Call'),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: _remoteVideo(),
//           ),
//           Align(
//             alignment: Alignment.topLeft,
//             child: SizedBox(
//               width: 100,
//               height: 150,
//               child: Center(
//                 child: _localUserJoined
//                     ? AgoraVideoView(
//                   controller: VideoViewController(
//                     rtcEngine: _engine,
//                     canvas: const VideoCanvas(uid: 0),
//                   ),
//                 )
//                     : const CircularProgressIndicator(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Display remote user's video
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: _engine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: const RtcConnection(channelId: "Bharatiy Astro"),
//         ),
//       );
//     } else {
//       return const Text(
//         'Please wait for remote user to join',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
// }
