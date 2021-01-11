import 'dart:io';
import 'package:iot_thermostat/app/modules/mqtt_controller.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// TAJ: 1fc240be65514e06b0f357fbcb7d2b90
// VICTOR: 3cac05333f5441eaaa2ef43968fe3681

class MQTTService {

  // #######################
  // CONSTANTS
  // #######################
  static final String server = "broker.hivemq.com";
  static final String clientIdentifier = "clientId-8lYQVMbrlC";
  static final int port = 1883;
  static final String topicOnOff = "STATUS/#";
  static final String topicPublishOnOff = "STATUS/app";
  static final String topicTemp = "TEMP/temp";
  static final String topicPublishTemp = "TEMP/app";
  static final String topicHumidity = "TEMP/humidity";
  static final String topicAir = "TEMP/air";
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
    client.autoReconnect = true;
    client.onAutoReconnect = _onAutoReconnect;
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
    print('MQTT::Mosquitto client connection....');
    client.connectionMessage = connMess;

    try {
      //await client.connect("bluecase", "bluecase");
      await client.connect();
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      print('MQTT::client exception - $e');
      client.disconnect();
      return;
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('MQTT::socket exception - $e');
      client.disconnect();
      return;
    } on Exception {
      // NoConnectionException
      print('MQTT::socket exception - ???');
      client.disconnect();
      return;
    } catch (e) {
      print('MQTT::socket exception - ???');
      client.disconnect();
      return;
    }

    if (client.connectionStatus.state == MqttConnectionState.connected) {
      print("MQTT::Mosquitto client connected");
    } else {
      print("MQTT::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}");
      client.disconnect();
      print("MQTT::Status Déconnecté");
      return;
    }

    // #######################
    // SUBSCRIBE TOPICS
    // #######################
    client.subscribe(topicOnOff, MqttQos.atMostOnce);
    client.subscribe(topicTemp, MqttQos.atMostOnce);
    client.subscribe(topicHumidity, MqttQos.atMostOnce);
    client.subscribe(topicAir, MqttQos.atMostOnce);

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String topic = c[0].topic;
      final String message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      if (topic == topicDeath) {
        print("DEATH !");
        MQTTController.to.setDeath();
      } else if (topic == topicTemp) {
        print("Topic TEMPERATURE topic is <${c[0].topic}>, payload is <-- $message -->");
        MQTTController.to.updateTemperature(message);
      } else if (topic == "STATUS/on") {
        print("ON SERVER");
        MQTTController.to.setStart();
      } else if (topic == "STATUS/off") {
        print("OFF SERVER");
        MQTTController.to.setDeath();
      } else if (topic == topicHumidity) {
        print("Topic HUMIDITY <${c[0].topic}>, payload is <-- $message -->");
        MQTTController.to.updateHumidity(message);
      } else if (topic == topicAir) {
        print("Topic AIR <${c[0].topic}>, payload is <-- $message -->");
        MQTTController.to.updateAirQuality(message);
      }

    });
  }


  // #######################
  // CALLBACKS
  // #######################
  static _onSubscribed(String topic) {
    print('MQTT::Subscription confirmed for topic $topic');
  }

  static _onAutoReconnect() {
    print("MQTT::onAutoReconnect");
  }

  static _onConnected() {
    print("MQTT::Connexion réussie");
  }

  static _onDisconnected() {
    print("MQTT::Deconnexion - ${client.connectionStatus}");
    if (client.connectionStatus.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('MQTT::Deconnexion Forcée');
    }
    print("MQTT::Déconnecté");
    return;
  }


  // #######################
  // PUBLISH METHOD
  // #######################
  static publishOnOff(bool status) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(status.toString());
    client.publishMessage(topicPublishOnOff, MqttQos.atMostOnce, builder.payload);
  }

  static publishTemperature(int temperature) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(temperature.toString());
    client.publishMessage(topicPublishTemp, MqttQos.atMostOnce, builder.payload);
  }
}
