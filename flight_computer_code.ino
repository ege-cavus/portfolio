#include <SD.h>
#include <SPI.h>
#include <Arduino_BMI270_BMM150.h>
#include <Arduino_LPS22HB.h>
const int chipSelectPin = 10; // Chip select pin for the SD card
const char *filename = "acc_data.txt"; // File name
void setup() {
 digitalWrite(4, HIGH);
 Serial.begin(9600);
 // Initialize SD card
 if (!SD.begin(chipSelectPin)) {
 Serial.println("Error initializing SD card.");
 while (true); // Stop if SD card initialization fails
 }
 Serial.println("SD card initialized.");
 // Initialize the BMI270_BMM150 IMU
17
 if (!IMU.begin()) {
 Serial.println("Failed to initialize IMU!");
 while (1); // Stop if IMU initialization fails
 digitalWrite(4, LOW);
 }
 if (!BARO.begin()) {
 Serial.println("Failed to initialize pressure sensor!");
 while (1);
 digitalWrite(4, LOW);
 }
 Serial.println("IMU initialized.");
 // Check if the file exists, if not, create it
 if (!SD.exists(filename)) {
 Serial.println("File does not exist. Creating...");
 createFile(filename);
 digitalWrite(4, LOW);
 } else {
 Serial.println("File exists.");
 }
}
void loop() {
 // Read accelerometer data
 float accelX, accelY, accelZ, gyroX, gyroY, gyroZ;
 char *sentence;
 char latitude[11];
 char longitude[12];
 if(Serial1.available()) {
 char c = Serial1.read();
 sentence += c;
 parseNMEA(sentence, latitude, longitude);
 }
 
 readAccelData(accelX, accelY, accelZ);
 readGyroData(gyroX, gyroY, gyroZ);
 float pressure = BARO.readPressure();
 float temperature = BARO.readTemperature();
 // Write accelerometer data to SD card
 appendAccelDataToSD(accelX, accelY, accelZ,gyroX, gyroY, gyroZ, temperature, 
pressure, latitude, longitude);
18
 digitalWrite(4, LOW);
 delay(50); // Adjust as needed
 digitalWrite(4, HIGH);
 delay(50);
}
void readAccelData(float &x, float &y, float &z) {
 // Read accelerometer data
 if (IMU.accelerationAvailable()) {
 IMU.readAcceleration(x, y, z);
 }
}
void readGyroData(float &gy_x, float &gy_y, float &gy_z) {
 if (IMU.gyroscopeAvailable()) {
 IMU.readGyroscope(gy_x, gy_y, gy_z);
 }
}
void appendAccelDataToSD(float x, float y, float z, float gy_x, float gy_y, float
gy_z,float pressure, float temperature, char* longitude, char* latitude) {
 // Open file in append mode
 File dataFile = SD.open(filename, FILE_WRITE);
 if (dataFile) {
 // Write accelerometer data to file
 dataFile.print("AccelX: ");
 dataFile.print(x);
 dataFile.print("\tAccelY: ");
 dataFile.print(y);
 dataFile.print("\tAccelZ: ");
 dataFile.println(z);
///////////////////////////////////////////
 dataFile.print("GyroX: ");
 dataFile.print(gy_x);
 dataFile.print("\tGyroY: ");
 dataFile.print(gy_y);
 dataFile.print("\tGyroZ: ");
 dataFile.println(gy_z);
///////////////////////////////////////////
 dataFile.print("Prs: ");
 dataFile.println(pressure);
 dataFile.print("Tmp: ");
 dataFile.println(temperature);
///////////////////////////////////////////
19
 dataFile.print("longitude: ");
 dataFile.print(longitude);
 dataFile.print("latitude");
 dataFile.print(latitude);
///////////////////////////////////////////
 dataFile.close();
 Serial.println("Accelerometer data appended to SD card.");
 } else {
 Serial.println("Error opening data file.");
 }
}
//////////////////GPS CODE BELOW//////////////////////////////////////////////
void parseNMEA(char* sentence, char* latitude, char* longitude) {
 // Check if the sentence is a valid GPGGA sentence
 if (strncmp(sentence, "$GPGGA", 6) == 0) {
 char* token;
 token = strtok((char*)sentence, ",");
 // Skip the first few tokens until we reach latitude and longitude
 for (int i = 0; i < 2; i++) {
 token = strtok(NULL, ",");
 }
 // Copy latitude and longitude to the provided buffers
 strncpy(latitude, token, 10); // Assuming latitude is 10 characters long
 latitude[10] = '\0'; // Null-terminate the string
 token = strtok(NULL, ",");
 strncpy(longitude, token, 11); // Assuming longitude is 11 characters long
 longitude[11] = '\0'; // Null-terminate the string
 }
}
/////////////////////////GPS CODE ABOVE//////////////////////////////////////
void createFile(const char *filename) {
 // Open file in write mode (creates the file)
 File dataFile = SD.open(filename, FILE_WRITE);
 if (dataFile) {
 dataFile.println("Accelerometer data");
 dataFile.close();
 Serial.println("File created successfully.");
 } else {
 Serial.println("Error creating file.");
 }
}
