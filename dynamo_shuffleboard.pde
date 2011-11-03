static char latchPin = 5;
static char clockPin = 6;
static char dataPin = 7;
static char greenBtnPin = 3;
static char redBtnPin = 2;
static char resetBtnPin = 4;

static char led_codes1[10];
static char led_codes2[10];
static char green_score = 0;
static char red_score = 0;

void setup() {
  // set led # codes
  led_codes1[0] = 0xA8;
  led_codes2[0] = 0xA8;

  led_codes1[1] = 0x08;
  led_codes2[1] = 0x20;

  led_codes1[2] = 0x8A;
  led_codes2[2] = 0x88;

  led_codes1[3] = 0x8A;
  led_codes2[3] = 0x28;

  led_codes1[4] = 0x2A;
  led_codes2[4] = 0x20;

  led_codes1[5] = 0xA2;
  led_codes2[5] = 0x28;

  led_codes1[6] = 0xA2;
  led_codes2[6] = 0xA8;

  led_codes1[7] = 0xA8;
  led_codes2[7] = 0x20;

  led_codes1[8] = 0xAA;
  led_codes2[8] = 0xA8;

  led_codes1[9] = 0xAA;
  led_codes2[9] = 0x20;
  // set output mode for serial pins
  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, OUTPUT);
  pinMode(greenBtnPin, INPUT);
  pinMode(redBtnPin, INPUT);
  pinMode(resetBtnPin, INPUT);
  update_leds();
}

void update_leds() {
  char dig1 = green_score/10;
  char dig2 = green_score % 10;
  // GREEN LEDS
  shiftOut(dataPin, clockPin, MSBFIRST, led_codes1[dig1] | ((led_codes1[dig2] >> 1) & 0x7F));
  shiftOut(dataPin, clockPin, MSBFIRST, led_codes2[dig1] | ((led_codes2[dig2] >> 1) & 0x7F));
  shiftOut(dataPin, clockPin, LSBFIRST, 0x00);
  shiftOut(dataPin, clockPin, LSBFIRST, 0x00);


  // RED LEDS AREA
  dig1 = red_score/10;
  dig2 = red_score % 10;
  shiftOut(dataPin, clockPin, LSBFIRST, 0x00);
  shiftOut(dataPin, clockPin, LSBFIRST, 0x00);
  shiftOut(dataPin, clockPin, LSBFIRST, led_codes2[dig2] | ((led_codes2[dig1] >> 1) & 0x7F));
  shiftOut(dataPin, clockPin, LSBFIRST, led_codes1[dig2] | ((led_codes1[dig1] >> 1) & 0x7F));
  digitalWrite(latchPin, HIGH);
}



void loop() {
  char green_btn =  digitalRead(greenBtnPin);
  char red_btn =  digitalRead(redBtnPin);
  char reset_btn =  digitalRead(resetBtnPin);
  boolean update_score = false;
  if (green_btn == HIGH) {
    green_score++;
          delay(100);
    update_score = true;
  }
  if (red_btn == HIGH) {
          delay(100);
    red_score++;
    update_score = true;
  }
  if (reset_btn == HIGH) {
    red_score = green_score = 0;
    update_score = true; 
  }
  if (update_score) {
    update_leds();
  }
  while (digitalRead(greenBtnPin) == HIGH || digitalRead(redBtnPin) == HIGH || digitalRead(resetBtnPin) == HIGH) {

  };
}
