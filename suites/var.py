command_c = """var form = new InputForm();
using (var c = new GridCursor(SqlClient.Main.CreateCommand("select * from tapei")))
{
   var grid = form.Controls.AddGrid(c);
   grid.Width = 40;
   grid.Height = 10;
   var col = grid.InnerControl.Columns.AddTextBox("pnedi", "pnedi");
   col.ReadOnly = false;
   form.Activate();
}
"""


command_c_grid = """var form = new InputForm();
using (var c = new GridCursor(SqlClient.Main.CreateCommand("select 1234.56 as undoc union all select 7891.23")))
{
                var grid = form.Controls.AddGrid(c);
                grid.Width = 40;
                grid.Height = 10;
                var col = grid.InnerControl.Columns.AddTextBox("undoc", "undoc");
                col.ReadOnly = false;
                col.InputMask = "999,999.99";
                col.Valid += arg => {
                               InfoManager.MessageBox("1");
                               return true;
                };
                form.Activate();
}
"""


command_vfp = """do Line1 with 'aaaa',100,10,.t.
yesno("?")"""


activating_a_screen = """InputForm.Activate("_UI1");"""

data_editor_call = """DataEditor.Call("_UI1_2");"""


decimalPlaces_in_the_adjustment_screens = """var v = new InputForm();
var a = v.Controls.AddTextBox(1.0m);
a.DecimalPlaces = 5;
v.Controls.AddTextBox(1.0m);
v.Activate();"""


adjusting_the_grid_with_the_mask_in_the_adjustment_screen = """var form = new InputForm();
using (var c = new GridCursor(SqlClient.Main.CreateCommand("select top 2 undoc from dmz order by undoc desc")))
{
                var grid = form.Controls.AddGrid(c);
                grid.Width = 40;
                grid.Height = 10;
                var col = grid.InnerControl.Columns.AddTextBox("undoc", "undoc");
                col.ReadOnly = false;
                col.InputMask = "999,999.99";
                col.Valid += arg => {
                              InfoManager.MessageBox(Text.Convert(arg.GetNewValue<int>()));
                               return true;
                };
                form.Activate();
}"""
