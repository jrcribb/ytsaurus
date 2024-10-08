### Устройство

В системе {{product-name}} есть [транзакции](../../../user-guide/storage/transactions.md), которые бывают мастерными и таблетными. Мастерные транзакции реализуют пессимистическую модель блокировок, то есть взятие блокировки на узел Кипариса происходит синхронно и при этом проверяются возможные конфликты.

Пользуясь пессимистической моделью, можно сделать простую конструкцию, эмулирующую распределённую блокировку:

1. Создаётся узел в Кипарисе (вне транзакций). Данный узел будет отвечать блокировке. Тип узла может быть любым, например `map_node`.
2. В том месте программы, где нужно взять блокировку на данный узел, создаётся транзакция. Под ней выполняется попытка взять эксклюзивную блокировку на узел.
3. Если блокировку взять удалось, то можно выполнять код, защищённый данной блокировкой. При этом важно пинговать транзакцию. В случае если вызов ping не удался или транзакция была отменена — эксклюзивность выполнения теряется, соответственно, необходимо предпринять какие-то действия, например прервать выполняющийся процесс.
4. Если блокировку взять **не** удалось, то нужно повторить процесс создания транзакции и взятия блокировки.

Как и в любой системе распределённых блокировок, если процесс (живущий под блокировкой) делает какие-то изменения в сторонней системе, которая никак не интегрирована с транзакциями {{product-name}}, — полностью гарантировать эксклюзивность невозможно. Например, между соседними вызовами ping транзакция могла быть прервана и запущен параллельный процесс, взявший блокировку на этот же узел.

Когда изменения выполняются на том же кластере, где берётся блокировка, стоит в запросах к кластеру использовать опцию `prerequisite_transactions` и указывать в ней транзакцию, под которой была взята блокировка. Тем самым система {{product-name}} гарантирует, что запрос будет выполнен только при условии, что транзакция жива (и, соответственно, взята блокировка).

### Использование

Для запуска процесса под блокировкой можно использовать команду [run-command-with-lock](../../../api/cli/commands.md#run-command-with-lock), а можно реализовать логику со взятием блокировки самостоятельно в коде приложения.

Если процесс выполняет какие-то изменения на кластере и должен делать их эксклюзивно, то рекомендуется использовать блокировку прямо на данном кластере.
