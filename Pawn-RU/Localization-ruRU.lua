-- Pawn by Vger-Azjol-Nerub
-- 
-- Russian Resources (by Warr, demonday and bokomatic)

------------------------------------------------------------

if (GetLocale() == "ruRU") then

------------------------------------------------------------
-- "Constants"
------------------------------------------------------------

PawnQuestionTexture = "|TInterface\\AddOns\\Pawn-RU\\Textures\\Question:0|t" -- Texture string that represents a (?).  Don't need to localize this.
PawnUINoScale = "(нет)" -- The name that shows up in lists of scales if you have no scales

------------------------------------------------------------
-- Master table of stats
------------------------------------------------------------

-- The master list of all stats that Pawn supports.
-- First column is the friendly translated name of the stat.
-- Second column is the Pawn name of the stat; this can't be translated.
-- Third column is the description of the stat.
-- Fourth column is true if the stat can't be ignored.
-- Fifth column is an optional chunk of text instead of the "1 ___ is worth:" prompt.
-- If only a name is present, the row becomes an uneditable header in the UI and is otherwise ignored.
PawnStats =
{
	{"Базовые статы"},
	{"Сила", "Strength", "Первичный стат, сила."},
	{"Ловкость", "Agility", "Первичный стат, ловкость."},
	{"Выносливость", "Stamina", "Первичный стат, выносливость."},
	{"Интеллект", "Intellect", "Первичный стат, интеллект."},
	{"Дух", "Spirit", "Первичный стат, дух."},
	
	{"Гнезда"},
	{"Красное гнездо", "RedSocket", "Пустое красное гнездо. Подсчитывается только значение без камня.", true},
	{"Желтое гнездо", "YellowSocket", "Пустое желтое гнездо. Подсчитывается только значение без камня.", true},
	{"Синее гнездо", "BlueSocket", "Пустое синее гнездо. Подсчитывается только значение без камня.", true},
	{"Особое: статы", "MetaSocket", "An empty meta socket.  Only counts the stat bonus of a meta gem, not the additional effect.  The item's value will be the same whether or not the meta gem requirements are met.", true},
	{"Особое: эффект", "MetaSocketEffect", "A meta socket, whether empty or full.  Only counts the additional effect of a meta gem, not its stat bonus.", true},
	
	{"Статы оружия"},
	{"УВС", "Dps", "Урон в секунду для оружия.  (Если хотите считать УВС по разному для различных типов оружия, см. \"Спец статы оружия\".)"},
	{"Скорость", "Speed", "Скорость использования оружия, в секундах на удар.  (Если предпочитаете быстрое оружие, это значение должно быть отрицательным.  См. также : \"основы скорости\" в \"Спец статы оружия\".)"},
	
	{"Гибридные рейтинги"},
	{"Рейтинг меткости", "HitRating", "Рейтинг меткости. Затрагивает ближний бой, стрельбу и заклинания."},
	{"Рейтинг критов", "CritRating", "Рейтинг критического удара. Затрагивает ближний бой, стрельбу и заклинания."},
	{"Рейтинг скорости", "HasteRating", "Рейтинг скорости. Затрагивает ближний бой, стрельбу и заклинания."},
	{"Mastery rating", "MasteryRating", VgerCore.Color.Salmon .. "New stat coming in Cataclysm.  " .. VgerCore.Color.Reset .. "Увеличивает уникальный бонус дерева талантов в которых у вас больше всего талантов."},
	
	{"Атакующие физ. статы"},
	{"Сила Атаки", "Ap", "Сила атаки.  Не включает силу атаки которую вы получаете от Силы и Ловкости, или с ДПС от оружия (для друидов)."},
	{"Ферал СА", "FeralAp", "Сила атаки друидов в животных формах. Если назначаете значение сюда то нужно назначать значение и на ДПС от оружия."},
	{"Дист. СА", "Rap", "Сила атаки для стрельбы."},
	{"Рейтинг мастерства", "ExpertiseRating", "Рейтинг мастерства."},
	{"Пробивание брони", "ArmorPenetration", "Рейтинг пробивания брони: помогает вашим атакам игнорировать броню оппонента.\n\n" .. VgerCore.Color.Salmon .. "Cataclysm:  " .. VgerCore.Color.Reset .. "Этот стат будет заменен другими статами."},
	
	{"Статы заклинаний"},
	{"Сила заклинаний", "SpellPower", "Сила заклинаний, Затрагивает оба показателя и урон от заклинаний и лечение."},
	{"Маны за 5", "Mp5", "Регенерация маны за 5 секунд.\n\n" .. VgerCore.Color.Salmon .. "Cataclysm:  " .. VgerCore.Color.Reset .. "Items with 1 MP5 will instead have 2 Spirit."},
	{"Пробивание сопротивления", "SpellPenetration", "Пробивание сопротивления помогает вышим заклинаниям игнорировать сопротивление оппонента."},
	
	{"Оборонительные статы"},
	{"Броня", "Armor", "Броня, не зависимо от типа вещи.  Классы с билками которые дают бонусную броню должны назначать коэфициенты для базовой брони и бонусной брони вместо данного значения."},
	{"Броня: базовая", "BaseArmor", "Базовая броня одежды.  Может быть усилена абилками типа Thick Hide и Frost Presence.\n\nТанкошмот с бонусной броней зеленого цвета будут считаться как базовая броня, т.к. моды не определяют бонусноую броню."},
	{"Броня: бонус", "BonusArmor", "Бонусная броня для оружия, колец и аксессуаров.  Не влияет на абилки которые изменюят значение брони."},
	{"Значение блока", "BlockValue", "Значение блока увеличивает количество поглощенного урона при успешном блоке щитом.\n\n" .. VgerCore.Color.Salmon .. "Cataclysm:  " .. VgerCore.Color.Reset .. "Этот стат будет заменен другими статами."},
	{"Рейтинг блока", "BlockRating", "Рейтинг блока увеличивает шанс блокирования щитом."},
	{"Рейтинг защиты", "DefenseRating", "Рейтинг защиты.\n\n" .. VgerCore.Color.Salmon .. "Cataclysm:  " .. VgerCore.Color.Reset .. "Этот стат будет заменен другими статами."},
	{"Рейтинг уклонения", "DodgeRating", "Рейтинг уклонения."},
	{"Рейтинг парирования", "ParryRating", "Рейтинг парирования."},
	{"Рейтинг устойчивости", "ResilienceRating", "Рейтинг устойчивости."},
	
	{"Редкие статы"},
	{"Fire spell power", "FireSpellDamage", "Fire-only spell power.  This stat does not appear on items that give spell power to all schools."},
	{"Shadow spell power", "ShadowSpellDamage", "Shadow-only spell power.  This stat does not appear on items that give spell power to all schools."},
	{"Nature spell power", "NatureSpellDamage", "Nature-only spell power.  This stat does not appear on items that give spell power to all schools."},
	{"Arcane spell power", "ArcaneSpellDamage", "Arcane-only spell power.  This stat does not appear on items that give spell power to all schools."},
	{"Frost spell power", "FrostSpellDamage", "Frost-only spell power.  This stat does not appear on items that give spell power to all schools."},
	{"Holy spell power", "HolySpellDamage", "Holy-only spell power.  This stat is quite rare, and does not appear on items that give spell power to all schools."},
	{"Сопротивление всему", "AllResist", "All elemental resistances."},
	{"Сопротивление огню", "FireResist", "Fire resistance.  This stat does not appear on items that give all elemental resistances."},
	{"Сопротивление тьме", "ShadowResist", "Shadow resistance.  This stat does not appear on items that give all elemental resistances."},
	{"Сопростивление природе", "NatureResist", "Nature resistance.  This stat does not appear on items that give all elemental resistances."},
	{"Сопротивление тайной магии", "ArcaneResist", "Arcane resistance.  This stat does not appear on items that give all elemental resistances."},
	{"Сопротивление льду", "FrostResist", "Frost resistance.  This stat does not appear on items that give all elemental resistances."},
	{"Жизнь за 5", "Hp5", "Регениерация жизни за 5 секунд.  Обычно для энчантов."},
	{"Health", "Health", "Raw health.  Does not include health from Stamina.  This generally appears only on enchantments."},
	{"Mana", "Mana", "Raw mana.  Does not include mana from Intellect.  This generally appears only on enchantments."},
	
	{"Типы оружия"},
	{"Одноручный топор", "IsAxe", "Очки присваиваются только если вещь - одноручный топор."},
	{"Двуручный топор", "Is2HAxe", "Очки присваиваются только если вещь - двуручный топор."},
	{"Лук", "IsBow", "Очки присваиваются только если вещь - лук или стрелы."}, -- *** Cataclysm: ammo removed
	{"Арбалет", "IsCrossbow", "Очки присваиваются только если вещь - арбалет."},
	{"Кинжал", "IsDagger", "Очки присваиваются только если вещь - кинжал."},
	{"Кистевое", "IsFist", "Очки присваиваются только если вещь - кистевое оружие."},
	{"Огнестрельное", "IsGun", "Очки присваиваются только если вещь - огнестрельное оружие или пули."}, -- *** Cataclysm: ammo removed
	{"Одноручное дробящее", "IsMace", "Очки присваиваются только если вещь - одноручное дробящее."},
	{"Двуручное дробящее", "Is2HMace", "Очки присваиваются только если вещь - двуручное дробящее."},
	{"Древковое", "IsPolearm", "Очки присваиваются только если вещь - древковое оружие."},
	{"Посох", "IsStaff", "Очки присваиваются только если вещь - посох."},
	{"Одноручный меч", "IsSword", "Очки присваиваются только если вещь - одноручный меч."},
	{"Двуручный меч", "Is2HSword", "Очки присваиваются только если вещь - двуручный меч."},
	{"Метательное", "IsThrown", "Очки присваиваются только если вещь - метательное оружие."},
	{"Жезл", "IsWand", "Очки присваиваются только если вещь - жезл."},

	{"Типы брони"},
	{"Ткань", "IsCloth", "Очки присваиваются только если вещь - тканевые доспехи."},
	{"Кожа", "IsLeather", "Очки присваиваются только если вещь - кожаные доспехи."},
	{"Кольчуга", "IsMail", "Очки присваиваются только если вещь - кольчужные доспехи."},
	{"Латы", "IsPlate", "Очки присваиваются только если вещь - латные доспехи."},
	{"Щит", "IsShield", "Очки присваиваются только если вещь - щит."},

	{"Спец статы оружия"},
	{"Мин. урон", "MinDamage", "Минимальный урон оружием."},
	{"Макс. урон", "MaxDamage", "Максимальный урон оружием."},
	{"Melee: DPS", "MeleeDps", "Weapon damage per second, only for melee weapons."},
	{"Melee: min damage", "MeleeMinDamage", "Weapon minimum damage, only for melee weapons."},
	{"Melee: max damage", "MeleeMaxDamage", "Weapon maximum damage, only for melee weapons."},
	{"Melee: speed", "MeleeSpeed", "Weapon speed, only for melee weapons."},
	{"Ranged: DPS", "RangedDps", "Weapon damage per second, only for ranged weapons."},
	{"Ranged: min damage", "RangedMinDamage", "Weapon minimum damage, only for ranged weapons."},
	{"Ranged: max damage", "RangedMaxDamage", "Weapon maximum damage, only for ranged weapons."},
	{"Ranged: speed", "RangedSpeed", "Weapon speed, only for ranged weapons."},
	{"MH: DPS", "MainHandDps", "Weapon damage per second, only for main hand weapons."},
	{"MH: min damage", "MainHandMinDamage", "Weapon minimum damage, only for main hand weapons."},
	{"MH: max damage", "MainHandMaxDamage", "Weapon maximum damage, only for main hand weapons."},
	{"MH: speed", "MainHandSpeed", "Weapon speed, only for main hand weapons."},
	{"OH: DPS", "OffHandDps", "Weapon damage per second, only for off-hand weapons."},
	{"OH: min damage", "OffHandMinDamage", "Weapon minimum damage, only for off-hand weapons."},
	{"OH: max damage", "OffHandMaxDamage", "Weapon maximum damage, only for off-hand weapons."},
	{"OH: speed", "OffHandSpeed", "Weapon speed, only for off-hand weapons."},
	{"1H: DPS", "OneHandDps", "Weapon damage per second, only for weapons marked One Hand, not including Main Hand or Off Hand weapons."},
	{"1H: min damage", "OneHandMinDamage", "Weapon minimum damage, only for weapons marked One Hand, not including Main Hand or Off Hand weapons."},
	{"1H: max damage", "OneHandMaxDamage", "Weapon maximum damage, only for weapons marked One Hand, not including Main Hand or Off Hand weapons."},
	{"1H: speed", "OneHandSpeed", "Weapon speed, only for weapons marked One Hand, not including Main Hand or Off Hand weapons."},
	{"2H: DPS", "TwoHandDps", "Weapon damage per second, only for two-handed weapons."},
	{"2H: min damage", "TwoHandMinDamage", "Weapon minimum damage, only for two-handed weapons."},
	{"2H: max damage", "TwoHandMaxDamage", "Weapon maximum damage, only for two-handed weapons."},
	{"2H: speed", "TwoHandSpeed", "Weapon speed, only for two-handed weapons."},
	{"Speed baseline", "SpeedBaseline", "Not an actual stat, per se.  This number is subtracted from the Speed stat before multiplying it by the scale value.", true, "|cffffffffSpeed baseline|r is:"},
	
	{"Статы питомца"},
	{"СА питомца", "Pap", "Сила атаки питомца."},
	{"Броня питомца", "PetArmor", "Броня питомца."},
	{"Выносливость питомца", "PetStamina", "Выносливость для питомца"},
}

