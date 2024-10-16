# Автоматическое укрупнение чанков

Для статических таблиц {{product-name}} поддерживает возможность автоматического укрупнения чанков на стороне мастер-сервера. В отличие от операции [Merge](../../../../user-guide/data-processing/operations/merge.md), данный способ не использует вычислительные ресурсы пула.

Для того чтобы включить автоматическое укрупнение чанков, достаточно выставить у таблицы атрибут `@chunk_merger_mode` в одно из значений ниже:

- **shallow** — объединение чанков на уровне метаданных, без распаковки. Такой подход работает, только если чанки достаточно «похожи» (в плане сортированности, колонок, compression-кодека и т. д.). Также в какой-то момент у результирующего чанка может стать слишком много [блоков](../../../../user-guide/storage/chunks.md#chunk-size).
- **deep** — объединение чанков с полным пережатием (путём вычитывания всех входных чанков и записи в новый). Этот режим существенно более дорогой, чем предыдущий, но позволяет объединить чанки с разными характеристиками, которые оказались в одной таблице. Этот режим можно также использовать, чтобы избавиться от мелких блоков или чанков в старых форматах.
- **auto** (рекомендуется) — объединение чанков в shallow режиме с откатом в deep в случае неудачи.

 По умолчанию рекомендуется использовать `auto` (другие режимы тоже разрешены, но переключаться на них стоит, только хорошо понимая, зачем):

```bash
$ yt set //home/dir_with_tables/table_i_want_to_merge/@chunk_merger_mode auto
```

Если необходимо мержить все таблицы в определённом поддереве, атрибут можно выставить на всю директорию:

```bash
$ yt set //home/dir_with_tables/@chunk_merger_mode auto
```

{% note info "Примечание" %}

Данный механизм работает только для статических таблиц. Динамические таблицы имеют собственные механизмы укрупнения чанков. Выставление атрибута `chunk_merger_mode` для них ни к чему не приведёт.

{% endnote %}

Следует заметить, что `chunk_merger_mode` — это [наследуемый атрибут](../../../../user-guide/storage/chunks.md#common). Это означает, что после его установки его значение будут наследовать все новые таблицы в директории, но для старых ничего не поменяется, поэтому в момент включения следует дополнительно пройтись по всем таблицам.

Укрупнение чанков инициируется в момент установки атрибута и каждый раз при записи в таблицу (при этом, в случае дозаписи в качестве оптимизации система попытается перемержить лишь хвост таблицы).

{% if audience == "internal" %}
Также стоит обратить внимание, что автоматическое укрупнение не будет работать для аккаунта `tmp` (для всех остальных аккаунтов по умолчанию оно будет разрешено).

{% else %}

## Атрибуты укрупнения на аккаунте

Каждый аккаунт содержит атрибуты, позволяющие управлять механизмом укрупнения чанков:
- `allow_using_chunk_merger` — разрешено ли мержить чанки для таблиц этого аккаунта;
- `chunk_merger_node_traversal_concurrency` — количество таблиц, для которых можно одновременно запланировать мерж-джобы;
- `merge_job_rate_limit` — количество джобов, которое можно планировать в секунду.

По умолчанию эти настройки выставлены так, что автоматическое укрупнение чанков для каждого аккаунта будет включено.
{% endif %}

## Про диагностику

У таблиц есть несколько системных атрибутов, позволяющих узнать о текущем статусе укрупнения чанков. Эти атрибуты не отображаются в веб-интерфейсе — чтобы посмотреть их, следует запросить их через CLI.

- `@chunk_merger_status` — статус таблицы в пайплайне мержа, может принимать значения `not_in_merge_pipeline`, `awaiting_merge` и `in_merge_pipeline`. С момента срабатывания триггера для укрупнения чанков и до момента, когда мержер перестанет с таблицей что-либо делать, может пройти существенное количество времени. Если вы выставили `chunk_merger_mode` на таблицу, но чанки в ней всё ещё мелки, то стоит посмотреть на `chunk_merger_status` и дождаться, пока он станет `not_in_merge_pipeline`.

- `@chunk_merger_traversal_info/chunk_count` — количество уже обработанных мержером чанков, укрупнять которые больше не планируется. Может быть полезно для понимания, какие чанки уже не помержатся.

Пусть для некоторой таблицы было включено автоматическое укрупнение, после которого в ней осталась 1000 чанков, а теперь необходимо дописывать данные в конец таблицы. Рассматривать чанки с самого начала после каждой записи в таблицу нет смысла — если их не объединили до этого, то скорее всего, это не потребуется и сейчас. При этом может понадобиться склеить свежедобавленный чанк с некоторым количеством последних из старых. Так, если `@chunk_merger_traversal_info/chunk_count` равен, к примеру, 980, то в дальнейшем будут рассматриваться лишь последние 20 чанков, и именно их имеет смысл пытаться перемержить с новыми при будущих дозаписях.

Автоматическое укрупнение чанков не берёт локи на таблицы, поэтому перемерживание должно быть полностью незаметно и не мешать остальным процессам. Однако, у этого есть неприятное следствие: иногда такие мержи могут завершаться неудачей (например, если за время выполнения мержа таблица была полностью перезаписана новыми данными). Система автоматически ретраит неудавшиеся мержи в случае, если это возможно (это может быть невозможно, если таблица была удалена или стала динамической). Однако, если таблица часто перезаписывается новыми данными, такой процесс может сходиться долго.

{% if audience == "public" %}

## Метрики в Prometheus

Для сбора метрик по укрупнению чанков в Prometheus используются следующие временные ряды:
- `yt.chunk_server.chunk_merger_account_queue_size` — поаккаунтные очереди на укрупнение чанков. Если очередь аккаунта пуста, стоит убедиться, что выставлен правильный атрибут для всех нужных таблиц. Также следует убедиться, что настройки аккаунта позволяют мержить таблицы: атрибут `allow_using_chunk_merger` переключен в `true`, а в атрибутах `chunk_merger_node_traversal_concurrency` и `merge_job_rate_limit` не выставлен 0.

- `yt.chunk_server.chunk_merger_chunk_replacements_succeeded` — количество успешных мержей.

- `yt.chunk_server.chunk_merger_chunk_replacements_failed` — количество неудавшихся мержей.

Наличие определённого количества неудавшихся мержей — это нормально и полностью избавиться от них не получится, но если оно превышает количество успешных, то стоит обратить на это внимание. Возможно, мерж включен для таблиц, которые постоянно перезаписываются с нуля новыми данными, или очень недолгоживущих таблиц. В таком случае, автоматическое укрупнение для них лучше отключить.

{% else %}

Существует [дашборд](https://monitoring.yandex-team.ru/projects/yt/dashboards/monb2fccn9r74g9o9l8v/view?from=now-1h&to=now&refresh=60000&p.cluster=hahn&p.cell_tag=-&p.cell_id=-&p.container=-&p.account=-) с графиками метрик для самодиагностики.

Например, на этом [графике](https://monitoring.yandex-team.ru/projects/yt/dashboards/monb2fccn9r74g9o9l8v/view/graph/widget_001/queries?from=now-1h&to=now&refresh=60000&p%5Bcluster%5D=hahn&p%5Bcell_tag%5D=-&p%5Bcell_id%5D=-&p%5Bcontainer%5D=-&p%5Baccount%5D=-) видны поаккаунтные очереди на укрупнение чанков. Если очередь вашего аккаунта пуста, то стоит убедиться, что выставлен правильный атрибут для всех нужных таблиц (и если это так, но очередь по-прежнему всегда пуста, а таблицы не мержатся — сделать тикет в YTADMINREQ).

На другом [графике](https://monitoring.yandex-team.ru/projects/yt/dashboards/monb2fccn9r74g9o9l8v/view/graph/widget_008/queries?from=now-1h&to=now&refresh=60000&p%5Bcluster%5D=hahn&p%5Bcell_tag%5D=-&p%5Bcell_id%5D=-&p%5Bcontainer%5D=-&p%5Baccount%5D=-&infra=none) можно увидеть количество успешных и неудавшихся мержей. Наличие определённого количества неудавшихся мержей — это нормально, и полностью избавиться от них не получится, но если оно превышает количество успешных, то стоит обратить на это внимание. Возможно, мерж включен для таблиц, которые постоянно перезаписываются с нуля новыми данными, или для очень недолгоживущих таблиц. В таком случае автоматическое укрупнение для них лучше отключить.

{% endif %}
