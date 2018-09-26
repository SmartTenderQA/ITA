
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