------------------------------------------------------------
-- UI strings
------------------------------------------------------------

-- Translation note: All of the strings ending in _Text should be translated; those will show up in the UI.  The strings ending
-- in _Tooltip are only used in tooltips, and can be safely left out.  If you don't want to translate them right now, delete those
-- lines or set them to nil, and Pawn won't show tooltips for those UI elements.


-- Configuration UI
PawnUIFrame_CloseButton_Text = "Закрыть"
PawnUIHeaders = -- (%s is the name of the current scale)
{
	"Настройка ваших шкал для Pawn", -- Scale tab
	"Значения шкал для %s", -- Values tab
	"Сравнить используя %s", -- Compare tab
	"Камни для %s", -- Gems tab
	"Подправить настройки Pawn", -- Options tab
	"О Pawn", -- About tab
	"Добро пожаловать в Pawn!", -- Getting Started tab
}

-- Configuration UI, Scale selector
PawnUIFrame_ScaleSelector_Header_Text = "Выберите шкалу:"

-- Configuration UI, Scale tab (this is a new tab; the old Scales tab is now the Values tab)
PawnUIFrame_ScalesTab_Text = "Шкала"

PawnUIFrame_ScalesWelcomeLabel_Text = "Scales are sets of stats and values that are used to assign point values to items.  You can customize your own or use scale values that others have created."

PawnUIFrame_ShowScaleCheck_Label_Text = "Отображать в подсказках"
PawnUIFrame_ShowScaleCheck_Tooltip = "Когда отмечено, значения для данной шкалы будут отображаться в посказках персонажа. Каждую шкалу может отображаться для одного персонажа, нескольких или не отображаться вообще."
PawnUIFrame_RenameScaleButton_Text = "Переимен"
PawnUIFrame_RenameScaleButton_Tooltip = "Переименовать текущую шкалу."
PawnUIFrame_DeleteScaleButton_Text = "Удалить"
PawnUIFrame_DeleteScaleButton_Tooltip = "Удалить текущую шкалу.\n\nОтменить удаление будет невозможно."
PawnUIFrame_ScaleColorSwatch_Label_Text = "Изменить цвет"
PawnUIFrame_ScaleColorSwatch_Tooltip = "Изменение цвета отображения названия и значений шкалы в подсказках."
PawnUIFrame_ScaleTypeLabel_NormalScaleText = "Вы можете ихменить шкалу на закладке Значения."
PawnUIFrame_ScaleTypeLabel_ReadOnlyScaleText = "Вы должны сделать копия этой шкалы для ее изменения."

PawnUIFrame_ScaleSettingsShareHeader_Text = "Поделиться шкалами"

PawnUIFrame_ImportScaleButton_Text = "Импорт"
PawnUIFrame_ImportScaleButton_Label_Text = "Добавить новую шкалу, вставкой текста шкалы из интернета."
PawnUIFrame_ExportScaleButton_Text = "Экспорт"
PawnUIFrame_ExportScaleButton_Label_Text = "Поделиться шкалой в интернете."

PawnUIFrame_ScaleSettingsNewHeader_Text = "Создать новую шкалу"

