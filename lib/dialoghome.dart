import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';


import 'message.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  List<Map<String,dynamic>> messages =[];
  @override

  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter=instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Google Dialog Flow'),
      ),
      body: Container(
        child: Column(children: [
          Expanded(child: MessagesScreen(messages:messages)),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 14),
            color: Colors.blueGrey[700],
            child: Row(children: [
              Expanded(child: TextField(
                controller: _controller,
                style: TextStyle(color: Colors.white),
              )),
              IconButton(onPressed: (){
                sendMessage(_controller.text);
                _controller.clear();
              }, icon: Icon(Icons.send),color: Colors.black,)
            ]),
          ),



        ]),
      ),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }

}