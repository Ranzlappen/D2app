import sensor from '@ohos.sensor';
import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { requestPermissions } from '../common/Permissions';

@Entry
@Component
struct StepsPage {
  @State steps: number = -1;
  @State status: string = 'Connecting...';

  private pedometerStarted: boolean = false;

  aboutToAppear(): void {
    this.initPedometer();
  }

  aboutToDisappear(): void {
    if (this.pedometerStarted) {
      try {
        sensor.off(sensor.SensorId.PEDOMETER);
      } catch (e) {
        console.error('D2Prototype', 'Failed to stop pedometer: ' + JSON.stringify(e));
      }
    }
  }

  private async initPedometer(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    const granted = await requestPermissions(context, ['ohos.permission.ACTIVITY_MOTION']);
    if (!granted) {
      this.status = 'Permission denied';
      return;
    }
    try {
      sensor.on(sensor.SensorId.PEDOMETER, (data) => {
        this.steps = data.steps;
        this.status = '';
      });
      this.pedometerStarted = true;
      this.status = 'Counting...';
    } catch (e) {
      console.error('D2Prototype', 'Pedometer unavailable: ' + JSON.stringify(e));
      this.status = 'Unavailable';
    }
  }

  build() {
    Column() {
      Text('👣')
        .fontSize(26)
        .margin({ top: 24 })

      if (this.steps >= 0) {
        Text(`${this.steps}`)
          .fontSize(48)
          .fontWeight(FontWeight.Medium)
          .fontColor('#7BE38B')
          .margin({ top: 8 })
        Text('steps')
          .fontSize(14)
          .fontColor('#88AA8E')
          .margin({ top: 2 })
      } else {
        Text(this.status)
          .fontSize(16)
          .fontColor('#88AA8E')
          .margin({ top: 20 })
      }

      Column() {
        Text('‹ Back')
          .fontSize(14)
          .fontColor('#66CCFF')
      }
      .width(100)
      .height(40)
      .borderRadius(20)
      .backgroundColor('#1A3A5C')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 28 })
      .onClick(() => {
        router.back();
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