PawnUIFrame_CopyScaleButton_Text = "Копия"
PawnUIFrame_CopyScaleButton_Label_Text = "Создать новую шкалу с копирование значений из текущей шкалы."
PawnUIFrame_NewScaleButton_Text = "Новая"
PawnUIFrame_NewScaleButton_Label_Text = "Создать новую пустую шкалу без значений"
PawnUIFrame_NewScaleFromDefaultsButton_Text = "Новая (д)"
PawnUIFrame_NewScaleFromDefaultsButton_Label_Text = "Создать новую шкалу с копированием значений по-умолчанию, которая имеет значения для большинства статов."

-- Configuration UI, Values tab (previously the Scales tab)
PawnUIFrame_ValuesTab_Text = "Значения"

PawnUIFrame_ValuesWelcomeLabel_NormalText = "Вы можете изменять значения которые назначены каждому стату шкалы. Для управления вашими шкалами или добавления новых, используйте закладку Шкалы."
PawnUIFrame_ValuesWelcomeLabel_NoScalesText = "У вас нет выбранных шкал. Для начала, посетите закладку Шкалы и создайте новую шкалу или вставьте из интернета."
PawnUIFrame_ValuesWelcomeLabel_ReadOnlyScaleText = "Выбранная шкала не может быть изменена. Если вы хотите изменить ее, откройте закладку Шкалы и сделайте копию.."

PawnUIFrame_IgnoreStatCheck_Text = "Вещи с этим не используемые"
PawnUIFrame_IgnoreStatCheck_Tooltip = "Enable this option to cause any item with this stat to not get a value for this scale.  For example, shamans can't wear plate, so a scale designed for a shaman can mark plate as unusable so that plate armor doesn't get a value for that scale."

PawnUIFrame_ClearValueButton_Text = "Исключить"
PawnUIFrame_ClearValueButton_Tooltip = "Исключить стат из шкалы"

PawnUIFrame_ScaleSocketOptionsHeaderLabel_Text = "Когда рассчитывается значение для текущей шкалы:"
PawnUIFrame_ScaleSocketBestRadio_Text = "Рассчитывать автоматически"
PawnUIFrame_ScaleSocketBestRadio_Tooltip = "Pawn будет рассчитывать значения сокетов с условием максимизации значения вещи."
PawnUIFrame_ScaleSocketCorrectRadio_Text = "Установить вручную"
PawnUIFrame_ScaleSocketCorrectRadio_Tooltip = "Pawn будет рассчитывать значения сокетов на основе заданных вами значениях."
--PawnUIFrame_ScaleSocketBestRadio_Text = "Использовать лучший камень для гнезда"
--PawnUIFrame_ScaleSocketBestRadio_Tooltip = "When calculating a value for this scale, Pawn will use the colors of gems that will maximize the total value of the item, even if that means putting the \"wrong\" color gem in a socket and ignoring the socket bonus."
--PawnUIFrame_ScaleSocketCorrectRadio_Text = "Использовать правильный камень для гнезда"
--PawnUIFrame_ScaleSocketCorrectRadio_Tooltip = "When calculating a value for this scale, Pawn will use the correct colors of gems for each socket, so the item will qualify for the socket bonus."

PawnUIFrame_NormalizeValuesCheck_Text = "Нормализировать значения (как Wowhead)"
PawnUIFrame_NormalizeValuesCheck_Tooltip = "Выключите эту опцию для деления значния на сумму всех значений в шкале, как это делает Wowhead и Lootzor.\n\nДля дополнительной информации, смотрите файл readme."

-- Configuration UI, Compare tab
PawnUIFrame_CompareTab_Text = "Сравнить"

PawnUIFrame_VersusHeader_Text = "—vs.—" -- Short for "versus."  Appears between the names of the two items.
PawnUIFrame_VersusHeader_NoItem = "(пусто)" -- Text displayed next to empty item slots.

PawnUIFrame_CompareMissingItemInfo_TextLeft = "Сначала выберите шкалу из списка слева."
PawnUIFrame_CompareMissingItemInfo_TextRight = "Затем, претащите вещь в эту ячейку.\n\nPawn сравнит эту вещь с одетой вещью."

PawnUIFrame_CompareSocketBonusHeader_Text = "Бонус гнезда" -- Heading that appears above the item socket bonuses.

PawnUIFrame_CompareOtherInfoHeader_Text = "Другое" -- Heading that appears above the item's level and the following stats:
PawnUIFrame_CompareAsterisk = "Спец. эффекты " .. PawnQuestionTexture
PawnUIFrame_CompareAsterisk_Yes = "Да" -- Appears on the Compare tab when an item has unrecognized stats (*).

PawnUIFrame_CurrentCompareScaleDropDown_Label_Text = "Шкала сравнения"
PawnUIFrame_CurrentCompareScaleDropDown_Tooltip = "Выберите шкалу для сравнения двух вещей."

PawnUIFrame_ClearItemsButton_Label = "Очистить"
PawnUIFrame_ClearItemsButton_Tooltip = "Убрать обе сравниваемые вещи"

PawnUIFrame_CompareSwapButton_Text = "< Swap >"
PawnUIFrame_CompareSwapButton_Tooltip = "Поменять вещи местами."

-- Configuration UI, Gems tab
PawnUIFrame_GemsTab_Text = "Камни"
PawnUIFrame_GemsHeaderLabel_Text = "Выберите шкалу для определения лучших камней."

PawnUIFrame_CurrentGemsScaleDropDown_Label_Text = "Найти лучшие камни для:"
PawnUIFrame_CurrentGemsScaleDropDown_Tooltip = "Выберите шкалу для которой будут рассчитаны значения камней."

PawnUIFrame_GemQualityDropDown_Label_Text = "Качество:"
PawnUIFrame_GemQualityDropDown_Tooltip = "Выберите качество камня для использования в Pawn."

PawnUIFrame_FindGemColorHeader_Text = "%s камни" -- Red
PawnUIFrame_FindGemColorHeader_Meta_Text = "Особые камни (без учета эффекта)"
PawnUIFrame_FindGemNoGemsHeader_Text = "Ничего не найдено."

-- Configuration UI, Options tab
PawnUIFrame_OptionsTab_Text = "Опции"
PawnUIFrame_OptionsHeaderLabel_Text = "Настройте Pawn как хотите. Изменения применятся сразу же."

PawnUIFrame_TooltipOptionsHeaderLabel_Text = "Опции подсказок"
PawnUIFrame_ShowItemLevelsCheck_Text = "Отображать уровень вещи"
PawnUIFrame_ShowItemLevelsCheck_Tooltip = "Enable this option to have Pawn display the item level of every item you come across.\n\nEvery item in World of Warcraft has a hidden level that is used to determine how many stats it can have.  In general, an item of the same type (helmet, cloak) and quality (green, blue) and a higher level will have more, or at least better, stats."
PawnUIFrame_ShowItemIDsCheck_Text = "Отображать ID вещи"
PawnUIFrame_ShowItemIDsCheck_Tooltip = "Enable this option to have Pawn display the item ID of every item you come across, as well as the IDs of all enchantments and gems.\n\nEvery item in World of Warcraft has an ID number associated with it.  This information is generally only useful to mod authors."
PawnUIFrame_ShowIconsCheck_Text = "Отображать иконку"
PawnUIFrame_ShowIconsCheck_Tooltip = "Enable this option to show inventory icons next to item link windows."
PawnUIFrame_ShowExtraSpaceCheck_Text = "Добавить пусту строку"
PawnUIFrame_ShowExtraSpaceCheck_Tooltip = "Keep your item tooltips extra tidy by enabling this option, which adds a blank line before the Pawn values."
PawnUIFrame_AlignRightCheck_Text = "Выровнять значения по правому краю"
PawnUIFrame_AlignRightCheck_Tooltip = "Enable this option to align your Pawn values (as well as item levels and item IDs) to the right edge of the tooltip instead of the left."
PawnUIFrame_AsterisksHeaderLabel_Text = "Отображать " .. PawnQuestionTexture .. " для неизвестных статов:"
PawnUIFrame_AsterisksAutoRadio_Text = "Вкл"
PawnUIFrame_AsterisksAutoRadio_Tooltip = "Не добавлять " .. PawnQuestionTexture .. " на вещи который не имеют статов, таких как Камень Возвращений.  По-умолчанию."
PawnUIFrame_AsterisksAutoNoTextRadio_Text = "Вкл, но без сообщения"
PawnUIFrame_AsterisksAutoNoTextRadio_Tooltip = "Тоже что и Вкл, но без сообщения 'Pawn не обнаружил значения для некоторых статов'."
PawnUIFrame_AsterisksOffRadio_Text = "Выкд"
PawnUIFrame_AsterisksOffRadio_Tooltip = "Никогда не отображать " .. PawnQuestionTexture .. " значек и сообщение."

