import sensor from '@ohos.sensor';
import batteryInfo from '@ohos.batteryInfo';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import router from '@ohos.router';
import { requestPermissions } from '../common/Permissions';
import { formatClock } from '../common/TimeFormat';
import { formatBattery, isValidHeartRate, roundHeartRate } from '../common/Formatting';
import { DEFAULT_SETTINGS, hrIntervalToNanos } from '../common/AppSettings';
import { loadSettings } from '../common/SettingsStore';

@Entry
@Component
struct Index {
  @State currentTime: string = '00:00';
  @State heartRate: number = 0;
  @State batteryLevel: number = 0;
  @State hrStatus: string = 'Connecting...';
  @State use24Hour: boolean = DEFAULT_SETTINGS.use24HourClock;

  private timeInterval: number = -1;
  private hrSensorStarted: boolean = false;
  private hrIntervalNanos: number = hrIntervalToNanos(DEFAULT_SETTINGS.hrIntervalSeconds);

  aboutToAppear(): void {
    this.updateTime();
    this.updateBattery();
    this.init();

    this.timeInterval = setInterval(() => {
      this.updateTime();
      this.updateBattery();
    }, 1000);
  }

  // Re-applies settings when returning from the settings page.
  onPageShow(): void {
    this.applySettings();
  }

  private async init(): Promise<void> {
    await this.applySettings();
    this.initHeartRate();
  }

  private async applySettings(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    const settings = await loadSettings(context);
    this.use24Hour = settings.use24HourClock;
    this.updateTime();

    const nanos = hrIntervalToNanos(settings.hrIntervalSeconds);
    if (nanos !== this.hrIntervalNanos) {
      this.hrIntervalNanos = nanos;
      if (this.hrSensorStarted) {
        try {
          sensor.off(sensor.SensorId.HEART_RATE);
        } catch (e) {
          console.error('D2Prototype', 'Failed to restart HR sensor: ' + JSON.stringify(e));
        }
        this.hrSensorStarted = false;
        this.startHeartRateSensor();
      }
    }
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
    this.currentTime = formatClock(now.getHours(), now.getMinutes(), this.use24Hour);
  }

  private updateBattery(): void {
    try {
      this.batteryLevel = batteryInfo.batterySOC;
    } catch (e) {
      this.batteryLevel = -1;
    }
  }

  private async initHeartRate(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    const granted = await requestPermissions(context, ['ohos.permission.READ_HEALTH_DATA']);
    if (granted) {
      this.startHeartRateSensor();
    } else {
      this.hrStatus = 'Permission denied';
    }
  }

  private startHeartRateSensor(): void {
    try {
      sensor.on(sensor.SensorId.HEART_RATE, (data) => {
        if (isValidHeartRate(data.heartRate)) {
          this.heartRate = roundHeartRate(data.heartRate);
          this.hrStatus = '';
        }
      }, { interval: this.hrIntervalNanos });
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
        Text(` ${formatBattery(this.batteryLevel)}`)
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

      // Navigation to sub-pages
      Row() {
        Text('👣')
          .fontSize(20)
          .padding(8)
          .onClick(() => {
            router.pushUrl({ url: 'pages/StepsPage' });
          })
        Text('⚙')
          .fontSize(20)
          .fontColor('#AAAAAA')
          .padding(8)
          .margin({ left: 16 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/SettingsPage' });
          })
      }
      .margin({ top: 14 })
      .justifyContent(FlexAlign.Center)
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
