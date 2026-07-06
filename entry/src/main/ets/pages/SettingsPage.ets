import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { DEFAULT_SETTINGS, nextHrInterval } from '../common/AppSettings';
import type { AppSettings } from '../common/AppSettings';
import { loadSettings, saveSettings } from '../common/SettingsStore';

@Entry
@Component
struct SettingsPage {
  @State use24Hour: boolean = DEFAULT_SETTINGS.use24HourClock;
  @State hrIntervalSeconds: number = DEFAULT_SETTINGS.hrIntervalSeconds;

  aboutToAppear(): void {
    this.load();
  }

  private async load(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    const settings = await loadSettings(context);
    this.use24Hour = settings.use24HourClock;
    this.hrIntervalSeconds = settings.hrIntervalSeconds;
  }

  private async persist(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    const settings: AppSettings = {
      use24HourClock: this.use24Hour,
      hrIntervalSeconds: this.hrIntervalSeconds
    };
    await saveSettings(context, settings);
  }

  build() {
    Column() {
      Text('Settings')
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor('#FFFFFF')
        .margin({ top: 20 })

      Row() {
        Text('24-hour clock')
          .fontSize(14)
          .fontColor('#CCCCCC')
        Toggle({ type: ToggleType.Switch, isOn: this.use24Hour })
          .selectedColor('#66CCFF')
          .margin({ left: 10 })
          .onChange((isOn: boolean) => {
            this.use24Hour = isOn;
            this.persist();
          })
      }
      .margin({ top: 22 })
      .justifyContent(FlexAlign.Center)

      Column() {
        Text(`❤ every ${this.hrIntervalSeconds}s`)
          .fontSize(14)
          .fontColor('#FF8A9E')
      }
      .width(130)
      .height(40)
      .borderRadius(20)
      .backgroundColor('#3A1A24')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 16 })
      .onClick(() => {
        this.hrIntervalSeconds = nextHrInterval(this.hrIntervalSeconds);
        this.persist();
      })

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
      .margin({ top: 20 })
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
