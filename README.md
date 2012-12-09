Проект 2. Приложение для синхронизации фотографий с iPhone
=============

Проблема
-------------
Как это ни странно, но на данный момент мне неизвстен нормальный способ переноса фотографий с iPhone на PC без ограничений. Конечно же есть прекрасное приложение DropBox, однако ограничение было довольно быстро достигнуто, покупать место не хочется. Таким образом, данное приложение должно решить проблему беспроводного переноса фотографий с iPhone на PC.

Аудитория приложения
-------------
В первую очередь это владельцы iPhone, которые хотя бы иногда пользуются iPhone как фотоаппаратом и хотят иметь удобный способ переноса получившихся фотографий на компьютер.

Сценарий использования
-------------
Для синхронизации нужно будет запустить специальное приложение на компьютере, которое будет принимать фотографии. Находясь в одной сети с компьютером, на iPhone запускается приложение и инициируется синхронизация.

Описание поведения
-------------
При загрузке приложение должно проверить имеется ли у него доступ к галерее фотографий пользователя. Следующим шагом либо загрузить список несинхронизированных фотографий с миниатюрами, либо показать сообщение об ошибке доступа как элемент списка фотографий.

Интерфейс приложения состоит из двух экранов.

### Экран синхронизации

![Sync screen](https://raw.github.com/vitalidze/osx-project-2/master/sync-screen.png)

Синхронизация происходит после нажатия на кнопку "Do Sync". В строках таблицы, которые в данный момент закачиваются на компьютер появляется progress bar с индикацией оставшегося времени.

### Экран настроек

![Settings screen](https://raw.github.com/vitalidze/osx-project-2/master/settings-screen.png)

* В поле "Enter server address here" вводится IP адрес или доменное имя комьютера, на который нужно закачать фотографии.

* Background sync - если включено, то синхронизация будет выполняться в фоновом режиме. Т.е. можно выйти из приложения, а синхронизация продолжится.

* Album sync - если включено, то фотографии разложатся по альбомам в соответствии с их расположением на iPhone. Для каждого альбома появится новая папка на компьютере. Если выключено, то все фотографии свалятся в одну папку компьютера.

* Video sync - если включено, то помимо фотографий на компьютер будет загружено вс] видео с iPhone.

### [Roadmap](https://github.com/vitalidze/osx-project-2/wiki/Roadmap)