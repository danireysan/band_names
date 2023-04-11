import 'dart:developer';
import 'dart:io';

import 'package:band_names/models/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 1),
    Band(id: '3', name: 'Héroes del Silencio', votes: 2),
    Band(id: '4', name: 'Bon Jovi', votes: 5),
  ];
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    Widget isOnline() {
      return (socketService.serverStatus == ServerStatus.online)
          ? Icon(
              Icons.check_circle,
              color: Colors.blue[300],
            )
          : const Icon(
              Icons.offline_bolt,
              color: Colors.red,
            );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Band Names',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          _connectionChecker(isOnline),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (_, i) => _bandTile(bands[i]),
      ),
    );
  }

  Container _connectionChecker(Widget Function() isOnline) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: isOnline(),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      background: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
          color: Colors.red,
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Delete Band',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        log(band.name);
        // TODO: llamar el borrado en el server
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text(
          band.votes.toString(),
          style: const TextStyle(fontSize: 20),
        ),
        onTap: () {
          log(band.name);
        },
      ),
    );
  }

  addNewBand() {
    final bandController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New Band Name'),
            content: TextField(
              controller: bandController,
              decoration: const InputDecoration(
                hintText: 'Band Name',
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () => addBandToList(bandController.text),
                elevation: 5,
                textColor: Colors.blue,
                child: const Text('Add'),
              )
            ],
          );
        },
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text('New Band Name'),
          content: TextField(
            controller: bandController,
            decoration: const InputDecoration(
              hintText: 'Band Name',
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Add'),
              onPressed: () => addBandToList(bandController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('Dismiss'),
            ),
          ],
        );
      },
    );
  }

  addBandToList(String name) {
    log(name, name: 'addBandToList');
    if (name.length > 1) {
      bands.add(
        Band(id: DateTime.now().toString(), name: name, votes: 0),
      );
      setState(() {});
    }

    Navigator.pop(context);
  }
}
