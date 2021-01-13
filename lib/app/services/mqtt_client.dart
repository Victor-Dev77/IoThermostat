import 'dart:io';
import 'package:iot_thermostat/app/modules/mqtt_controller.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {

  // #######################
  // CONSTANTS
  // #######################
  static final String server = "0.tcp.ngrok.io";//"broker.hivemq.com";
  static final String clientIdentifier = "clientId-8lYQVMbrlC";
  static final int port = 19510;//1883;
  static final String userConnect = "fycMQTT";
  static final String mdpConnect = "fycmqtt";
  static final String topicTemp = "FYC/temperature";
  static final String topicPublishTemp = "FYC/temperature/app";
  static final String topicHumidity = "FYC/humidity";
  static final String topicAir = "FYC/quality";
  static final String topicDeath = "FYC/death";
  static final String messageDeath = "Je suis mort App FLUTTER";

  static final client =
      MqttServerClient.withPort(server, clientIdentifier, port);

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
      await client.connect(userConnect, mdpConnect);
      //await client.connect();
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
    client.subscribe(topicDeath, MqttQos.atMostOnce);
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
        MQTTController.to.updateThermostatConnecting(false);
      } else if (topic == topicTemp) {
        print("Topic TEMPERATURE topic is <${c[0].topic}>, payload is <-- $message -->");
        MQTTController.to.updateTemperature(message);
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

  static publishTemperature(int temperature) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(temperature.toString());
    client.publishMessage(topicPublishTemp, MqttQos.atMostOnce, builder.payload);
  }
}
