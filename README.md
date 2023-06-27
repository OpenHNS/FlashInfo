# Flash Notifier
Flash Notifier для Hide'n'Seek Counter-Strike 1.6 

## Требования
- [ReHLDS](https://dev-cs.ru/resources/64/)
- [Amxmodx 1.9.0](https://www.amxmodx.org/downloads-new.php)
- [Reapi (last)](https://dev-cs.ru/resources/73/updates)
- [ReGameDLL (last)](https://dev-cs.ru/resources/67/updates)

## Описание

Плагин выводит в чат информацию ПОЛНОСТЬЮ ослепленных КТ, не слепит наблюдателя и показывает состояние ослепления, предназначенный для Hide'n'Seek мода.

В чат выводит (ФУЛЛ ФЛЕШ):
- Всем, кроме команды КТ ![1](https://github.com/OpenHNS/FlashInfo/assets/63194135/dc53da49-ca41-477f-91dc-fcd81805fc68)

- Команде КТ ![2](https://github.com/OpenHNS/FlashInfo/assets/63194135/64e373fc-513a-4443-8c6e-f2cfc21d4160)

- Наблюдатели
  
  Наблюдателей не флешет.

  Показывает состояние флеша. Full flashed (Краным) - полностью ослеплен, Flashed (Зеленым) - ослеплен на половину и меньше.

  ![3](https://github.com/OpenHNS/FlashInfo/assets/63194135/74638416-7b24-4dcc-aede-7f4cece3e0ba)

## Консольные команды (квары)
| Cvar                 | Default    | Description |
| :------------------- | :--------: | :--------------------------------------------------- |
| flash_spec          | 1         | `1` - Не слепит наблюдателей, в dhud показывает состояние ослепления игрока (Full flashed/Flashed)  `0` - Слепит наблюдателей. |

## Установка
 
1. Скомпилируйте плагин.

2. Скопируйте скомпилированный файл `.amxx` в директорию: `amxmodx/plugins/`

3. Пропишите `.amxx` в файле `amxmodx/configs/plugins.ini`

4. Перезапустите сервер или поменяйте карту.
