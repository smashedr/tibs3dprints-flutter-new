# tibs3dprints

Tibs3DPrints Flutter Project

| Key                       | Value                            |
| ------------------------- | -------------------------------- |
| applicationId             | `org.cssnr.tibs3dprints.flutter` |
| PRODUCT_BUNDLE_IDENTIFIER | `org.cssnr.tibs3dprints.flutter` |

## Management Tasks

### Rename Application

```text
flutter pub global activate rename

dart pub global run rename setAppName --targets ios,android,web --value "Tibs3DPrints"
```

### Update Icons

Update the icons in [icon](assets/icon) and edit [flutter_launcher_icons.yaml](flutter_launcher_icons.yaml).

Then run:

```text
dart run flutter_launcher_icons
```
