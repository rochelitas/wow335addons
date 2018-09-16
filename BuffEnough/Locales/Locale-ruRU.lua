local L = LibStub("AceLocale-3.0"):NewLocale("BuffEnough", "ruRU")
if not L then return end

-- basics

L["BuffEnough"] = true
L["Buff Enough"] = true
L["buffenough"] = true
L["be"] = true

L["Yes"] = "Да"
L["No"] = "Нет"
L["Warning"] = "Предупреждение"

-- config strings

L["config"] = true
L["Toggle the configuration dialog"] = "Вкл/выкл конфигуратор"

L["General"] = "Общее"
L["Log Level"] = "Уровень отладки"
L["Determines the amount of output from the addon"] = "Определяет объём журналирование аддона"
L["Enable While Solo"] = "Включить в режиме соло"
L["Enable BuffEnough while not in a party/raid"] = "Включить BuffEnough когда не в группе/рейде"
L["Check In Combat"] = "Проверять в бою"
L["Continue to do buff checks even while in combat"] = "Продолжать проверять баффы даже во время боя"
L["Warn"] = "Предупреждать о скором окончании"
L["Display shows warning color when you are buff enough but one or more buffs is about to expire"] = "Показывать цвет предупреждения когда все баффы есть, но один или более баффов скоро закончатся"
L["Warn Minimum Buff Time"] = "Минимальное время предупреждение"
L["The minimum buff duration in minutes before we check for expiration. Set to 0 for no minimum"] = "Минимальное время баффа в минутах до проверки на окончание. Установите в 0 для отключения минимума"
L["Warn Threshold"] = "Граница предупреждения"
L["The number of minutes left on the buff before we warn"] = "Оставшееся время баффа в минутах до предупреждения о скором окончании"
L["Fade"] = "Угасание"
L["Fade frame after this many seconds of being buff enough. Set to 0 for no fading"] = "Угасание интерфейса после стольки секунд. Установите в 0 для отключения"

L["Blessings"] = "Благословения"
L["None"] = "Нет"
L["Override"] = "Задать вручную"
L["Overrides the default paladin blessing priority and uses the priority you specify."] = "Задание вручную приоритетов благословений паладинов"
L["Blessing"] = "Благлословение"

L["Consumables"] = "Еда и настои"
L["Check Flask/Elixirs"] = "Проверять настой/эликсиры"
L["Check whether or not you have either a flask or Guardian and Battle elixirs"] = "Проверять наличие настоя или Боевого и Охранного эликсиров"
L["Check Food"] = "Проверять сытость"
L["Check whether or not you have a food buff"] = "Проверять наличие баффа сытости на Вас"
L["Check Pet Food"] = "Проверять сытость питомца"
L["Check whether or not your pet has a food buff"] = "Проверять наличие баффа сытости на Вашем питомце"
L["Check Weapon"] = "Проверять оружие"
L["Check whether or not you have a temporary weapon enchant"] = "Проверять наличие временного зачарования оружия"
L["Check Chest"] = "Проверять Охранную руну"
L["Check whether or not your chest has a Rune of Warding"] = "Проверять наличие Охранной руны"
L["Only Check In Raid"] = "Проверять только в рейде"
L["Only check consumable use when in a raid"] = "Проверять еду и настои только в рейде"

L["Custom"] = "Ручная настройка"
L["Select the desired category and behavior from the dropdown menu and enter the name of a buff. You can use this to ignore an existing buff check or add a new one."] = "Выберите категорию и действие, затем впишите имя баффа для ручной настройки."
L["You must select an action and category from the dropdown menu to associate with this buff"] = "Вы должны выбрать действие и категорию из выпадающих списков"
L["You must enter a value for the buff name"] = "Вы должны ввести имя баффа"
L["Buff"] = "Бафф"
L["Action"] = "Действие"
L["Category"] = "Категория"
L["Expected"] = "Ожидаемо"
L["Ignored"] = "Игнорируется"
L["Delete"] = "Удалить"
L["Are you sure you want to delete this custom buff?"] = "Вы уверены что хотите удалить этот бафф?"

