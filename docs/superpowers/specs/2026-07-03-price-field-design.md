# Дизайн: PriceFieldApp (поле цены с форматированием)

Дата: 2026-07-03

## Цель

Новое поле ввода цены `PriceFieldApp` — как существующий `NumberFieldApp`, но с
форматированием разрядов при отображении («1 000 000»). Значение поле отдаёт как
чистый `int` (без разделителей); форматирование живёт только внутри поля.

Только компонент. Существующие экраны/кубиты/пайплайн цены **не трогаем** —
миграция будет отдельно.

## Текущее состояние

- `NumberFieldApp` (`lib/presentation/widgets/form/field/number_field.dart`) —
  `TextField` с `FilteringTextInputFormatter.digitsOnly`, без форматирования.
- Цена сейчас проходит по пайплайну как строка цифр (`controller.value.text` →
  `PriceFormModel` (`FormzInput<String>`) → на submit `int.tryParse`/`int.parse`).
  Этот пайплайн в рамках задачи не меняется.
- Форматирование цен в проекте: `Parser.toPrice` использует
  `NumberFormat('#,###')`.

## Компоненты

### 1. `PriceEditingController`
Файл: `lib/data/models/form/price_editing_controller.dart`

```
class PriceEditingController extends TextEditingController {
  PriceEditingController({int? value});   // начальный text = отформатированное value ('' если null)
  int? get number;                        // чистое число: снять нецифры, распарсить; null если пусто
}
```

- Группировка разрядов по 3 справа, разделитель — обычный пробел (' ').
- Общий хелпер группировки (например, top-level `groupThousands(String digits)`
  в этом же файле) используется и конструктором, и форматтером поля — без
  дублирования.
- `number`: `text.replaceAll(RegExp(r'[^0-9]'), '')`, `isEmpty ? null : int.parse(...)`.

### 2. Форматтер разрядов
`TextInputFormatter` (в файле `price_field.dart` или рядом с контроллером):
- На каждое изменение: снять нецифры → сгруппировать через `groupThousands` →
  вернуть `TextEditingValue` с курсором в конце (`TextSelection.collapsed(offset:
  text.length)`). Курсор-в-конец — стандартно для таких полей, не костыль.

### 3. `PriceFieldApp`
Файл: `lib/presentation/widgets/form/field/price_field.dart`

- Пропсы идентичны `NumberFieldApp`: `{PriceEditingController? controller,
  String? label, Widget? icon, String? errorText}`.
- Разметка/декорация копируют `NumberFieldApp` (label, контейнер, error).
- `TextField`: `keyboardType: TextInputType.number`, `inputFormatters:
  [форматтер разрядов]`, `controller: controller`.

  Примечание: `icon` в `NumberFieldApp` объявлен, но в разметку не встроен —
  сохраняем такое же поведение для совместимости API (не расширяем сверх YAGNI).

## Данные / поток

- Потребитель создаёт `PriceEditingController(value: initial)`, передаёт в
  `PriceFieldApp`, а для отправки читает `controller.number` (int?). Внутри поля
  текст всегда отформатирован; наружу уходит чистое число.

## Вне объёма (YAGNI)

- Миграция существующих ценовых полей и int-ификация Formz-пайплайна.
- Копейки/десятичные (только целые, как сейчас).
- Ограничение максимальной длины, валюта, локале-зависимый разделитель.
- Ценовые фильтры в `filter_ad_*_bottom_sheet`.

## Проверка

- Unit-тест `test/data/models/form/price_editing_controller_test.dart`:
  - `PriceEditingController(value: 1000000).text == '1 000 000'`;
  - `.number == 1000000`;
  - пустой контроллер → `.number == null`;
  - `groupThousands('1000000') == '1 000 000'`, `groupThousands('') == ''`.
- `flutter analyze` по новым файлам — без ошибок.
