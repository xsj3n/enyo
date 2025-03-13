import 'package:enyo/main.dart';
import 'package:enyo/state/model_conversational_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigurationPage extends StatelessWidget
{
  const ConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () =>  Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_sharp)
        ),
      ),
      body: ConfigOptionsList(),
    );
  }
}

class ConfigOptionsList extends StatelessWidget
{
   const ConfigOptionsList({super.key});

   @override
  Widget build(BuildContext context) {
     return ListView(
       padding: const EdgeInsets.all(30),
         children: [
           ConfigViewEntry(label: "List models"),
           ConfigEntry(entry_type: "Set SYSTEM instruction"),
           ConfigEntry(entry_type: "Pull new model"),
     ]);
  }
}

class ConfigViewEntry extends StatefulWidget
{
  final String label;
  const ConfigViewEntry({super.key, required this.label});

  @override
  State<ConfigViewEntry> createState() => _ConfigViewEntryState();
}


class _ConfigViewEntryState extends State<ConfigViewEntry>
{

  final TextEditingController _controller = TextEditingController(text: "");

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getData() {

    if (_controller.text.isNotEmpty) {
      setState(() { _controller.text = ""; });
      return;
    }

    final EnyoState enyoState = context.read<EnyoState>();
    enyoState.ollama_client.fetch_available_models().then((models) {
      var modelsStr = models.models.fold("", (prev, model) => "$prev${model.name}\n");
      modelsStr = modelsStr.substring(0, modelsStr.length - 1);

      setState(() {
        _controller.text = modelsStr;
      });
    }).catchError((err) {
      setState(() {
        _controller.text = err.toString();
      });
    });
  }

   @override
  Widget build(BuildContext context) {
     return Column(children: [
       ElevatedButton(style: ElevatedButton.styleFrom(
           minimumSize: Size(double.infinity, 50),
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))
       ),
         onPressed: () {
           getData();
           },
         child: Text(
           widget.label,
           style: TextStyle(fontFamily: "SFMono"),
         ),
       ),
       Padding(padding: EdgeInsets.only(top: 10)),
       if (_controller.text.isNotEmpty) TextField(decoration: InputDecoration(
         filled: true,
         fillColor: Colors.black12,
         border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(3),
           borderSide: BorderSide(
             color: Colors.white12,
             width: 0.5
           )
         )
       ),
         readOnly: true,
         controller: _controller,
         keyboardType: TextInputType.multiline,
         maxLines: null,
         style: TextStyle(fontFamily: "SFMono", fontSize: 15),
       ),

     ],);
  }
}

class ConfigEntry extends StatelessWidget
{
  final String entry_type;

  const ConfigEntry({super.key, required this.entry_type});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        helperText: entry_type,
        helperStyle: TextStyle(fontFamily: "SFMono")
      ),
    );
  }
}