L["Display"] = "Отображение"
L["Show Display"] = "Показывать интерфейс"
L["Shows the display"] = "Показывает интерфейс"
L["Lock"] = "Закрепить"
L["Lock the display"] = "Закрепляет интерфейс"
L["Scale"] = "Масштаб"
L["Scale of the display"] = "Мастшаб интерфейса"
L["Opacity"] = "Непрозрачность"
L["Opacity of the display"] = "Непрозрачность интерфейса"
L["Strata"] = "Уровень (страта)"
L["Strata of the display"] = "Страта интерфейса"
L["Buff Color"] = "Цвет наличия баффов"
L["Color to display when you are buff enough"] = "Цвет интерфейса при наличии всех баффов"
L["Unbuff Color"] = "Цвет отсутствия баффов"
L["Color to display when you are not buff enough"] = "Цвет интерфейса при отсутствии некоторых баффов"
L["Warn Buff Color"] = "Цвет предупреждения баффов"
L["Color to display when you are buffs are at a warning level"] = "Цвет интерфейса при предупреждении о некоторых баффах"
L["Border Color"] = "Цвет границы"
L["Color of the display border"] = "Цвет границы интерфейса"
L["Border Size"] = "Толщина границы"
L["Thickness of the display border"] = "Толщина границы интерфейса"
L["Background Inset"] = "Глубина границы"
L["How far inside the border to set the background of the display"] = "Глубина фона относительно границы"
L["Background Texture"] = "Текстура фона"
L["The background texture of the display"] = "Фоновая текстура интерфейса"
L["Border Texture"] = "Текстура границы"
L["The border texture of the display"] = "Текстура границы интерфейса"

L["Check Pet Buffs"] = "Проверять баффы питомца"
L["Check pet for the same raid buffs as the player"] = "Проверять питомца на те же баффы что и игрока"

L["Profile: %s"] = "Профиль: %s"

-- gear

L["HeadSlot"] = "Голова"
L["NeckSlot"] = "Шея"
L["ShoulderSlot"] = "Плечи"
L["BackSlot"] = "Спина"
L["ChestSlot"] = "Грудь"
L["WristSlot"] = "Запястья"
L["HandsSlot"] = "Кисти рук"
L["WaistSlot"] = "Пояс"
L["LegsSlot"] = "Ноги"
L["FeetSlot"] = "Ступни"
L["Finger0Slot"] = "Кольцо1"
L["Finger1Slot"] = "Кольцо2"
L["Trinket0Slot"] = "Аксессуар1"
L["Trinket1Slot"] = "Аксессуар2"
L["MainHandSlot"] = "Основное оружие"
L["SecondaryHandSlot"] = "Второе оружие/Щит"
L["RangedSlot"] = "Дополнительно"

L["Mainhand Buff"] = "Зачарование оружия"
L["Offhand Buff"] = "Зачарование второго оружия"
L["Rune of Warding"] = "Охранная руна"

-- tooltip output

L["Buffs"] = "Баффы"
L["Gear"] = "Обмундирование"
L["Pet"] = "Питомец"

L["Missing"] = "Отсутствует"
L["Broken"] = "Сломано"
L["Unexpected"] = "Неожиданно"
L["Low"] = "Заканчивается"
L["Unhappy"] = "Несчастлив"

L["Aura"] = "Аура"

L["Hint"] = "\n\n|cffafa4ffХинт:|r |cffffffffLeft-click для проверки|r\n|cffafa4ffХинт:|r |cffffffffRight-click для отчёта о пропущенных баффах|r\n|cffafa4ffХинт:|r |cffffffffShift-right-click для шёпота пропущенных баффов|r"
L["No buffer known for "] = "Неизвестный баффер"
L["All buffs accounted for!"] = "Все баффы присутствуют!"
L["Currently disabled"] = "Отключено"

-- buffs

L["Mage/Molten Armor"] = "Магический/Раскалённый доспех"
L["Fel/Demon Armor"] = "Доспех Скверны/Демонов"
L["Aspect"] = "Дух охотника"
L["Elemental Shield"] = "Щит стихий"
L["Flask/Elixirs"] = "Настой/Эликсиры"
L["Flask of"] = "Настой "
L["of Shattrath"] = " настой "
L["Battle Elixir"] = "Боевой эликсир"
L["Guardian Elixir"] = "Охранный эликсир"

-- log levels

L["NONE"] = "Disabled"
L["ERROR"] = "Errors only"
L["WARN"] = "Errors and warnings"
L["INFO"] = "Informational messages"
L["DEBUG"] = "Debug messaging"
L["TRACE"] = "Debug trace messages"
L["SPAM"] = "Everything"