import 'package:enyo/screens/config_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/model_conversational_state.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
        create: (context) => EnyoState(),
        child: const MyApp(),
    )
  );


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "enyo",
      theme: ThemeData.dark(),
      home: EnyoMainPage(),
    );
  }
}



class EnyoMainPage extends StatelessWidget {
  const EnyoMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
              backgroundColor: Colors.black,
              appBar: EnyoAppBar(),
              body: ScaffoldBody(),
              bottomNavigationBar: BottomAppBar(
                                      shape: const CircularNotchedRectangle(),
                                      height: 120,
                                      color: Colors.black,
                                      child: Column(
                                          children: [
                                        PushToTalkButton(),
                                        Container(padding: const EdgeInsets.only(top: 15), child: const BlackTextField())
                                      ]),
                                    ),

            );
  }
}

class EnyoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EnyoAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EnyoState>(
      builder: (context, enyo_state, child) {
        return AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConfigurationPage())
              ),
              icon: Icon(Icons.cloud)
          ),
          title: Text(enyo_state.last_model_used, style: TextStyle(fontSize: 15),),
        );
      });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ScaffoldBody extends StatelessWidget {
  const ScaffoldBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EnyoState>(
      builder: (context, enyo_state, child) {
        return Container(
          padding: EdgeInsets.all(50),
          child: Center(child: ListView.builder(
              itemCount: enyo_state.msgs.length,
              itemBuilder: (context, index) {
                final msgLen = enyo_state.msgs.length - 1;
                if (enyo_state.msgs[index].role == "user") {
                  return Column(children: [
                    BlackText(txt: enyo_state.msgs[index].content, size: 16),
                    Padding(padding: EdgeInsets.only(bottom: 2)),
                    Divider(height: 1, thickness: 1, color: Colors.grey,)

                  ]);
                }

                if (index == msgLen && enyo_state.nowStreaming) {
                  return Column(children: [
                      Padding(padding: EdgeInsets.only(top: 10)),
                      BlackText(txt: enyo_state.lastMsg)
                  ]);
                }
                if (index == msgLen && !enyo_state.nowStreaming) {
                  return Column(children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    BlackText(txt: enyo_state.msgs[msgLen].content)
                  ]);
                }
                return Column(children: [
                  BlackText(txt: enyo_state.msgs[index].content),
                  Padding(padding: EdgeInsets.only(top: 10, bottom: 40)),
                ]);
          })),
        );
      },
    );
  }
}




class PushToTalkButton extends StatelessWidget {
  const PushToTalkButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EnyoState>(builder: (context, enyo_state, child) {
      return ElevatedButton(
        onPressed: () => enyo_state.record(),
        style: ButtonStyle(
            shape: WidgetStatePropertyAll<CircleBorder>(
                CircleBorder()
            )
        ),
        child: const Icon(Icons.circle),
      );
    });
  }
}

class BlackTextField extends StatelessWidget {
  const BlackTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EnyoState>(
        builder: (context, enyo_state, child) {
          return TextField(
            onSubmitted: (value)
            {
              enyo_state.bottom_text_field_ctrl.clear();
              enyo_state.chat(value);
            },
            controller: enyo_state.bottom_text_field_ctrl,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(
                    width: 0.5, color: Colors.white12)),
                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(
                    width: 0.5, color: Colors.white12)),
                border: OutlineInputBorder(borderSide: const BorderSide(
                    width: 0.5, color: Colors.white12)),
                focusColor: Colors.white12,
                hoverColor: Colors.white12
            ),
            style: TextStyle(fontFamily: "SFMono", fontSize: 12),
          );
        });
  }
}

class BlackText extends StatelessWidget {
  const BlackText({super.key, required this.txt, this.size = 14});
  final String txt;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
        txt,
        style: TextStyle(fontFamily: "SFMono", fontWeight: FontWeight.normal, fontSize: size)
    );
  }
}

