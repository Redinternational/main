﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)

	Отказ = Ложь;
	Индекс = 0;
	Для Каждого ТекСтр Из Настройка Цикл
		Индекс = Индекс +1;
		Если ТекСтр.СтатьяЗатрат.Пустая() Тогда
			Сообщить("Не указана статья затрат. Строка: " + Индекс);	
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	РегистрСоответствий.Период,
		               |	РегистрСоответствий.Тип,
		               |	РегистрСоответствий.Представление
		               |ИЗ
		               |	РегистрСведений.РегистрСоответствий КАК РегистрСоответствий
		               |ГДЕ
		               |	ПОДСТРОКА(РегистрСоответствий.Тип, 1, 32) = ""КОГНОС_СЗДляВыгрузкиНоменклатуры""";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Запись = РегистрыСведений.РегистрСоответствий.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначениЯСвойств(Запись,Выборка);
			Запись.Прочитать();
			Запись.Удалить();
		КонецЦикла;
		
		Для Каждого ТекСтр Из Настройка Цикл
			Запись = РегистрыСведений.РегистрСоответствий.СоздатьМенеджерЗаписи();
			Запись.Период 			= Дата(1,3,1,0,0,1);
			Запись.Тип 				= "КОГНОС_СЗДляВыгрузкиНоменклатуры";
			Запись.Представление 	= ТекСтр.СтатьяЗатрат;
			Запись.Записать(Истина);
		КонецЦикла;
	Исключение
		ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки());
		ОтменитьТранзакцию();
		Возврат;
	КонецПопытки;
	
	ЗафиксироватьТранзакцию();

КонецПроцедуры

Процедура ПриОткрытии()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РегистрСоответствий.Представление КАК СтатьяЗатрат
	               |ИЗ
	               |	РегистрСведений.РегистрСоответствий КАК РегистрСоответствий
	               |ГДЕ
	               |	ПОДСТРОКА(РегистрСоответствий.Тип, 1, 32) = ""КОГНОС_СЗДляВыгрузкиНоменклатуры""";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НовСтр = Настройка.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, Выборка);
	КонецЦикла;
	
КонецПроцедуры
