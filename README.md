# WorkNotes

### Making a Bootable Windows 10 USB Drive on macOS High Sierra

Erease usb disk:
```
diskutil eraseDisk MS-DOS "WINDOWS10" MBR disk#
```

Open the Windows 10 ISO, it mount as a volume named CCCOMA_X64FRE_XX_DV9, use the following command to copy its contents to the USB drive:
```
cp -rp /Volumes/CCCOMA_X64FRE_EN-US_DV9/* /Volumes/WINDOWS10/
```