PawnUIFrame_CalculationOptionsHeaderLabel_Text = "Опции вычислений"
PawnUIFrame_DigitsBox_Label_Text = "Точность:"
PawnUIFrame_DigitsBox_Tooltip = "Specify how many digits of precision you want in your Pawn values, 0-9.  0 rounds all Pawn values to whole numbers ('25').  1 is the default ('24.5')."
PawnUIFrame_UnenchantedValuesCheck_Text = "Считать значение без энчантов"
PawnUIFrame_UnenchantedValuesCheck_Tooltip = "Enable this option to have Pawn calculate values for unenchanted versions of items.  An unenchanted item has no enchantments or gems, as if it just dropped or was bought from the vendor.\n\nIf enchanted values are also enabled, the unenchanted value will be shown second, in parentheses.  If both values are the same (such as if the item is not enchanted), only one number is shown."
PawnUIFrame_EnchantedValuesCheck_Text = "Считать значение с энчантами"
PawnUIFrame_EnchantedValuesCheck_Tooltip = "Enable this option to have Pawn calculate values for items exactly as they are, including all enchantments and gems if present.\n\nIf unenchanted values are also enabled, the enchanted value will be shown first."
PawnUIFrame_DebugCheck_Text = "Отображать отладочную информацию"
PawnUIFrame_DebugCheck_Tooltip = "If you're not sure how Pawn is calculating the values for a particular item, enable this option to make Pawn spam all sorts of 'useful' data to the chat console whenever you hover over an item.  This information includes which stats Pawn thinks the item has, which parts of the item Pawn doesn't understand, and how it took each one into account for each of your scales.\n\nThis option will fill up your chat log quickly, so you'll want to turn it off once you're finished investigating.\n\nShortcuts:\n/pawn debug on\n/pawn debug off"

PawnUIFrame_OtherOptionsHeaderLabel_Text = "Другие опции"
PawnUIFrame_ButtonPositionHeaderLabel_Text = "Отображать кнопку Pawn:"
PawnUIFrame_ButtonRightRadio_Text = "Справа"
PawnUIFrame_ButtonRightRadio_Tooltip = "Show the Pawn button in the lower-right corner of the Character Info panel."
PawnUIFrame_ButtonLeftRadio_Text = "Слева"
PawnUIFrame_ButtonLeftRadio_Tooltip = "Show the Pawn button in the lower-left corner of the Character Info panel."
PawnUIFrame_ButtonOffRadio_Text = "Спрятать"
PawnUIFrame_ButtonOffRadio_Tooltip = "Don't show the Pawn button on the Character Info panel."

-- Configuration UI, About tab
PawnUIFrame_AboutTab_Text = "О аддоне"
PawnUIFrame_AboutHeaderLabel_Text = "by Vger-Azjol-Nerub"
PawnUIFrame_AboutVersionLabel_Text = "Версия %s"
PawnUIFrame_AboutTranslationLabel_Text = "Русский перевод от Warr'а" -- Translators: credit yourself here... "Klingon translation by Stovokor"
PawnUIFrame_ReadmeLabel_Text = "New to Pawn?  See the getting started tab for a really basic introduction.  You can learn about more advanced features in the readme file that comes with Pawn."
PawnUIFrame_WebsiteLabel_Text = "Для других модов от Vger, посетите vgermods.comю\n\nШкалы с wowhead использования с разрешения. If you have feedback on the scale values, please direct it to the appropriate Wowhead Theorycrafting forum threads."

-- Configuration UI, Help tab
PawnUIFrame_HelpTab_Text = "Для начала"
PawnUIFrame_GettingStartedLabel_Text =
	"Pawn подсчитывает очки для вещей так что вы можете с легкостью определить какая из вещей лучше для конкретных целей.  Очки вещей отображаются в подсказке вещи.\n\n\n" ..
	"Каждая вещь может иметь множество различных очков вещи, одно значения для каждой шкалы.  Шкала содержит список статов важных для вас, и отображает значение веса для каждого стата. Вы можете иметь несколько шкал для разных целей (танк, дд, хил).\n\n\n" ..
	"Pawn поставляется со шкалами с сайта Wowhead для каждого класса и спека: такие же веса используются в сравнении вещей.  Вы можете включить и выключить отображение шкал в подсказках, создать новую шкалу и даже поделиться ей с друзьями через интернет.\n\n\n" ..
	"Единажды изучив основы Pawn вы сможете играть без тягостных решений: - Какая вещь лучше?.  Если хотите знать больше, загляните в readme файл.  Приятной игры!\n\n\n" ..
	VgerCore.Color.Blue .. "Используйте эту информацию пока не станете гуру:\n" .. VgerCore.Color.Reset ..
	" • Для сравнения статов вещей импользуйте закладку Сравнить.\n" ..
	" • Правый-клик на линке вещи для сравнения с одетой вещью.\n" ..
	" • Shift-правый-клик на вещи с сокетами для получения советов по камням.\n" ..
	" • Сделайте копия одной из существующих шкал для изменения значений на закладке Значения.\n" ..
	" • Вы можете найти множество шкал для вашего класса в интернете.\n" ..
	" • Взгляните в readme файл для подробного описаний возможностей Pawn."

-- Inventory button
PawnUI_InventoryPawnButton_Tooltip = "Нажмите для отображения интерфейса Pawn."
PawnUI_InventoryPawnButton_Subheader = "Итого для одетых вещей:"

-- Socketing button
PawnUI_SocketingPawnButton_Tooltip = "Нажмите для отображения UI с камнями."

-- Item socketing UI
PawnUI_ItemSocketingDescription_Header = "Pawn рекомендует следующие камни:"

-- Interface Options page
PawnInterfaceOptionsFrame_OptionsHeaderLabel_Text = "Pawn options are found in the Pawn UI."
PawnInterfaceOptionsFrame_OptionsSubHeaderLabel_Text = "Click the Pawn button to go there.  You can also open Pawn from your inventory page, or by binding a key to it."

-- Bindings UI
BINDING_HEADER_PAWN = "Pawn"
BINDING_NAME_PAWN_TOGGLE_UI = "Показать Pawn UI" -- Show or hide the Pawn UI
PAWN_TOGGLE_UI_DEFAULT_KEY = "P" -- Default key to assign to this command
BINDING_NAME_PAWN_COMPARE_LEFT = "Сравнить (слева)" -- Set the currently hovered item to be the left-side Compare item
PAWN_COMPARE_LEFT_DEFAULT_KEY = "[" -- Default key to assign to this command
BINDING_NAME_PAWN_COMPARE_RIGHT = "Сравнить (справа)" -- Set the currently hovered item to be the right-side Compare item
PAWN_COMPARE_RIGHT_DEFAULT_KEY = "]" -- Default key to assign to this command


