# # coding=utf-8
#
# command_c = """var form = new InputForm();
# using (var c = new GridCursor(SqlClient.Main.CreateCommand("select * from tapei")))
# {
#    var grid = form.Controls.AddGrid(c);
#    grid.Width = 40;
#    grid.Height = 10;
#    var col = grid.InnerControl.Columns.AddTextBox("pnedi", "pnedi");
#    col.ReadOnly = false;
#    form.Activate();
# }
# """
#
#
# command_c_grid = """var form = new InputForm();
# using (var c = new GridCursor(SqlClient.Main.CreateCommand("select 1234.56 as undoc union all select 7891.23")))
# {
#                 var grid = form.Controls.AddGrid(c);
#                 grid.Width = 40;
#                 grid.Height = 10;
#                 var col = grid.InnerControl.Columns.AddTextBox("undoc", "undoc");
#                 col.ReadOnly = false;
#                 col.InputMask = "999,999.99";
#                 col.Valid += arg => {
#                                InfoManager.MessageBox("1");
#                                return true;
#                 };
#                 form.Activate();
# }
# """
#
#
# command_vfp = """do Line1 with 'aaaa',100,10,.t.
# yesno("?")"""
#
#
# activating_a_screen = """InputForm.Activate("_UI1");"""
#
# data_editor_call = """DataEditor.Call("_UI1_2");"""
#
#
# activating_validation_form = """InputForm.Activate("_UI1_1");"""
#
#
# decimalPlaces_in_the_adjustment_screens = """var v = new InputForm();
# var a = v.Controls.AddTextBox(1.0m);
# a.DecimalPlaces = 5;
# v.Controls.AddTextBox(1.0m);
# v.Activate();"""
#
#
# adjusting_the_grid_with_the_mask_in_the_adjustment_screen = """var form = new InputForm();
# using (var c = new GridCursor(SqlClient.Main.CreateCommand("select top 2 undoc from dmz order by undoc desc")))
# {
#                 var grid = form.Controls.AddGrid(c);
#                 grid.Width = 40;
#                 grid.Height = 10;
#                 var col = grid.InnerControl.Columns.AddTextBox("undoc", "undoc");
#                 col.ReadOnly = false;
#                 col.InputMask = "999,999.99";
#                 col.Valid += arg => {
#                               InfoManager.MessageBox(Text.Convert(arg.GetNewValue<int>()));
#                                return true;
#                 };
#                 form.Activate();
# }"""
#
#
# text = u"\"Несуществующая таблица\""
# dropdown_unexisting_table = """var form = new InputForm();
# form.Controls.AddLabel(""" + text + """);
# var kod = form.Controls.AddMultiCodeNameBox<int>();
# kod.Table = "TTTT";
# kod.CodeField = "FL";
# kod.CaptionFields = new [] {"FLN"};
# kod.Height = 10;
# kod.Width = 50;
# form.Activate();"""
#
#
# cyrillic_mess = u"\"Выбранные значения - {0}\""
# ade_pulling_from_dropdown_menu_numerical_first = """var form = new InputForm();
# var kod = form.Controls.AddMultiCodeNameBoxSp12<int>("_TSTSN", "VALUE1", "0,4");
# kod.Height = 10;
# if (form.Activate())
# {
#             InfoManager.MessageBox("""+ cyrillic_mess +""", kod.Value);
# }"""
#
#
# ade_pulling_from_dropdown_menu_numerical_second = """var form = new InputForm();
# var kod = form.Controls.AddMultiCodeNameBoxSp12<int>("_TSTSN", "VALUE1", null);
# kod.Height = 10;
# kod.CodesDelimiter = ";";
# kod.Value = "1;2";
# if (form.Activate())
# {
#             InfoManager.MessageBox("""+ cyrillic_mess +""", kod.Value);
# }"""
#
#
# edi_polling = """var form = new InputForm();
# var edi = form.Controls.AddMultiCodeNameBoxes("TAPEI")["EDI"];
# edi.Height = 10;
# form.Activate();"""
#
#
# checkbox_text = u"\"Функция доступна для вызова\""
# vfp_checkbox = """private m.check
# m.check = .t.
# =menuget([;|m.check|L|1|@*C3 ]+_trn(""" + checkbox_text + """)+[||valid()|||/SIZESAY:0])
# procedure valid
# return"""
#
#
# message_text = u"\"Выбранные значения"
# dropdown_letters = """var form = new InputForm();
# var kod = form.Controls.AddMultiCodeNameBoxSp12<string>("_TSTSC", "VALUE1", null);
# kod.Height = 10;
# if (form.Activate())
# {
#             InfoManager.MessageBox(""" + message_text + """ - {0}", kod.Value);
# }"""