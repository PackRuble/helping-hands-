import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Flutter UncontrolledProviderScope error with Riverpod.
/// help for https://stackoverflow.com/questions/74051897/flutter-uncontrolledproviderscope-error-with-riverpod
/// i didn't help
///
/// Full example:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test',
      home: MyHome(),
    );
  }
}

class MyHome extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onLongPress: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: "hi",
                // barrierColor: Colors.black.withOpacity(0.2),
                // transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (context, pAnim, sAnim) {
                  return const SafeArea(
                      child: FloatingDialog(
                    previewType: PreviewDialogsType.profile,
                  ));
                },
                transitionBuilder: (context, pAnim, sAnim, child) {
                  if (pAnim.status == AnimationStatus.reverse) {
                    return FadeTransition(
                      opacity: Tween(begin: 0.0, end: 0.0).animate(pAnim),
                      child: child,
                    );
                  } else {
                    return FadeTransition(
                      opacity: pAnim,
                      child: child,
                    );
                  }
                },
              );
            },
            child: Container(
              width: double.infinity,
              height: 50.0,
              color: Colors.indigoAccent,
              child: const Text('LongPress please'),
            ),
          ),
        ],
      ),
    );
  }
}

enum PreviewDialogsType {
  profile,
}

class FloatingDialog extends StatefulWidget {
  final PreviewDialogsType previewType;

  const FloatingDialog({super.key, required this.previewType});

  @override
  _FloatingDialogState createState() => _FloatingDialogState();
}

class _FloatingDialogState extends State<FloatingDialog>
    with TickerProviderStateMixin {
  late double _dragStartYPosition;
  late double _dialogYOffset;

  late AnimationController _returnBackController;
  late Animation<double> _dialogAnimation;

  @override
  void initState() {
    super.initState();
    _dialogYOffset = 0.0;
    _returnBackController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1300))
      ..addListener(() {
        setState(() {
          _dialogYOffset = _dialogAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    _returnBackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget myContents = PreviewDialog(
      type: widget.previewType,
    );

    return Padding(
      padding: const EdgeInsets.only(
        top: 100.0,
        bottom: 10.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Transform.translate(
        offset: Offset(0.0, _dialogYOffset),
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.keyboard_arrow_up,
              color: Colors.white,
              size: 30.0,
            ),
            Expanded(
              child: GestureDetector(
                onVerticalDragStart: (dragStartDetails) {
                  _dragStartYPosition = dragStartDetails.globalPosition.dy;
                },
                onVerticalDragUpdate: (dragUpdateDetails) {
                  setState(() {
                    _dialogYOffset = (dragUpdateDetails.globalPosition.dy) -
                        _dragStartYPosition;
                  });
                  if (_dialogYOffset < -130) {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      PageRouteBuilder(
                          pageBuilder: (context, pAnim, sAnim) => myContents,
                          transitionDuration: const Duration(milliseconds: 500),
                          transitionsBuilder: (context, pAnim, sAnim, child) {
                            if (pAnim.status == AnimationStatus.forward) {
                              return ScaleTransition(
                                scale: Tween(begin: 0.8, end: 1.0).animate(
                                    CurvedAnimation(
                                        parent: pAnim,
                                        curve: Curves.elasticOut)),
                                child: child,
                              );
                            } else {
                              return child;
                            }
                          }),
                    );
                  }
                },
                onVerticalDragEnd: (dragEndDetails) {
                  _dialogAnimation = Tween(begin: _dialogYOffset, end: 0.0)
                      .animate(CurvedAnimation(
                          parent: _returnBackController,
                          curve: Curves.elasticOut));
                  _returnBackController.forward(from: _dialogYOffset);

                  _returnBackController.forward(from: 0.0);
                },
                child: myContents,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PreviewDialog extends StatefulWidget {
  final PreviewDialogsType type;
  final String? uuid;

  const PreviewDialog({Key? key, required this.type, this.uuid})
      : super(key: key);

  @override
  State<PreviewDialog> createState() => _PreviewDialogState();
}

class _PreviewDialogState extends State<PreviewDialog> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Scaffold(
          body: MyProfile(),
        ),
      ),
    );
  }
}

// final profileProvider =
//     FutureProvider<void>((ref) => Future.delayed(const Duration(seconds: 5)));

class MyProfile extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMounted = useIsMounted();

    useEffect(() {
      print(1);

      if (isMounted()) {
        ref.read(profileProvider.notifier).send();
        // Do something
        print(123);
      }

      print(2);
      // ref.read(profileProvider.notifier).send(
      //   method: HTTP.POST,
      //   endPoint: Server.$userProfile,
      //   parameters: {
      //     'uuid': '123',
      //   },
      // );
    }, []);

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ref.watch(profileProvider).when(
                    data: (_) => Text('data'),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stackTrace) {
                      return Text('error');
                    },
                  )
            ],
          ),
        ),
      ),
    );
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue>((ref) {
  return ProfileNotifier(const AsyncValue.loading());
});

class ProfileNotifier extends StateNotifier<AsyncValue> {
  ProfileNotifier(super.state);

  Future send() async {
    state = const AsyncValue.loading();
    state = AsyncData(await Future.delayed(const Duration(seconds: 3)));
  }
}
