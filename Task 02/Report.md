# Задание 2. Файловые системы. Файлы и права доступа

### Ганиев Ришат Анасович, группа 11-902

Добавление дополнительного диска размером 10 Гб (размер динамический):
![Второй диск](https://raw.githubusercontent.com/rishat19/OS-ITIS/main/Task%2002/Screenshots/01.png)

Подключение к локальной виртуальной машине Linux по SSH:
`ssh -l rishat -p 2222 127.0.0.1`

Переход в пользователя root:
`sudo -i`

Просмотр списка блочных устройств:
`lsblk`
![lsblk](https://raw.githubusercontent.com/rishat19/OS-ITIS/main/Task%2002/Screenshots/02.png)

sdb - добавленный дополнительный диск

Выполнение разметки дополнительного диска в интерактивном режиме при помощи утилиты fdisk. Для запуска fdisk в интерактивном режиме нужно передать утилите блочное устройство, которое надо разметить, а именно /dev/sdb:
`fdisk /dev/sdb`

Последовательность использованных команд:
`g` - создание таблицы разделов в формате GPT
`n` - создание нового раздела
	- оставляем номер раздела по умолчанию
	- оставляем первый сектор по умолчанию
	- `+5G` устанавливаем размер в 5G
`n` - создание нового раздела
	- оставляем номер раздела по умолчанию
	- оставляем первый сектор по умолчанию
	- оставляем последний сектор по умолчанию
`p` - вывод таблицы разделов
`w` - запись новой таблицы разделов на диск
![fdisk](https://raw.githubusercontent.com/rishat19/OS-ITIS/main/Task%2002/Screenshots/03.png)

Для форматирования используем утилиту mkfs.ext2 со следующими опциями:
`-L` - задание метки для раздела с данной файловой системой
`-m` - процент блоков, зарезервированных для пользователя root

Раздел 1: создание файловой системы «ext2» с меткой «Docs», для пользователя root резервируется 1%:
`mkfs.ext2 -L "Docs" -m 1 /dev/sdb1`

Раздел 2: создание файловой системы «ext2» с меткой «Work», для пользователя root резервируется 5%:
`mkfs.ext2 -L "Work" -m 5 /dev/sdb2`

Настройка автомонтирования созданных файловых систем, редактирование файла /etc/fstab:
`nano /etc/fstab`

Добавим 2 строки в формате:
`устройство` `точка_монтирования` `файловая_система` `опции` `резерв` `проверка`
`устройство` - раздел диска, который нужно примонтировать
`точка_монтирования` - куда нужно примонтировать это устройство
`файловая_система` - указывает в какой файловой системе нужно монтировать это устройство
`опции` - параметры монтирования файловой системы
`резерв` - указывает нужно ли делать резервную копию раздела, может принимать значения только 0 и 1.
`проверка` - очередь проверки устройство на ошибки
![fstab](https://raw.githubusercontent.com/rishat19/OS-ITIS/main/Task%2002/Screenshots/04.png)
При загрузке операционной системы созданные файловые системы будут монтироваться автоматически:
1. Файловая система с меткой «Docs» в директорию /media/docs,
2. Файловая система с меткой «Work» в директорию /mnt/work.

Перезагрузка для принятия изменений:
`reboot`

Просмотр списка блочных устройств с опцией `-f` (вывод информации о файловых системах ):
`lsblk -f`
![lsblk](https://raw.githubusercontent.com/rishat19/OS-ITIS/main/Task%2002/Screenshots/05.png)
Стоит обратить внимание на FSTYPE и MOUNTPOINT

Создание групп пользователей developers, managers, writers:
`addgroup developers`
`addgroup managers`
`addgroup writers`

Создание пользователей и их добавление в соответствующие группы при помощи опции `-G`:
`-G group` - добавление нового пользователя в group вместо группы пользователей или группы по умолчанию, определенной USERS GID в файле конфигурации
`useradd -G developers woody`
`useradd -G developers buzz`
`useradd -G managers potato`
`useradd -G managers slinky`
`useradd -G writers rex`
`useradd -G writers sid`

Просмотр того, что пользователи добавлены в нужные группы:
`cat /etc/group`
![groups](https://raw.githubusercontent.com/rishat19/OS-ITIS/main/Task%2002/Screenshots/06.png)

Переход в директорию /media/docs:
`cd /media/docs`

Создание  в директории /media/docs поддиректорий manuals, reports, todo:
`mkdir manuals`
`mkdir reports`
`mkdir todo`

Смена владельца и группы владельца для поддиректорий manuals, reports, todo:
`chown rex:writers manuals`
`chown potato:managers reports`
`chown woody:developers todo`

Изменение прав доступа для владельца, для группы и для всех остальных:
`chmod 2775 manuals` - rwx rws r-x
`chmod 2770 reports` - rwx rws ---
`chmod 0755 todo` - rwx r-x r-x

Просмотр внесённых изменений:
`ls -l`
![chmod](https://raw.githubusercontent.com/rishat19/OS-ITIS/main/Task%2002/Screenshots/07.png)

Переход в директорию /mnt/work:
`cd /mnt/work`

Создание  в директории /mnt/work поддиректорий writers, managers, developers:
`mkdir writers`
`mkdir managers`
`mkdir developers`

Смена владельца и группы владельца для поддиректорий writers, managers, developers:
`chown rex:writers writers`
`chown potato:managers managers`
`chown woody:developers developers`

Изменение прав доступа для владельца, для группы и для всех остальных:
`chmod 2770 writers` - rwx rws ---
`chmod 2770 managers` - rwx rws ---
`chmod 2770 developers` - rwx rws ---

Просмотр внесённых изменений:
`ls -l`
![chmod](https://raw.githubusercontent.com/rishat19/OS-ITIS/main/Task%2002/Screenshots/08.png)

Переход в директорию /mnt/work/developers:
`cd /mnt/work/developers`

Создание мягких ссылок для директории /mnt/work/developers (`ln` - создает ссылки между файлами, `-s` - создаёт символьные/мягкие ссылки вместо жестких ссылок):
`ln -s /media/docs/manuals docs` - ссылка docs на /media/docs/manuals
`ln -s /media/docs/todo todo` - ссылка todo на /media/docs/todo todo

Просмотр внесённых изменений:
`ls -l`
![chmod](https://raw.githubusercontent.com/rishat19/OS-ITIS/main/Task%2002/Screenshots/09.png)