PawnLocal =
{

	-- General messages
	["NeedNewerVgerCoreMessage"] = "Pawn необходима новая версия VgerCore.  Пожалуйста, используйте версию VgerCore которая шла с Pawn.",
	
	-- Scale management dialog messages
	["NewScaleEnterName"] = "Введите имя шкалы:",
	["NewScaleNoQuotes"] = "A scale can't have \" in its name.  Enter a name for your scale:",
	["NewScaleDuplicateName"] = "A scale with that name already exists.  Enter a name for your scale:",
	
	["CopyScaleEnterName"] = "Введите имя для новой шкалы копии %s:", -- %s is the name of the existing scale
	["RenameScaleEnterName"] = "Введите новое имя шкалы %s:", -- %s is the old name of the scale
	["DeleteScaleConfirmation"] = "Вы уверены что хотите цдалить %s? Отменить удаление будет невозможно. Наберите \"%s\" для подтверждения:", -- First %s is the name of the scale, second %s is DELETE
	
	["ImportScaleMessage"] = "Press Ctrl+V to paste a scale tag that you've copied from another source here:",
	["ImportScaleTagErrorMessage"] = "Pawn doesn't understand that scale tag.  Did you copy the whole tag?  Try copying and pasting again:",
	
	["ExportScaleMessage"] = "Press Ctrl+C to copy the following scale tag for |cffffffff%s|r, and then press Ctrl+V to paste it later.", -- %s is name of scale
	["ExportAllScalesMessage"] = "Press Ctrl+C to copy your scale tags, create a file on your computer to save them in for backup, and then press Ctrl+V to paste them.",

	-- Scale selector
	["VisibleScalesHeader"] = "Шкалы %s", -- %s is name of character
	["HiddenScalesHeader"] = "Другие шкалы",
	
	-- Configuration UI, Values tab
	["Unusable"] = "(неприминимо)",
	["NoStatDescription"] = "Выберите стат из списка слева.",
	["NoScalesDescription"] = "Для начала, импортируйте шкалу или начните новую.",
	["StatNameText"] = "1 |cffffffff%s|r цениться:", -- |cffffffff%s|r is the name of the stat, in white
	
	-- Generic string dialogs
	["OKButton"] = "OK",
	["CancelButton"] = "Отмена",
	["CloseButton"] = "Закрыть",
	
	-- Debug messages
	["EnchantedStatsHeader"] = "(текущее значение)",
	["UnenchantedStatsHeader"] = "(базовое значение)",
	["FailedToGetItemLinkMessage"] = "   Ошибка получения ссылки из тултипа.  Это может быть из-за конфликтов mod-ов.",
	["FailedToGetUnenchantedItemMessage"] = "   Ошибка получения базового значения.  Это может быть из-за конфликтов mod-ов.",
	["DidntUnderstandMessage"] = "   (?) не распознано \"%s\".",
	["FoundStatMessage"] = "   %d %s", -- 25 Stamina
	
	["ValueCalculationMessage"] = "   %g %s x %g каждый = %g", -- 25 Stamina x 1 each = 25
	["UnusableStatMessage"] = "   -- %s не приминимо, пропускается.", -- IsPlate is unusable, so stopping

	["SocketBonusValueCalculationMessage"] = "   -- Socket bonus будет цениться:",
	["MissocketWorthwhileMessage"] = "   -- Но лучше использовать только %s камень:", -- Better to use only Red/Blue gems:
	["NormalizationMessage"] = "   ---- Нормализовано делением на %g", -- Normalized by dividing by 3.5
	["TotalValueMessage"] = "   ---- Итого: %g", -- Total: 25
	
	-- Tooltip annotations
	["ItemIDTooltipLine"] = "ID вещи",
	["ItemLevelTooltipLine"] = "Уровень вещи",
	["AverageItemLevelTooltipLine"] = "Эпический уровень",
	["BaseValueWord"] = "база", -- 123.45 (98.76 base)
	["AsteriskTooltipLine"] = "|TInterface\\AddOns\\Pawn-RU\\Textures\\Question:0|t Спец. эффекты не включаются в итоговое значение.",
	
	-- Gem stuff
	["GenericGemName"] = "(Камень %d)", -- (Gem 12345)
	["GenericGemLink"] = "|Hitem:%d|h[Gem %d]|h", -- [Gem 12345]
	["GemColorList1"] = "%d %s", -- 2 Red
	["GemColorList2"] = "%d %s или %s", -- 3 Red or Yellow
	["GemColorList3"] = "%d любого цвета", -- 1 of any color
	
	["GemQualityLevel80Uncommon"] = "Уровнеь 80 необычный",
	["GemQualityLevel80Rare"] = "Уровень 80 редкий",
	["GemQualityLevel80Epic"] = "Уровень 80 эпический",
	["MetaGemQualityLevel80Rare"] = "Уровень 80 созданный",
	["GemQualityLevel85Uncommon"] = "Уровень 85 необычный",
	["GemQualityLevel85Rare"] = "Уровень 85 редкий",
	["GemQualityLevel85Epic"] = "Level 85 эпический",
	["MetaGemQualityLevel85Rare"] = "Level 85 crafted",

	-- Slash commands
	["DebugOnCommand"] = "отладка вкл",
	["DebugOffCommand"] = "отладка выкл",
	["BackupCommand"] = "сделать резервную копию",
	
	["Usage"] = [[
Pawn by Vger-Azjol-Nerub
www.vgermods.com
 
/pawn -- для отображения и скрытия интерфейса Pawn
/pawn debug [ on | off ] -- писать информацию отладки в консоль
/pawn backup -- сделать резервную копию всех ваших шкал
 
For more information on customizing Pawn, please see the help file (Readme.htm) that comes with the mod.
]],

}


------------------------------------------------------------
-- Localized scale names
------------------------------------------------------------

PawnWowheadScale_Provider = "Шкалы Wowhead"
PawnWowheadScale_WarriorFury = "Воин: неистовство (мдд)"
PawnWowheadScale_WarriorArms = "Воин: оружие (мдд)"
PawnWowheadScale_WarriorTank = "Воин: защита (танк)"
PawnWowheadScale_PaladinHoly = "Паладин: свет (хил)"
PawnWowheadScale_PaladinTank = "Паладин: защита (танк)"
PawnWowheadScale_PaladinRetribution = "Паладин: воздаяние (мдд)"
PawnWowheadScale_HunterBeastMastery = "Охотник: повелитель зверей (рдд)"
PawnWowheadScale_HunterMarksman = "Охотник: стрельба (рдд)"
PawnWowheadScale_HunterSurvival = "Охотник: выживание (рдд)"
PawnWowheadScale_RogueAssassination = "Разбойник: ликвидация (мдд)"
PawnWowheadScale_RogueCombat = "Разбойник: бой (мдд)"
PawnWowheadScale_RogueSubtlety = "Разбойник: скрытность (мдд)"
PawnWowheadScale_PriestDiscipline = "Жрец: послушание (хил)"
PawnWowheadScale_PriestHoly = "Жрец: свет (хил)"
PawnWowheadScale_PriestShadow = "Жрец: тень (рдд)"
PawnWowheadScale_DeathKnightBloodDps = "Рыцарь смерти: кровь (мдд)"
PawnWowheadScale_DeathKnightBloodTank = "Рыцарь смерти: кровь (танк)"
PawnWowheadScale_DeathKnightFrostDps = "Рыцарь смерти: лед (мдд)"
PawnWowheadScale_DeathKnightFrostTank = "Рыцарь смерти: лед (танк)"
PawnWowheadScale_DeathKnightUnholyDps = "Рыцарь смерти: нечестивость (мдд)"
PawnWowheadScale_ShamanElemental = "Шаман: стихии (рдд)"
PawnWowheadScale_ShamanEnhancement = "Шаман: совершенствованиме (мдд)"
PawnWowheadScale_ShamanRestoration = "Шаман: исцеление (хил)"
PawnWowheadScale_MageArcane = "Маг: тайная магия (рдд)"
PawnWowheadScale_MageFire = "Маг: огонь (рдд)"
PawnWowheadScale_MageFrost = "Маг: лед (рдд)"
PawnWowheadScale_WarlockAffliction = "Чернокнижник: колдовство(рдд)"
PawnWowheadScale_WarlockDemonology = "Чернокнижник: демонология (рдд)"
PawnWowheadScale_WarlockDestruction = "Чернокнижник: разрушение (рдд)"
PawnWowheadScale_DruidBalance = "Друид: баланс (рдд)"
PawnWowheadScale_DruidFeralDps = "Друид: сила зверя - кошка (мдд)"
PawnWowheadScale_DruidFeralTank = "Друид: сила зверя - медведь (танк)"
PawnWowheadScale_DruidRestoration = "Друид: исцеление (хил)"

------------------------------------------------------------
-- Tooltip parsing expressions
------------------------------------------------------------

-- Turns a game constant into a regular expression.
--function PawnGameConstant(Text)
--	return "^" .. PawnGameConstantUnwrapped(Text) .. "$"
--end
--function PawnGameConstantUnwrapped(Text)
--	return string.gsub(string.gsub(Text, "%%", "%%%%"), "%-", "%%-")
--end

-- These strings indicate that a given line might contain multiple stats, such as complex enchantments
-- (ZG, AQ) and gems.  These are sorted in priority order.  If a string earlier in the table is present, any
-- string later in the table can be ignored.
PawnSeparators =
{
	", ",
	"/",
	" и ",
}

-- This string indicates that whatever stats follow it on the same line is the item's socket bonus.
PawnSocketBonusPrefix = "При соответствии цвета: "

