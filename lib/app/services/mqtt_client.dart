import 'package:iot_thermostat/app/modules/mqtt_controller.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// TAJ: 1fc240be65514e06b0f357fbcb7d2b90
// VICTOR: 3cac05333f5441eaaa2ef43968fe3681

class MQTTService {
  static final String topicWifi = 'WIFI/#';
  static final String topicPoids = 'POIDS/pa';
  static final String topicPoidsFlutter = 'POIDS/pa/flutter';

  static final client = MqttServerClient.withPort(
      '0.tcp.ngrok.io', '1fc240be65514e06b0f357fbcb7d2b90', 17606);

  static connect() async {
    client.logging(on: true);
    client.keepAlivePeriod = 5;
    client.autoReconnect = true;
    client.onAutoReconnect = _onAutoReconnect;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('1fc240be65514e06b0f357fbcb7d2b90')
        .keepAliveFor(5)
        .withWillTopic('WIFI/death')
        .withWillMessage('Je suis mort FLUTTER')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atMostOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect("bluecase", "bluecase");
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      client.disconnect();
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

    client.subscribe(topicWifi, MqttQos.atMostOnce);
    client.subscribe(topicPoids, MqttQos.atMostOnce);

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      if(c[0].topic == "WIFI/pa" || c[0].topic == "WIFI/death"){
        String _wifiValue =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        /// The above may seem a little convoluted for users only interested in the
        /// payload, some users however may be interested in the received publish message,
        /// lets not constrain ourselves yet until the package has been in the wild
        /// for a while.
        /// The payload is a byte buffer, this will be specific to the topic
        print(
            'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $_wifiValue -->');
        print('');
        MQTTController.to.updateWifiSignal(_wifiValue);
      } else {
         String _poidValue =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        /// The above may seem a little convoluted for users only interested in the
        /// payload, some users however may be interested in the received publish message,
        /// lets not constrain ourselves yet until the package has been in the wild
        /// for a while.
        /// The payload is a byte buffer, this will be specific to the topic
        print(
            'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $_poidValue -->');
        print('');
        MQTTController.to.updatePoids(_poidValue);
      }
    });

  }

  static publishPoidESP(){
    final builder = MqttClientPayloadBuilder();
    builder.addString('ON');
    client.publishMessage(topicPoidsFlutter, MqttQos.atMostOnce, builder.payload);
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
  }
}