import 'dart:io';

class Environment {
  static final String apiUrl = Platform.isAndroid
      // ? 'http://10.0.2.2:3000/api' //* Para emuladores Android
      ? 'http://192.168.1.5:3000/api' //* Para dispositivos físicos (la ip del pc puede variar en cada conexión)
      : 'http://localhost:3000/api';

  static final String socketUrl = Platform.isAndroid
      // ? 'http://10.0.2.2:3000' //* Para emuladores Android
      ? 'http://192.168.1.5:3000' //* Para dispositivos físicos (la ip del pc puede variar en cada conexión)
      : 'http://localhost:3000';
}
