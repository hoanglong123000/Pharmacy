using System;
using System.Linq;
using System.Windows;
using System.Windows.Controls;

namespace QLThuoc
{
  /// <summary>
  /// Interaction logic for MainWindow.xaml
  /// </summary>
  public partial class MainWindow : Window
  {
    
    public MainWindow()
    {
      InitializeComponent();
    }

    bool CheckOpenUC(string _Name)
    {
      bool result = false;
      UserControl UC = Service.Current as UserControl;
      if (UC.Name == string.Format("View{0}", _Name))
      {
        result = true;
      }
      return result;
    }
    void OpenViews(string _Name)
    {
      if (!CheckOpenUC(_Name))
      {
        Service.Navigate(_Name);
      }
    }

    private void btnDoiTac_Click(object sender, EventArgs e)
    {
      OpenViews("DoiTac");
    }

    private void frame_Navigated(object sender, DevExpress.Xpf.WindowsUI.Navigation.NavigationEventArgs e)
    {
      if (e.Source.ToString() == "Home")
      {
        btnMenu.IsSelected = true;
      }
      else if (e.Source.ToString() == "Thuoc")
      {
        btnThuoc.IsSelected = true;
      }
      else if (e.Source.ToString() == "MuaHang")
      {
        btnMuaThuoc.IsSelected = true;
      }
      else if (e.Source.ToString() == "BanHang")
      {
        btnBanThuoc.IsSelected = true;
      }
      else if (e.Source.ToString() == "DoiTac")
      {
        btnDoiTac.IsSelected = true;
      }
    }

    private void btnThuoc_Click(object sender, EventArgs e)
    {
      OpenViews("DMThuoc");
    }


    private void btnMuaThuoc_Click(object sender, EventArgs e)
    {
      OpenViews("MuaHang");
    }

    private void btnBanThuoc_Click(object sender, EventArgs e)
    {
      OpenViews("BanHang");
    }

    private void btnDoanhThu_Click(object sender, EventArgs e)
    {
      OpenViews("DoanhThu");
    }

    private void btnTonKho_Click(object sender, EventArgs e)
    {
      OpenViews("TonKho");
    }
  }
}
