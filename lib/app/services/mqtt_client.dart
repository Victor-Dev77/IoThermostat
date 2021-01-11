import 'dart:io';

import 'package:iot_thermostat/app/modules/mqtt_controller.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// TAJ: 1fc240be65514e06b0f357fbcb7d2b90
// VICTOR: 3cac05333f5441eaaa2ef43968fe3681

class MQTTService {
  static final String server = "broker.hivemq.com";
  static final String clientIdentifier = "clientId-8lYQVMbrlC";
  static final int port = 1883;
  static final String topicOnOff = "STATUS/#";
  static final String topicTemp = "TEMP/temp";
  static final String topicDeath = "WIFI/death";
  static final String messageDeath = "Je suis mort FLUTTER";

  static final client =
      MqttServerClient.withPort(server, clientIdentifier, port);
  /*
  MqttServerClient.withPort(
      '0.tcp.ngrok.io', 
      '1fc240be65514e06b0f357fbcb7d2b90', 
      17606,
      maxConnectionAttempts: 1);*/

  static connect() async {
    client.logging(on: true);
    client.keepAlivePeriod = 5;
    client.autoReconnect = false; //TODO: true
    // client.onAutoReconnect = _onAutoReconnect;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .keepAliveFor(5)
        .withWillTopic(topicDeath)
        .withWillMessage(messageDeath)
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atMostOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    client.connectionMessage = connMess;

    try {
      //await client.connect("bluecase", "bluecase");
      await client.connect();
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      print('EXAMPLE::client exception - $e');
      client.disconnect();
      return;
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('EXAMPLE::socket exception - $e');
      client.disconnect();
      return;
    } on Exception {
      // NoConnectionException
      print('EXAMPLE::socket exception - ???');
      client.disconnect();
      return;
    } catch (e) {
      print('EXAMPLE::socket exception - ???');
      client.disconnect();
      return;
    }

    if (client.connectionStatus.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      print("DECONNECTE STATUS");
      return;
    }

    client.subscribe(topicOnOff, MqttQos.atMostOnce);
    client.subscribe(topicTemp, MqttQos.atMostOnce);

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String topic = c[0].topic;
      final String message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      if (topic == topicDeath) {
        print("DEATH !");
        MQTTController.to.setDeath();
      } else if (topic == topicTemp) {
        print(
            "Topic TEMPERATURE topic is <${c[0].topic}>, payload is <-- $message -->");
        print('');
        MQTTController.to.updateTemperature(message);
      } else if (topic == "STATUS/on") {
        print("ON SERVER");
        MQTTController.to.setStart();
      } else if (topic == "STATUS/off") {
        print("OFF SERVER");
        MQTTController.to.setDeath();
      }
    });
  }

  static publishPoidESP() {
    final builder = MqttClientPayloadBuilder();
    builder.addString('ON');
    client.publishMessage(topicOnOff, MqttQos.atMostOnce, builder.payload);
  }

  static publishOnOff(bool status) {
    final builder = MqttClientPayloadBuilder();
    builder.addBool(val: status);
    client.publishMessage("STATUS/app", MqttQos.atMostOnce, builder.payload);
  }

  static publishTemperature(double temperature) {
    final builder = MqttClientPayloadBuilder();
    builder.addDouble(temperature);
    client.publishMessage("TEMP/app", MqttQos.atMostOnce, builder.payload);
  }

  static _onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  static _onAutoReconnect() {
    print(
        'EXAMPLE::onAutoReconnect client callback - Client auto reconnection sequence will start');
  }

  static _onConnected() {
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }

  static _onDisconnected() {
    print(
        'EXAMPLE::OnDisconnected client callback - Client disconnection - ${client.connectionStatus}');
    if (client.connectionStatus.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    print("DECONNECTER");
    return;
  }
}
