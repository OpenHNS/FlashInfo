# Flash Notifier
Flash Notifier for Hide'n'Seek Counter-Strike 1.6 

## Requirements
- [ReHLDS](https://dev-cs.ru/resources/64/)
- [Amxmodx 1.9.0](https://www.amxmodx.org/downloads-new.php)
- [Reapi (last)](https://dev-cs.ru/resources/73/updates)
- [ReGameDLL (last)](https://dev-cs.ru/resources/67/updates)

## Description

The plugin displays information about FULLY blinded CTs in the chat, does not blind the observer and shows the state of blindness, intended for the Hide'n'Seek mod.

Displays in the chat (FULL FLASH):
- Everyone except the CT team  ![1](https://github.com/OpenHNS/FlashInfo/assets/63194135/dc53da49-ca41-477f-91dc-fcd81805fc68)

- CT command  ![2](https://github.com/OpenHNS/FlashInfo/assets/63194135/64e373fc-513a-4443-8c6e-f2cfc21d4160)

- Observers
  
  Observers are not flashed.

  Shows the status of the flash. Full flashed (Crane) - completely blinded, Flashed (Green) - blinded by half or less.

  ![3](https://github.com/OpenHNS/FlashInfo/assets/63194135/74638416-7b24-4dcc-aede-7f4cece3e0ba)

## Console commands (cvars)
| Cvar                 | Default    | Description |
| :------------------- | :--------: | :--------------------------------------------------- |
| flash_spec          | 1         | `1` - Doesn't blind spectators, in dhud shows player's blinding state (Full flashed/Flashed) `0` - Blinds spectators. |

## Installation
 
1. Compile the plugin.

2. Copy the compiled `.amxx` file to the directory: `amxmodx/plugins/`

3. Write `.amxx` in `amxmodx/configs/plugins.ini` file

4. Restart the server or change the map.