-- Lines that match any of the following patterns will cause all further tooltip parsing to stop.
PawnKillLines =
{
	"^ \n$", -- The blank line before set items before WoW 2.3
	" %(%d+/%d+%)$", -- The (1/8) on set items for all versions of WoW
	"^|cff00e0ffDropped By", -- Mod compatibility: MobInfo-2 (should match mifontLightBlue .. MI_TXT_DROPPED_BY)
}

-- Lines that begin with any of the following strings will not be searched for separator strings.
PawnSeparatorIgnorePrefixes =
{
	'"', -- double quote

	-- Русские названия
	
	"Если на персонаже:",
	"Использование:",
	"Возможно при попадании:",
}

-- Items that begin with any of the following strings will never be parsed.
PawnIgnoreNames =
{
	-- Русские названия
	"Выкройка:",
	"Чертеж:",
	"Формула:",
	"Рецепт:",
	"Эскиз:",
	"Схема:",
}

-- This is a list of regular expression substitutions that Pawn performs to normalize stat names before running
-- them through the normal gauntlet of expressions.
PawnNormalizationRegexes =
{
	{"^([%w%s%.]+) %+(%d+)$", "+%2 %1"}, -- "Stamina +5" --> "+5 Stamina"
	{"^(.-)|r.*", "%1"}, -- For removing meta gem requirements
}

