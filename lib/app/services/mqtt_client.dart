import 'dart:io';
import 'package:iot_thermostat/app/modules/mqtt_controller.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// Section IV - Communication avec le Broker MQTT
class MQTTService {

  // #######################
  // CONSTANTS
  // #######################

  static final String server = "";            // Ajouter l'hote du broker
  static final String clientIdentifier = "";  // Ajouter un identifiant de connexion unique
  static final int port = 0;                  // Ajouter le port                                                                       
  static final String userConnect = "";       // Ajouter l'identifiant de connexion 
  static final String mdpConnect = "";        // Ajouter le mot de passe de connexion 

  static final String topicTemp = "";         // Ajouter le topic de la temperature 
  static final String topicPublishTemp = "";  // Ajouter le topic de l'envoi de la temperature
  static final String topicHumidity = "";     // Ajouter le topic de l'humidite 
  static final String topicAir = "";          // Ajouter le topic de la qualité d'air 
  static final String topicDeath = "";        // Ajouter le topic de la mort de l'app 
  static final String messageDeath = "";      // Ajouter le message a envoyer lors de la mort de l'app  

  static final MqttServerClient client =
      MqttServerClient.withPort("", "", 0);     // Ajouter l'hote, l'identifiant du client et le port

  static connect() async {
    client.logging(on: true);
    client.keepAlivePeriod = 5;
    client.autoReconnect = true;
    client.onAutoReconnect = _onAutoReconnect;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;

    final connMess = MqttConnectMessage()
        .withClientIdentifier("")               // Ajouter l'identifiant de connexion
        .keepAliveFor(5)
        .withWillTopic("")                      // Ajouter le topic de la mort de l'app 
        .withWillMessage("")                    // Ajouter le message a envoyer lors de la mort de l'app
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    print('MQTT::Client connection....');
    client.connectionMessage = connMess;

    try {
      await client.connect();                   // Ajouter l'identifiant et le mot de passe de connexion 
    } on NoConnectionException catch (e) {
      print('MQTT::Client exception - $e');
      client.disconnect();
      return;
    } on SocketException catch (e) {
      print('MQTT::Socket Exception - $e');
      client.disconnect();
      return;
    } on Exception {
      print('MQTT::Socket Exception');
      client.disconnect();
      return;
    } catch (e) {
      print('MQTT::Socket Exception - $e');
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
    client.subscribe("", MqttQos.atMostOnce);                   // Ajouter le topic du testament
    client.subscribe("", MqttQos.atMostOnce);                   // Ajouter le topic de la température
    client.subscribe("", MqttQos.atMostOnce);                   // Ajouter le topic de l'humidité
    client.subscribe("", MqttQos.atMostOnce);                   // Ajouter le topic de la qualité d'air

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String topic = c[0].topic;
      final String message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      if (topic == topicDeath) {
        print("DEATH !");
        ;                                                           // Mettre le thermostat hors service
      } else if (topic == topicTemp) {
        print("Topic TEMPERATURE, payload is <-- $message -->");
        ;                                                           // Mettre à jour la température
      } else if (topic == topicHumidity) {
        print("Topic HUMIDITY, payload is <-- $message -->");
        ;                                                           // Mettre à jour l'humidité
      } else if (topic == topicAir) {
        print("Topic AIR, payload is <-- $message -->");
        ;                                                           // Mettre à jour la qualité d'air
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
    client.publishMessage("", MqttQos.atMostOnce, builder.payload); // Ajouter le topic de l'envoi de la temperature
  }
}
