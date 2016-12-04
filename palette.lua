--показать цветовую гамму для шрифтов

--пример из учебника по QLUA
dofile (getScriptPath() .. "\\quik_table_wrapper.lua")

local t = {} --таблица робота

is_run = true


--creates main table
function createTable(caption)

  -- create instance of table
  t = QTable.new()
  if not t then
    message("error!", 3)
    return
  else
    --message("table with id = " ..t.t_id .. " created", 1)
  end
  
  
  t:AddColumn("RED",    QTABLE_STRING_TYPE, 3)
  t:AddColumn("GREEN",    QTABLE_STRING_TYPE, 3)
  t:AddColumn("BLUE",    QTABLE_STRING_TYPE, 3)
  
  t:AddColumn("test_row",    QTABLE_STRING_TYPE, 100)
  
  t:SetCaption(caption)
  
end


-- обработчики событий ----

function OnInit(s)

	createTable('PALETTE')
	t:Show()
	
end

function DestroyTables()
	is_run = false
	DestroyTable(t.t_id)
end

function OnStop(s)
	DestroyTables()
	is_run = false
	return 1000
end



-- +----------------------------------------------------+
--                  MAIN
-- +----------------------------------------------------+

-- функция обратного вызова для обработки событий в таблице. вызывается из main()
--(или, другими словами, обработчик клика по таблице робота)
--параметры:
--  t_id - хэндл таблицы, полученный функцией AllocTable()
--  msg - тип события, происшедшего в таблице
--  par1 и par2 – значения параметров определяются типом сообщения msg, 
--
--функция должна располагаться перед main(), иначе - скрипт не останавливается при закрытии окна
local f_cb = function( t_id,  msg,  par1, par2)
  
if (msg==QTABLE_CLOSE)  then
    DestroyTables()
    is_run = false
end
if msg==QTABLE_VKEY then
	--message(par2)
	if par2 == 27 then
		DestroyTables()
		is_run=false
	end
end  

end 


-- основная функция робота. здесь обновляется котировка и рассчитывается прибыль
function main()

  --установим обработчик событий таблицы робота
  SetTableNotificationCallback (t.t_id, f_cb)
  
  
	local row = nil
	local row_text = 'СЪЕШЬ ЕЩЁ ЭТИХ МЯГКИХ ФРАНЦУЗСКИХ БУЛОК ДА ВЫПЕЙ ЧАЮ.!№;%:?*()_-=/'
	local f_color     = RGB(230, 100, 100)
	local b_color = RGB(27, 27, 27)         --background color for dark theme
	
	for i = 0, 255, 5 do
		for j = 0, 255, 5 do
			for k = 0, 255, 5 do
			
				row = t:AddLine()
				
				t:SetValue(row, "test_row",  row_text)
				
				t:SetValue(row, "RED",  tostring(i))
				t:SetValue(row, "GREEN",  tostring(j))
				t:SetValue(row, "BLUE",  tostring(k))
				
				f_color     = RGB(i,j,k)
				
				SetColor(t.t_id, row, QTABLE_NO_INDEX, b_color, f_color, b_color, f_color)
			end
		end
	end
	
  while is_run do  
	
    sleep(100)
  end
  
end
