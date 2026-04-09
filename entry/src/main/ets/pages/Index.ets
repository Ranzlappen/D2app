import sensor from '@ohos.sensor';
import batteryInfo from '@ohos.batteryInfo';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct Index {
  @State currentTime: string = '00:00';
  @State heartRate: number = 0;
  @State batteryLevel: number = 0;
  @State hrStatus: string = 'Connecting...';

  private timeInterval: number = -1;
  private hrSensorStarted: boolean = false;

  aboutToAppear(): void {
    this.updateTime();
    this.updateBattery();
    this.startHeartRateSensor();

    this.timeInterval = setInterval(() => {
      this.updateTime();
      this.updateBattery();
    }, 1000);
  }

  aboutToDisappear(): void {
    if (this.timeInterval !== -1) {
      clearInterval(this.timeInterval);
    }
    if (this.hrSensorStarted) {
      try {
        sensor.off(sensor.SensorId.HEART_RATE);
      } catch (e) {
        console.error('D2Prototype', 'Failed to stop HR sensor: ' + JSON.stringify(e));
      }
    }
  }

  private updateTime(): void {
    const now = new Date();
    const hours = now.getHours().toString().padStart(2, '0');
    const minutes = now.getMinutes().toString().padStart(2, '0');
    this.currentTime = `${hours}:${minutes}`;
  }

  private updateBattery(): void {
    try {
      this.batteryLevel = batteryInfo.batterySOC;
    } catch (e) {
      this.batteryLevel = -1;
    }
  }

  private startHeartRateSensor(): void {
    try {
      sensor.on(sensor.SensorId.HEART_RATE, (data) => {
        if (data.heartRate > 0) {
          this.heartRate = Math.round(data.heartRate);
          this.hrStatus = '';
        }
      }, { interval: 3000000000 }); // ~3 seconds in nanoseconds
      this.hrSensorStarted = true;
      this.hrStatus = 'Measuring...';
    } catch (e) {
      console.error('D2Prototype', 'HR sensor unavailable: ' + JSON.stringify(e));
      this.hrStatus = 'Unavailable';
    }
  }

  build() {
    Column() {
      // Clock display
      Text(this.currentTime)
        .fontSize(56)
        .fontWeight(FontWeight.Lighter)
        .fontColor('#FFFFFF')
        .letterSpacing(4)
        .margin({ top: 30 })

      // Heart rate
      Row() {
        Text('\u2764')
          .fontSize(18)
          .fontColor('#FF4D6A')
        if (this.heartRate > 0) {
          Text(` ${this.heartRate}`)
            .fontSize(22)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FF4D6A')
          Text(' bpm')
            .fontSize(13)
            .fontColor('#FF8A9E')
            .margin({ left: 2 })
        } else {
          Text(` ${this.hrStatus}`)
            .fontSize(14)
            .fontColor('#FF8A9E')
            .margin({ left: 4 })
        }
      }
      .margin({ top: 16 })
      .justifyContent(FlexAlign.Center)

      // Battery level
      Row() {
        Text('\uD83D\uDD0B')
          .fontSize(14)
        Text(this.batteryLevel >= 0 ? ` ${this.batteryLevel}%` : ' --')
          .fontSize(14)
          .fontColor('#AAAAAA')
          .margin({ left: 4 })
      }
      .margin({ top: 10 })
      .justifyContent(FlexAlign.Center)

      // Tap area
      Column() {
        Text('Tap me')
          .fontSize(14)
          .fontColor('#66CCFF')
      }
      .width(120)
      .height(44)
      .borderRadius(22)
      .backgroundColor('#1A3A5C')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 24 })
      .onClick(() => {
        promptAction.showToast({
          message: 'Hello from custom D2 app!',
          duration: 2000
        });
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000000')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .borderRadius('50%')
    .padding(12)
  }
}
