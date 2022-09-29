#include <FirebaseESP32.h>
#include "ArduinoJson.h"

//#include <SPI.h>
#include <DHT.h>
#define DHTPIN 19
#define DHTTYPE DHT21 // DHT 21, AM2301
DHT dht(DHTPIN, DHTTYPE);

//ADC
#define adc 34
int baca = 0;
//Sangat cerah 4095
//Gerimis 1500
//Hujan 500

#define FIREBASE_HOST "https://clambi-default-rtdb.firebaseio.com/"
#define FIREBASE_AUTH "a3QGIMy3PueY13pHzFoKo08YLnKJtQz2x12rsVIU"
#define WIFI_SSID "Asus_X01BDA"
#define WIFI_PASSWORD "heri1234567"

//Status
String status_ = "-";
bool posisi = true;
int stsjm;
int mode_ = 1;
//false - nang njero
//true - nang njobo

//Stepper
#define dirPin 32
#define stepPin 33
#define stepmaju 1000
int keluarkan;
int masukan;

//old 800
int kecepatan = 1000;

FirebaseData newfirebaseData;
int t = 0;
int h = 0;

int x = 0;
int y = 0;
void maju()
{
  while (x < stepmaju) {
    digitalWrite(dirPin, LOW);
    digitalWrite(stepPin, HIGH);
    delayMicroseconds(kecepatan);
    digitalWrite(stepPin, LOW);
    delayMicroseconds(kecepatan);
    x++;
  }
  posisi = true;
  x = 0;
  Firebase.setInt(firebaseData, "data1/statusjemuran", 1);
  delay(100);
}

void mundur()
{
  while (y < stepmaju) {
    digitalWrite(dirPin, HIGH);
    digitalWrite(stepPin, HIGH);
    delayMicroseconds(kecepatan);
    digitalWrite(stepPin, LOW);
    delayMicroseconds(kecepatan);
    y++;
  }
  posisi = false;
  y = 0;
  Firebase.setInt(firebaseData, "data1/statusjemuran", 0);
  delay(100);
}
void sendSensor()
{
  h = dht.readHumidity();
  t = dht.readTemperature(); // or dht.readTemperature(true) for Fahrenheit
  if (isnan(h) || isnan(t)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }
  Serial.print("Humidity: ");
  Serial.print(h);
  Serial.print("%,  Temperature: ");
  Serial.print(t);
  Serial.println(" Celsius");
}

void setup() {

  pinMode(stepPin, OUTPUT);
  pinMode(dirPin, OUTPUT);
  digitalWrite(dirPin, LOW);
  pinMode(stepPin, LOW);

  Serial.begin(115200);
  dht.begin();
  pinMode(adc, INPUT_PULLUP);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print("."); delay(100);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);

  delay(200);
  Firebase.setInt(firebaseData, "data1/mode", 1);
  Serial.printf("Get int ref... %s\n", Firebase.getInt(firebaseData, "data1/statusjemuran", &stsjm) ? String(stsjm).c_str() : firebaseData.errorReason().c_str());
  Serial.println(stsjm);
  if (stsjm == 1)
  {
    Serial.println("diluar");
    posisi = true;
  }
  if (stsjm == 0)
  {
    Serial.println("didalam");
    posisi = false;
  }
  delay(200);
}

void loop() {
  //analog
  baca = analogRead(adc);
  Serial.println(baca);
  delay(10);
  //dht
  sendSensor();
  delay(100);
  Firebase.setInt(firebaseData, "data1/hum", h);
  delay(1000);
  Firebase.setInt(firebaseData, "data1/suhu", t);
  delay(1000);

  //control android
  Serial.printf("Get int masukan %s\n", Firebase.getInt(firebaseData, "data1/masukan", &masukan) ? String(masukan).c_str() : firebaseData.errorReason().c_str());
  Serial.println(masukan);
  if (masukan == 1)
  {
    Serial.println("control masukan");
    mundur();
    delay(100);
    Firebase.setInt(firebaseData, "data1/masukan", 0);
    Firebase.setInt(firebaseData, "data1/mode", 0);
  }
  delay(200);
  Serial.printf("Get int keluarkan... %s\n", Firebase.getInt(firebaseData, "data1/keluarkan", &keluarkan) ? String(keluarkan).c_str() : firebaseData.errorReason().c_str());
  Serial.println(keluarkan);
  if (keluarkan == 1)
  {
    Serial.println("control keluarkan");
    maju();
    delay(100);
    Firebase.setInt(firebaseData, "data1/keluarkan", 0);
    Firebase.setInt(firebaseData, "data1/mode", 0);
  }
  //End control

  //Hujan detect
  //Hujan

  Serial.printf("Get int mode %s\n", Firebase.getInt(firebaseData, "data1/mode", &mode_) ? String(mode_).c_str() : firebaseData.errorReason().c_str());
  Serial.println(mode_);
  if (mode_ == 1)
  {
    if (baca <= 600)
    {
      Firebase.setString(firebaseData, "data1/status", "Hujan");
      status_ = "Hujan";
      Serial.print("Status : ");
      Serial.println(status_);
      if (posisi)
        mundur();
    }
    //Gerimis
    if (baca <= 1500 && baca >= 650)
    {
      Firebase.setString(firebaseData, "data1/status", "Gerimis");
      status_ = "Gerimis";
      Serial.print("Status : ");
      Serial.println(status_);
      if (posisi)
        mundur();
    }
    if (baca <= 4095 && baca >= 1500 && t <= 35 && h >= 50)
    {
      Firebase.setString(firebaseData, "data1/status", "Cerah");
      status_ = "Cerah";
      Serial.print("Status : ");
      Serial.println(status_);
      if (!posisi)
        maju();
    }
    if (baca <= 4095 && baca >= 1500 && t >= 35 && h > -50)
    {
      Firebase.setString(firebaseData, "data1/status", "Sangat Cerah");
      status_ = "Sangat Cerah";
      Serial.print("Status : ");
      Serial.println(status_);
      if (!posisi)
        maju();
    }
    if (baca <= 4095 && baca >= 1500 && t <= 35 && h <= 50)
    {
      Firebase.setString(firebaseData, "data1/status", "Mendung");
      status_ = "Mendung";
    }
  }
  delay(1000);
}
