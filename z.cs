using DevExpress.Xpf.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace QLThuoc
{
  public static class z
  {

    public static bool DeleteQuestion(string _Message = "Bạn có muốn xóa dữ liệu đang được chọn?", string _Caption = "Xác nhận xóa")
    {
      if (DXMessageBox.Show(_Message, _Caption, MessageBoxButton.YesNo, MessageBoxImage.Question) == MessageBoxResult.Yes) return true;
      else return false;
    }
    public static string ConnectionString = @"Data Source=LAPTOP-5C698NK2\SQLEXPRESS;Initial Catalog=QLNhaThuoc;Integrated Security=True";
        //public static string ConnectionString = @"Data Source=MACKENO\SQLEXPRESS;Initial Catalog=QLNhaThuoc;Integrated Security=True";

        
  }
}