-- These regular expressions are used to parse item tooltips.
-- The first string is the regular expression to match.  Stat values should be denoted with "(%d+)".
-- Subsequent strings follow this pattern: Stat, Number, Source
-- Stat is the name of a statistic.
-- Number is either the amount of that stat to include, or the 1-based index into the matches array produced by the regex.
-- If it's an index, it can also be negative to mean that the stat should be subtracted instead of added.  If nil, defaults to 1.
-- Source is either PawnMultipleStatsFixed if Number is the amount of the stat, or PawnMultipleStatsExtract or nil if Number is the matches array index.
-- Note that certain strings don't need to be translated: for example, the game defines
-- ITEM_BIND_ON_PICKUP to be "Binds when picked up" in English, and the correct string
-- in other languages automatically.
PawnMultipleStatsFixed = "_MultipleFixed"
PawnMultipleStatsExtract = "_MultipleExtract"
PawnRegexes =
{
	-- ========================================
	-- Русские значения
	-- ========================================
	{"^Используется в комплектах:"}, -- для Outfitter
	-- Базовые статы
	{"^Броня: (%d+)$", "BaseArmor"},
	{"^%+?(%-?%d+) к силе$", "Strength"},
	{"^%+?(%-?%d+) к ловкости$", "Agility"},
	{"^%+?(%-?%d+) к выносливости$", "Stamina"},
	{"^%+?(%-?%d+) к интеллекту$", "Intellect"},
	{"^%+?(%-?%d+) к духу$", "Spirit"},
	{"^%+?(%d+) к силе заклинаний$", "SpellPower"},
	{"^%+?(%d+) к урону от заклинаний огня$", "FireSpellDamage"},
	{"^%+?(%d+) к рейтингу критического удара$", "CritRating"},
	{"^%+?(%d+) к рейтингу устойчивости$", "ResilienceRating"},
	{"^%+?(%d+) к рейтингу скорости боя$", "HasteRating"},
	{"^%+?(%d+) к рейтингу скорости$", "HasteRating"},
	{"^%+?(%d+) к рейтингу защиты$", "DefenseRating"},
	{"^%+?(%d+) к рейтингу меткости$", "HitRating"},
	{"^%+?(%d+) к мане$", "Mana"},
	{"^%+?(%d+) к рейтингу пробивания брони$", "ArmorPenetration"}, -- Fractured Scarlet Ruby
	
	{"^%+?(%d+) к силе атаки$", "Ap"},
	{"^%+?(%d+) к силе атаки в дальнем бою$", "Rap"},
	{"^%+(%d+) Показатель блока$", "BlockValue"},
	{"^%+?(%d+) Блокирование$", "BlockValue"},
	{"^Блокирование: (%d+)$", "BlockValue"},
	
	{"^Если на персонаже: Increases your mastery rating by (%d+)%.", "MasteryRating"}, -- Elementium Poleaxe (4.0) (Do not include $; mastery rating now includes the name of your mastery on the item.)
	{"^%+?(%d+) Mastery Rating$", "MasteryRating"}, -- Fractured Amberjewel (4.0).

	
	-- Урон от оружия
	{"^Урон: (%d-) %- (%d-)$", "MinDamage", 1, PawnMultipleStatsExtract, "MaxDamage", 2, PawnMultipleStatsExtract},
	{"^Урон: (%d-)$", "MinDamage", 1, PawnMultipleStatsExtract, "MaxDamage", 1, PawnMultipleStatsExtract}, -- для Визжашего лука
	{"^%+?(%d-) %- (%d-) ед%. урона от магии огня$", "MinDamage", 1, PawnMultipleStatsExtract, "MaxDamage", 2, PawnMultipleStatsExtract},
	{"^%+?(%d-) %- (%d-) ед%. урона от огня$", "MinDamage", 1, PawnMultipleStatsExtract, "MaxDamage", 2, PawnMultipleStatsExtract},
	{"^%+?(%d-) %- (%d-) ед%. урона от темной магии$", "MinDamage", 1, PawnMultipleStatsExtract, "MaxDamage", 2, PawnMultipleStatsExtract},
	{"^%+?(%d-) %- (%d-) ед%. урона от сил природы$", "MinDamage", 1, PawnMultipleStatsExtract, "MaxDamage", 2, PawnMultipleStatsExtract},
	{"^%+?(%d-) %- (%d-) ед%. урона от тайной магии$", "MinDamage", 1, PawnMultipleStatsExtract, "MaxDamage", 2, PawnMultipleStatsExtract},
	{"^%+?(%d-) %- (%d-) ед%. урона от магии льда$", "MinDamage", 1, PawnMultipleStatsExtract, "MaxDamage", 2, PawnMultipleStatsExtract},
	{"^%+?(%d-) %- (%d-) ед%. урона от светлой магии$", "MinDamage", 1, PawnMultipleStatsExtract, "MaxDamage", 2, PawnMultipleStatsExtract},
	{"^%(([%d%.,]+) ед%. урона в секунду%)$"}, -- Ignore this; DPS is calculated manually

	-- Если на персонаже
	{"^Если на персонаже: Увеличивает силу заклинаний на (%d+)%.$", "SpellPower"},
	{"^Если на персонаже: Увеличивает силу заклинаний на (%d+) ед%.$", "SpellPower"},
	{"^Если на персонаже: Увеличивает проникающую способность заклинаний на (%d+)%.$", "SpellPenetration"},
	{"^Если на персонаже: Увеличивает силу атаки на (%d+)%.$", "Ap"},
	{"^Если на персонаже: Увеличение силы атаки в дальнем бою на (%d+)%.$", "Rap"},
	{"^Если на персонаже: Увеличение показателя блока щитом на (%d+)%.$", "BlockValue"},
	{"^Если на персонаже: Увеличение показателя блока щитом на (%d+) ед%.$", "BlockValue"},
	{"^Если на персонаже: Увеличивает показатель блокирования вашего щита на (%d+) ед%.$", "BlockValue"},
	{"^Если на персонаже: Увеличивает силу атаки на (%d+) ед%. в облике кошки, медведя, лютого медведя (или|и) лунного совуха%.$"},
	{"^Если на персонаже: Сила атаки увеличена на (%d+)%.$", "Ap"},
	{"^Если на персонаже: Эффективность брони противника против ваших атак снижена на (%d+) ед%.$", "ArmorPenetration"},

	-- Рейтинги
	{"^Если на персонаже: Рейтинг критического удара %+?(%d+)%.$", "CritRating"},
	{"^Если на персонаже: Рейтинг скорости боя %+?(%d+)%.$", "HasteRating"},
	{"^Если на персонаже: Рейтинг скорости %+?(%d+)%.$", "HasteRating"},
	{"^Если на персонаже: Рейтинг меткости %+?(%d+)%.$", "HitRating"},
	{"^Если на персонаже: Рейтинг устойчивости %+?(%d+)%.$", "ResilienceRating"},
	{"^Если на персонаже: Рейтинг защиты %+?(%d+)%.$", "DefenseRating"},
	{"^Если на персонаже: Рейтинг уклонения %+?(%d+)%.$", "DodgeRating"},
	{"^Если на персонаже: Рейтинг мастерства %+?(%d+)%.$", "ExpertiseRating"},
	{"^Если на персонаже: Рейтинг парирования %+?(%d+)%.$", "ParryRating"},
	{"^Если на персонаже: Рейтинг блокирования щитом (%d+)%.$", "BlockRating"},
	{"^Если на персонаже: Увеличение рейтинга защиты на (%d+)%.$", "DefenseRating"},
	{"^Если на персонаже: Увеличение рейтинга блока на (%d+)%.$", "BlockRating"},
	{"^Если на персонаже: Увеличивает рейтинг пробивания брони на (%d+)%.$", "ArmorPenetration"}, 
	{"^Если на персонаже: Повышает рейтинг пробивания брони на (%d+)%.$", "ArmorPenetration"}, 
	{"^Если на персонаже: Увеличивает силу атаки на (%d+) ед%.$", "Ap"},

	-- Восполнение
	{"^Если на персонаже: Восполнение (%d+) ед%. маны раз в 5 секунд%.$", "Mp5"},
	{"^Если на персонаже: Восполнение (%d+) ед%. маны в 5 секунд%.$", "Mp5"},
	
	-- Энчанты
	{"^%+(%d+) ко всем характеристикам$", "Strength", 1, PawnMultipleStatsExtract, "Agility", 1, PawnMultipleStatsExtract, "Stamina", 1, PawnMultipleStatsExtract, "Intellect", 1, PawnMultipleStatsExtract, "Spirit", 1, PawnMultipleStatsExtract},
	{"^Могущество$", "Strength", 20, PawnMultipleStatsFixed},
	{"^Быстрота вепря$", "Stamina", 9, PawnMultipleStatsFixed},
	{"^Проворство кошки$", "Agility", 6, PawnMultipleStatsFixed},
	--{"^Живучесть клыкарра$", "Stamina", 15, PawnMultipleStatsFixed},
	{"^Повышение защиты %+(%d)%$", "DefenseRating", 1, PawnMultipleStatsExtract},
	{"^Огненное оружие$", "Dps", 4, PawnMultipleStatsFixed},
	{"^Верный шаг$", "HitRating", 10, PawnMultipleStatsFixed, "CritRating", 10, PawnMultipleStatsFixed},
	{"^Свирепость$", "Ap", 70, PawnMultipleStatsFixed},
	--{"^Ледопроходец$", "HitRating", 12, PawnMultipleStatsFixed, "CritRating", 12, PawnMultipleStatsFixed},
	{"^%+?(%d+)$ рейтинг меткости, %+?(%d+) рейтинг критического удара$", "HitRating", 1, PawnMultipleStatsExtract, "CritRating", 2, PawnMultipleStatsExtract}, -- он же ледопроходец
	{"^Точность$", "HitRating", 20, PawnMultipleStatsFixed},
	{"^Доспех усилен %(%+(%d+) к броне%)$", "BonusArmor"},
	{"^%+?(%d+) к урону оружием$", "MinDamage", 1, PawnMultipleStatsExtract, "MaxDamage", 1, PawnMultipleStatsExtract}, -- Weapon enchantments
	{"^%+(%d+) к броне$", "BonusArmor"},
	{"^%+(%d+) ед%. маны каждые 5 секунд$", "Mp5"},
	{"^Легкотканая вышивка$", "SpellPower", 70, PawnMultipleStatsFixed},
	{"^Титановая цепь для оружия$", "HitRating", 28, PawnMultipleStatsFixed},
	{"^Мангуст$", "Agility", 120, PawnMultipleStatsFixed},

	{"^%+?(%d+) к выносливости и %+?(%d+) к рейтингу защиты$", "Stamina", 1, PawnMultilpleStatsExtract, "DefenseRating", 2, PawnMultipleStatsExtract},
	{"^%+?(%d+) к силе заклинаний и %+?(%d+) к рейтингу критического удара$", "SpellPower", 1, PawnMultipleStatsExtract, "CritRating", 2, PawnMultipleStatsExtract},
	{"^%+?(%d+) к рейтингу уклонения и %+?(%d+) к рейтингу защиты$", "DodgeRating", 1, PawnMultipleStatsExtract, "DefenseRating", 2, PawnMultipleStatsExtract},
	{"^2%% угрозы и %+?(%d+) к рейтингу парирования$", "ParryRating"},
	{"^%+?(%d+) к выносливости$", "Stamina"},
	{"^%+?(%d+) к рейтингу защиты$", "DefenseRating"},
	{"^%+?(%d+) к выносливости и %+?(%d+) к ловкости$", "Stamina", 1, PawnMultipleStatsExtract, "Agility", 2, PawnMultipleStatsExtract},
	
	-- Текст
	{"^Классы:"},
	{"^Расы:"},
	{"^Требуется"},
	{"^Прочность:"},
	
	-- Камни
	-- Кастерские
--	{"^%+?(%d+) к силе заклинаний и снижение угрозы на 2%%$", "SpellPower", 1, PawnMultipleStatsExtract},
--	{"^%+?(%d+) к силе заклинаний и %+?(%d+) к рейтингу критического (удара|эффекта)$", "SpellPower", 1, PawnMultipleStatsExtract, "CritRating", 2, PawnMultipleStatsExtract},
--	{"^%+?(%d+) к силе заклинаний и %+?(%d+) к выносливости$", "SpellPower", 1, PawnMultipleStatsExtract, "Stamina", 2, PawnMultipleStatsExtract},
--	{"^%+?(%d+) к силе заклинаний и %+?(%d+) к интеллекту$", "SpellPower", 1, PawnMultipleStatsExtract, "Intellect", 2, PawnMultipleStatsExtract},
--	{"^%+?(%d+) к рейтингу меткости и %+?(%d+) к мане каждые 5 секунд$", "HitRating", 1, PawnMultipleStatsExtract, "Mp5", 2, PawnMultipleStatsExtract},
	-- Танковские
--	{"^%+?(%d+) к выносливости и увеличение показателя брони от носимой экипировки на 2%%$", "Stamina", 1, PawnMultipleStatesExtract},
--	{"^%+?(%d+) к рейтингу меткости и %+?(%d+) к выносливости$", "HitRating", 1, PawnMultipleStatsExtract, "Stamina", 2, PawnMultipleStatsExtract},
--	{"^%+?(%d+) к рейтингу защиты и %+?(%d+) к выносливости$", "DefenseRating", 1, PawnMultipleStatsExtract, "Stamina", 2, PawnMultipleStatsExtract},
--	{"^%+?(%d+) к рейтингу уклонения и %+?(%d+) к выносливости$", "DodgeRating", 1, PawnMultipleStatsExtract, "Stamina", 2, PawnMultipleStatsExtract},
--	{"^%+?(%d+) к рейтингу парирования и %+?(%d+) к выносливости$", "ParryRating", 1, PawnMultipleStatsExtract, "Stamina", 2, PawnMultipleStatsExtract},
--	{"^%+?(%d+) к выносливости$", "Stamina"},
		
	-- Сокеты
	{"^красное гнездо$", "RedSocket", 1, PawnMultipleStatsFixed},
	{"^желтое гнездо", "YellowSocket", 1, PawnMultipleStatsFixed},
	{"^синее гнездо$", "BlueSocket", 1, PawnMultipleStatsFixed},
	{"^бесцветное гнездо$", "ColorlessSocket", 1, PawnMultipleStatsFixed},
	{"^особое гнездо$", "MetaSocket", 1, PawnMultipleStatsFixed},
	{"^\"Only fits in a meta gem slot%.\"$", "MetaSocketEffect", 1, PawnMultipleStatsFixed}, -- Actual meta gems, not the socket

	-- Устойчивость к магии
	{"^Устойчивость: %+?(%-?%d+) Огонь$", "FireResist"},
	{"^Устойчивость: %+?(%-?%d+) Лед$", "FrostResist"},
	{"^Устойчивость: %+?(%-?%d+) Тьма$", "ShadowResist"},
	{"^Устойчивость: %+?(%-?%d+) Природа$", "NatureResist"},
	{"^Устойчивость: %+?(%-?%d+) Тайная магия$", "ArcaneResist"},
	{"^%+(%d+) к сопротивлению огню$", "FireResist"},

	-- ========================================
	-- Common strings that are ignored (rare ones are at the bottom of the file)
	-- ========================================
	{PawnGameConstant(ITEM_QUALITY0_DESC)}, -- Poor
	{PawnGameConstant(ITEM_QUALITY1_DESC)}, -- Common
	{PawnGameConstant(ITEM_QUALITY2_DESC)}, -- Uncommon
	{PawnGameConstant(ITEM_QUALITY3_DESC)}, -- Rare
	{PawnGameConstant(ITEM_QUALITY4_DESC)}, -- Epic
	{PawnGameConstant(ITEM_QUALITY5_DESC)}, -- Legendary
	{PawnGameConstant(ITEM_QUALITY7_DESC)}, -- Heirloom
	{PawnGameConstant(ITEM_HEROIC)}, -- Heroic (Thrall's Chestguard of Triumph, level 258 version)
	{PawnGameConstant(ITEM_HEROIC_EPIC)}, -- Heroic Epic (Thrall's Chestguard of Triumph, level 258 version, with colorblind mode on)
	{"^" .. ITEM_LEVEL}, -- Item Level 200
	{PawnGameConstant(ITEM_UNSELLABLE)}, -- No sell price
	{PawnGameConstant(ITEM_SOULBOUND)}, -- Soulbound
	{PawnGameConstant(ITEM_BIND_ON_EQUIP)}, -- Binds when equipped
	{PawnGameConstant(ITEM_BIND_ON_PICKUP)}, -- Binds when picked up
	{PawnGameConstant(ITEM_BIND_ON_USE)}, -- Binds when used
	{PawnGameConstant(ITEM_BIND_TO_ACCOUNT)}, -- Binds to account (Polished Spaulders of Valor)
	{"^" .. PawnGameConstantUnwrapped(ITEM_UNIQUE)}, -- Unique; leave off the $ for Unique(20)
	{"^" .. PawnGameConstantUnwrapped(ITEM_BIND_QUEST)}, -- Leave off the $ for MonkeyQuest mod compatibility
	{PawnGameConstant(ITEM_STARTS_QUEST)}, -- This Item Begins a Quest
	{PawnGameConstant(ITEM_CONJURED)}, -- Conjured Item
	{PawnGameConstant(ITEM_PROSPECTABLE)}, -- Prospectable
	{PawnGameConstant(ITEM_MILLABLE)}, -- Millable
	{PawnGameConstant(ITEM_DISENCHANT_NOT_DISENCHANTABLE)}, -- Cannot be disenchanted
	{"^Will receive"}, -- Appears in the trade window when an item is about to be enchanted ("Will receive +8 Stamina")
	{"^Disenchanting requires"}, -- Appears on item tooltips when the Disenchant ability is specified ("Disenchanting requires Enchanting (25)")
	{PawnGameConstant(ITEM_ENCHANT_DISCLAIMER)}, -- Item will not be traded!
	{"^.+ зарядов?$"}, -- Brilliant Mana Oil
	{PawnGameConstant(LOCKED)}, -- Locked
	{PawnGameConstant(ENCRYPTED)}, -- Encrypted (Floral Foundations) (does not seem to exist in the game yet)
	{PawnGameConstant(ITEM_SPELL_KNOWN)}, -- Already Known
	{PawnGameConstant(INVTYPE_HEAD)}, -- Head
	{PawnGameConstant(INVTYPE_NECK)}, -- Neck
	{PawnGameConstant(INVTYPE_SHOULDER)}, -- Shoulder
	{PawnGameConstant(INVTYPE_CLOAK), "IsCloth", 1, PawnMultipleStatsFixed}, -- Back (cloaks are cloth even though they don't list it)
	{PawnGameConstant(INVTYPE_ROBE)}, -- Chest
	{PawnGameConstant(INVTYPE_BODY)}, -- Shirt
	{PawnGameConstant(INVTYPE_TABARD)}, -- Tabard
	{PawnGameConstant(INVTYPE_WRIST)}, -- Wrist
	{PawnGameConstant(INVTYPE_HAND)}, -- Hands
	{PawnGameConstant(INVTYPE_WAIST)}, -- Waist
	{PawnGameConstant(INVTYPE_FEET)}, -- Feet
	{PawnGameConstant(INVTYPE_LEGS)}, -- Legs
	{PawnGameConstant(INVTYPE_FINGER)}, -- Finger
	{PawnGameConstant(INVTYPE_TRINKET)}, -- Trinket
	{PawnGameConstant(MAJOR_GLYPH)}, -- Major Glyph
	{PawnGameConstant(MINOR_GLYPH)}, -- Minor Glyph
	{"<.+>"}, -- Made by, Right-click to read, etc. (No ^$; can be prefixed by a color)
	{'^"'}, -- Flavor text
	{"^%d+ [Яя]чеек .+$"}, -- Bags of all kinds
	{"^.+%(%d+ сек%)$"}, -- Temporary item buff
	{"^.+%(%d+ мин%)$"}, -- Temporary item buff
	{"^Увеличивает силу атаки на (%d+) в облике кошки, медведя, лютого медведя (или|и) лунного совуха%.$"}, -- урон от оружия для друида.
	
	-- ========================================
	-- Strings that represent statistics that Pawn cares about
	-- ========================================
	{"^Оружие дальнего боя$", "IsRanged", 1, PawnMultipleStatsFixed}, -- Ranged
	{"^Дальний бой$", "IsRanged", 1, PawnMultipleStatsFixed}, -- Bow
	{"^Боеприпасы$", "IsRanged", 1, PawnMultipleStatsFixed}, -- Projectile
	{"^Метательное$", "IsRanged", 1, PawnMultipleStatsFixed}, -- Thrown
	{"^Одноручное$", "IsOneHand", 1, PawnMultipleStatsFixed}, -- One-Hand
	{"^Двуручное$", "IsTwoHand", 1, PawnMultipleStatsFixed}, -- Two-Hand
	{"^Правая рука$", "IsMainHand", 1, PawnMultipleStatsFixed}, -- Main Hand
	{"^Левая рука$", "IsOffHand", 1, PawnMultipleStatsFixed}, -- Off Hand
	{PawnGameConstant(INVTYPE_HOLDABLE)}, -- Held In Off-Hand; no Pawn stat for this

	-- ========================================
	-- Питомец
	-- ========================================
	{"^Если на персонаже: Увеличение силы атаки питомца на (%d+) ед%. усиление его брони на (%d+) ед%. и повышение выносливости на (%d+) ед%.$", "Pap", 1, PawnMultipleStatsExtract, "PetArmor", 2, PawnMultipleStatsExtract, "PetStamina",3, PawnMultipleStatsExtract},	
}

-- These regexes work exactly the same as PawnRegexes, but they're used to parse the right side of tooltips.
-- Unrecognized stats on the right side are always ignored.
-- Two-handed Axes, Maces, and Swords will have their stats converted to the 2H version later.
PawnRightHandRegexes =
{
	{"^Скорость ([%d%.,]+)$", "Speed"},
	{"^Стрелы$", "IsBow", 1, PawnMultipleStatsFixed},
	{"^Топор$", "IsAxe", 1, PawnMultipleStatsFixed},
	{"^Лук$", "IsBow", 1, PawnMultipleStatsFixed},
	{"^Пули$", "IsGun", 1, PawnMultipleStatsFixed},
	{"^Арбалет$", "IsCrossbow", 1, PawnMultipleStatsFixed},
	{"^Кинжал$", "IsDagger", 1, PawnMultipleStatsFixed},
	{"^Кистевое$", "IsFist", 1, PawnMultipleStatsFixed},
	{"^Огнестрельное$", "IsGun", 1, PawnMultipleStatsFixed},
	{"^Дробящее$", "IsMace", 1, PawnMultipleStatsFixed},
	{"^Древковое$", "IsPolearm", 1, PawnMultipleStatsFixed},
	{"^Посох$", "IsStaff", 1, PawnMultipleStatsFixed},
	{"^Меч$", "IsSword", 1, PawnMultipleStatsFixed},
	{"^Метательное$", "IsThrown", 1, PawnMultipleStatsFixed},
	{"^Жезл$", "IsWand", 1, PawnMultipleStatsFixed},
	{"^Ткань$", "IsCloth", 1, PawnMultipleStatsFixed},
	{"^Кожа$", "IsLeather", 1, PawnMultipleStatsFixed},
	{"^Кольчуга$", "IsMail", 1, PawnMultipleStatsFixed},
	{"^Латы$", "IsPlate", 1, PawnMultipleStatsFixed},
	{"^Щит$", "IsShield", 1, PawnMultipleStatsFixed},
}

end
