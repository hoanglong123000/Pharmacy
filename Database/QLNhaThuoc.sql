USE [QLNhaThuoc]
GO
/****** Object:  Table [dbo].[HoaDon]    Script Date: 27/10/2020 11:06:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HoaDon](
	[MaHoaDon] [int] IDENTITY(1,1) NOT NULL,
	[NgayHoaDon] [date] NOT NULL,
	[MaDoiTac] [int] NOT NULL,
	[HoaDonMua] [bit] NOT NULL,
	[GhiChu] [nvarchar](250) NULL,
 CONSTRAINT [PK_HoaDon] PRIMARY KEY CLUSTERED 
(
	[MaHoaDon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DoiTac]    Script Date: 27/10/2020 11:06:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DoiTac](
	[MaDoiTac] [int] IDENTITY(1,1) NOT NULL,
	[TenDoiTac] [nvarchar](150) NOT NULL,
	[DiaChi] [nvarchar](150) NULL,
	[DienThoai] [nvarchar](50) NULL,
	[LaNhaCungCap] [bit] NOT NULL,
 CONSTRAINT [PK_DoiTac] PRIMARY KEY CLUSTERED 
(
	[MaDoiTac] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChiTietHoaDon]    Script Date: 27/10/2020 11:06:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietHoaDon](
	[MaHoaDon] [int] NOT NULL,
	[MaThuoc] [int] NOT NULL,
	[SoLuong] [int] NOT NULL,
	[DonGia] [int] NOT NULL,
 CONSTRAINT [PK_ChiTietHoaDon_1] PRIMARY KEY CLUSTERED 
(
	[MaHoaDon] ASC,
	[MaThuoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_ThongTinHoaDon]    Script Date: 27/10/2020 11:06:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[v_ThongTinHoaDon]
as
Select A.MaHoaDon, NgayHoaDon, A.MaDoiTac, TenDoiTac, DiaChi, DienThoai, GhiChu, ThanhTien, HoaDonMua  from HoaDon A inner join DoiTac B on A.MaDoiTac = B.MaDoiTac
left join

(Select MaHoaDon, ThanhTien=sum(SoLuong* DonGia) from ChiTietHoaDon group by MaHoaDon) C on A.MaHoaDon = C.MaHoaDon

GO
/****** Object:  View [dbo].[v_BaoCaoDanhThu]    Script Date: 27/10/2020 11:06:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[v_BaoCaoDanhThu]
as
Select NgayHoaDon, TenDoiTac, ThanhTien ThanhTienMuaHang, 0 ThanhTienBanHang from v_ThongTinHoaDon  where HoaDonMua=1
union all
Select NgayHoaDon, TenDoiTac, 0 ThanhTienMuaHang, ThanhTien ThanhTienBanHang from v_ThongTinHoaDon  where HoaDonMua=0 
union all
select GetDate() NgayHoaDon, N'Tổng cộng: ' TenDoiTac,  Sum(ThanhTienMuaHang) ThanhTienMuaHang, sum(ThanhTienBanHang)  ThanhTienBanHang
from (
Select (ThanhTien) ThanhTienMuaHang, 0 ThanhTienBanHang from v_ThongTinHoaDon  where HoaDonMua=1
union all
Select (0) ThanhTienMuaHang, ThanhTien ThanhTienBanHang from v_ThongTinHoaDon  where HoaDonMua=0) A
GO
/****** Object:  Table [dbo].[Thuoc]    Script Date: 27/10/2020 11:06:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Thuoc](
	[MaThuoc] [int] IDENTITY(1,1) NOT NULL,
	[TenThuoc] [nvarchar](50) NOT NULL,
	[DonViTinh] [nvarchar](10) NULL,
	[DonGiaMua] [int] NULL,
	[DonGiaBan] [int] NULL,
 CONSTRAINT [PK_Thuoc] PRIMARY KEY CLUSTERED 
(
	[MaThuoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_ThongTinChiTietHoaDon]    Script Date: 27/10/2020 11:06:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[v_ThongTinChiTietHoaDon]
as
Select A.MaHoaDon, A.MaThuoc, TenThuoc, DonViTinh, SoLuong, DonGia, SoLuong* DonGia ThanhTien from ChiTietHoaDon A inner join Thuoc B on A.MaThuoc = B.MaThuoc
GO
/****** Object:  View [dbo].[v_ThongTinThuocTonKho]    Script Date: 27/10/2020 11:06:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[v_ThongTinThuocTonKho]
as
Select MaThuoc, TenThuoc, sum(SoLuongMua) SoLuongMua, sum(SoLuongBan) SoLuongBan, sum(SoLuongMua-SoLuongBan) TonKho from 
(Select MaThuoc, TenThuoc, SoLuong SoLuongMua, 0 SoLuongBan  from (Select MaHoaDon from v_ThongTinHoaDon where HoaDonMua =1) A
inner join v_ThongTinChiTietHoaDon B on A.MaHoaDon = B.MaHoaDon 
union all
Select MaThuoc, TenThuoc, 0 SoLuongMua, SoLuong SoLuongBan  from (Select MaHoaDon from v_ThongTinHoaDon where HoaDonMua =0) A
inner join v_ThongTinChiTietHoaDon B on A.MaHoaDon = B.MaHoaDon ) A group by MaThuoc, TenThuoc having sum(SoLuongMua-SoLuongBan)<>0
GO
/****** Object:  View [dbo].[v_ThongTinThuocCon]    Script Date: 27/10/2020 11:06:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[v_ThongTinThuocCon]
as
Select A.*, SoLuong from Thuoc A inner join 
(Select MaThuoc, sum(SoLuong) SoLuong from
(Select MaThuoc,  SoLuong from ChiTietHoaDon where MaHoaDon in (Select MaHoaDon from HoaDon where HoaDonMua =1)
union all
Select MaThuoc, -1 * SoLuong from ChiTietHoaDon where MaHoaDon in (Select MaHoaDon from HoaDon where HoaDonMua =0)) A group by MaThuoc having sum(SoLuong)<>0) B on A.MaThuoc = b.MaThuoc

GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 102, 7, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 103, 6, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 104, 7, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 105, 9, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 106, 7, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 107, 7, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 108, 9, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 109, 4, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 110, 10, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 111, 4, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 112, 2, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 113, 7, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 114, 5, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 115, 8, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 116, 4, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 117, 5, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 118, 6, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (12, 119, 10, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 111, 4, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 112, 2, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 113, 7, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 114, 5, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 115, 8, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 116, 4, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 117, 5, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 118, 6, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 119, 10, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 120, 1, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 121, 7, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 122, 6, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 123, 5, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 124, 5, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 125, 5, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 126, 6, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 127, 5, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 128, 9, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 129, 6, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 130, 6, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (13, 131, 2, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 127, 2, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 128, 4, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 129, 9, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 130, 9, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 131, 7, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 132, 9, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 133, 4, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 134, 9, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 135, 4, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 136, 9, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 137, 10, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 138, 7, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 139, 8, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 140, 5, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 141, 3, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 142, 10, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 143, 3, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 144, 10, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (14, 145, 4, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (16, 103, 6, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (16, 109, 4, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 102, 1, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 103, 3, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 104, 6, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 105, 7, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 106, 3, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 107, 5, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 108, 9, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 109, 3, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 110, 3, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 111, 7, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 112, 2, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 113, 8, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 114, 1, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 115, 10, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 116, 6, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 117, 3, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 118, 1, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 119, 4, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 120, 7, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 121, 9, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 122, 7, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 123, 4, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 124, 9, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 125, 8, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 126, 8, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 127, 5, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 128, 7, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 129, 7, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 130, 10, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 131, 7, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 132, 9, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 133, 10, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 134, 5, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 135, 7, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 136, 1, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 137, 5, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 138, 7, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 139, 6, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 140, 2, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 141, 7, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 142, 1, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 143, 3, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 144, 9, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 145, 5, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 146, 4, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 147, 1, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 148, 9, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 149, 4, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 150, 6, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 151, 4, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 152, 1, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 153, 7, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 154, 2, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 155, 7, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 156, 7, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 157, 6, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 158, 3, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 159, 1, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 160, 7, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 161, 10, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 162, 1, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 163, 3, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 164, 2, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 165, 1, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 166, 10, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 167, 3, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 168, 2, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 169, 2, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 170, 7, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 171, 1, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 172, 9, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 173, 10, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 174, 3, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 175, 6, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 176, 6, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 177, 6, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 178, 7, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 179, 3, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 180, 4, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 181, 4, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 182, 7, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 183, 3, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 184, 2, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 185, 5, 50000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 186, 9, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 187, 8, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 188, 8, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 189, 4, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 190, 4, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 191, 10, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 192, 10, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 193, 2, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 194, 5, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 195, 4, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 196, 1, 60000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 197, 7, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 198, 8, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 199, 3, 40000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 200, 10, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 201, 3, 20000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (17, 202, 10, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (18, 103, 3, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (18, 106, 5, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (18, 107, 2, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (18, 108, 10, 30000)
GO
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [DonGia]) VALUES (18, 109, 1, 30000)
GO
SET IDENTITY_INSERT [dbo].[DoiTac] ON 
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (362, N'Hoàng Duy An', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (363, N'Phạm Ngọc Bảo An', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (364, N'Nguyễn Ngọc Minh An', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (365, N'Đặng Phương Anh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (366, N'Trần Phương Anh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (367, N'Trần Ngô Hà Anh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (368, N'Nguyễn Hà Anh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (369, N'Nguyễn Hà Minh Anh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (370, N'Nguyễn Ngọc Anh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (371, N'Nguyễn Dương Duy', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (372, N'Nguyễn Quang Đức', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (373, N'Dương Châu Giang', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (374, N'Nguyễn Đức Giang', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (375, N'Cấn Hải Hiệp', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (376, N'Phạm Vũ Hiệp', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (377, N'Phạm Đức Hiếu', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (378, N'Hoàng Anh Huy', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (379, N'Đỗ Minh Khang A', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (380, N'Đỗ Minh Khang B', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (381, N'Vương Mai Khanh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (382, N'Lê Quang Khánh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (383, N'Lê Nguyễn Đăng Khoa', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (384, N'Lê Tuệ Lam', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (385, N'Hoàng Tùng Lâm', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (386, N'Đàm Gia Linh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (387, N'Trần Lê Phương Linh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (388, N'Vũ Khánh Nam', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (389, N'Đàm Bảo Ngọc', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (390, N'Nguyễn Bảo Ngọc', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (391, N'Vũ Tùng Quân', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (392, N'Đặng Ngọc Sơn', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (393, N'Hoàng Thu Thủy', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (394, N'Phạm Bảo Trâm', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (395, N'Trần Minh Tuấn', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (396, N'Đinh Gia Vũ', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (397, N'Lê Khánh Vy', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (398, N'Nguyễn Hà Vi', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (399, N'Nguyễn Hải Yến', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (400, N'Hoàng Đức Anh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (401, N'Đỗ Hoàng Anh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (402, N'Phạm Hải Ngọc Anh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (403, N'Phạm Thị Phương Anh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (404, N'Nguyễn Trang Anh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (405, N'Nguyễn Ngọc Trâm Anh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (406, N'Vũ Đinh Minh Châu', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (407, N'Bùi Trí Dũng', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (408, N'Hoàng Minh Đạt', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (409, N'Vũ Ngân Hà', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (410, N'Vũ Ngọc Hà', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (411, N'Nguyễn Ngọc Bảo Hân', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (412, N'Nguyễn Tuấn Hùng', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (413, N'Nguyễn Chấn Hưng', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (414, N'Nguyễn Minh Khang', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (415, N'Nguyễn Đăng Khoa', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (416, N'Trần Đăng Khôi', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (417, N'Trịnh Tuấn Khôi', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (418, N'Nguyễn Chí Kiên', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (419, N'Trịnh Tùng Lâm', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (420, N'Phạm Hà Linh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (421, N'Nguyễn Ngọc Linh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (422, N'Trần Quang Minh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (423, N'Phạm Hải Nam', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (424, N'Trần Bảo Ngọc', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (425, N'Lương Uyên Nhi', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (426, N'Đỗ Nam Phong', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (427, N'Nguyễn Đình Phú', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (428, N'Lê Xuân Phúc', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (429, N'Nguyễn Trần Hà Phương', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (430, N'Nguyễn Đình Quý', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (431, N'Trần Minh Sơn', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (432, N'Trần Anh Thư', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (433, N'Nguyễn Khánh Toàn', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (434, N'Đặng Thành Trang', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (435, N'Lai Đình Uy', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (436, N'Vũ Tường Vi', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (437, N'Trịnh Vy Vy', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (438, N'Đặng Thảo An', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (439, N'Phạm Đoàn Hồng Anh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (440, N'Nguyễn Yến Anh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (441, N'Đặng Huyền Thu Anh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (442, N'Bùi Thị Hoài Anh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (443, N'Bùi Vũ Minh Anh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (444, N'Trần Nguyễn Phương Anh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (445, N'Nguyễn Hoàng Hồng Anh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (446, N'Vũ Nguyễn Kỳ Anh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (447, N'Trần Đỗ Diệp Anh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (448, N'Hoàng Khánh Chi', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (449, N'Nguyễn Thùy Chi', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (450, N'Vũ Mạnh Cường', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (451, N'Trần Minh Đức', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (452, N'Phạm Bảo Hân', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (453, N'Nguyễn Huy Hoàng', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (454, N'Nguyễn Ngọc Minh Huy', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (455, N'Vũ Thu Huyền', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (456, N'Nguyễn Quang Hưng', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (457, N'Võ Thành Hưng', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (458, N'Phan Đăng Khoa', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (459, N'Vũ Hoàng Lâm', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (460, N'Nguyễn Bảo Linh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (461, N'Bùi Hà Linh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (462, N'Ngô Hoàng Minh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (463, N'Vũ Minh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (464, N'Nguyễn Phương Ngân', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (465, N'Đinh Trọng Nghĩa', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (466, N'Lương Gia Bảo Ngọc', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (467, N'Vũ  Khôi Nguyên', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (468, N'Nguyễn Ngọc Thanh Thủy', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (469, N'Trần Thị Thanh Thủy', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (470, N'Vũ Trần Minh Tiến', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (471, N'Đinh Đức Tùng', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (472, N'Nguyễn Hải Mỹ Uyên', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (473, N'Đào Phương Anh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (474, N'Trần Minh Anh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (475, N'Trịnh Thị Mỹ Anh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (476, N'Vũ Thị Ngọc Anh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (477, N'Vũ Hải Anh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (478, N'Nguyễn Lê Ngọc Bích', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (479, N'Phan Thị Bích Diệp', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (480, N'Phạm Nguyễn Hồng Diệp', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (481, N'Đào Tuệ Dương', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (482, N'Hà Trần Hương Giang', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (483, N'Đào Ngân Hà', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (484, N'Nguyễn Bảo Hân', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (485, N'Vũ Hoàng Trung Hiếu', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (486, N'Ng Khổng Quang Hưng', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (487, N'Phạm Văn Đăng Khôi', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (488, N'Hoàng Vân Thụy Khanh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (489, N'Vương Minh Khuê', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (490, N'Phạm Hoàng Linh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (491, N'Lê Nguyễn Thảo Linh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (492, N'Phạm Nguyễn Bình Minh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (493, N'Phạm Quang Minh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (494, N'Trần Bình Minh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (495, N'Đào Công Minh', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (496, N'Nguyễn Linh Ngân', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (497, N'Vũ Hoàng Thành Nhân', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (498, N'Phạm Nguyễn Như Nhi', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (499, N'Nguyễn Hoàng Hiếu Phan', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (500, N'Tô Hồng Phúc', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (501, N'Phạm Hoàng Phúc', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (502, N'Nguyễn Phương Khánh Ngọc', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (503, N'Nguyễn Mai Phương', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (504, N'Đỗ Hoàng Phương', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (505, N'Vũ Trọng Tín', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (506, N'Phạm Đức Thịnh', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (507, N'Phạm Thị Minh Thư', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (508, N'Lê Tuấn Tú', N'Hải Phòng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (509, N'Phạm Anh Tuấn', N'Hải Phòng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (510, N'Trịnh Thanh Tùng', N'Hải Phòng', NULL, 0)
GO
SET IDENTITY_INSERT [dbo].[DoiTac] OFF
GO
SET IDENTITY_INSERT [dbo].[HoaDon] ON 
GO
INSERT [dbo].[HoaDon] ([MaHoaDon], [NgayHoaDon], [MaDoiTac], [HoaDonMua], [GhiChu]) VALUES (12, CAST(N'2020-10-26' AS Date), 362, 1, N'')
GO
INSERT [dbo].[HoaDon] ([MaHoaDon], [NgayHoaDon], [MaDoiTac], [HoaDonMua], [GhiChu]) VALUES (13, CAST(N'2020-10-26' AS Date), 367, 1, N'')
GO
INSERT [dbo].[HoaDon] ([MaHoaDon], [NgayHoaDon], [MaDoiTac], [HoaDonMua], [GhiChu]) VALUES (14, CAST(N'2020-10-26' AS Date), 376, 1, N'11111')
GO
INSERT [dbo].[HoaDon] ([MaHoaDon], [NgayHoaDon], [MaDoiTac], [HoaDonMua], [GhiChu]) VALUES (16, CAST(N'2020-10-27' AS Date), 371, 0, N'')
GO
INSERT [dbo].[HoaDon] ([MaHoaDon], [NgayHoaDon], [MaDoiTac], [HoaDonMua], [GhiChu]) VALUES (17, CAST(N'2020-10-27' AS Date), 494, 1, N'Mua nhiều thì nhập tay cho đến bao giờ????')
GO
INSERT [dbo].[HoaDon] ([MaHoaDon], [NgayHoaDon], [MaDoiTac], [HoaDonMua], [GhiChu]) VALUES (18, CAST(N'2020-10-27' AS Date), 470, 0, N'bán nhớ check kho xem có hay ko nhé')
GO
SET IDENTITY_INSERT [dbo].[HoaDon] OFF
GO
SET IDENTITY_INSERT [dbo].[Thuoc] ON 
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (102, N'Almagat', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (103, N'Argyron', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (104, N'Boldine', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (105, N'Aspartam', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (106, N'Berberin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (107, N'Carbomer', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (108, N'Lactitol', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (109, N'Macrogol', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (110, N'Mequinol', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (111, N'Naproxen', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (112, N'Orlistat', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (113, N'Oxeladin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (114, N'Pyrantel', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (115, N'Acyclovir', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (116, N'Azelastin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (117, N'Bisacodyl', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (118, N'Budesonid', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (119, N'Cimetidin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (120, N'Cinarizin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (121, N'Citrullin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (122, N'Clorophyl', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (123, N'Eprazinon', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (124, N'Famotidin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (125, N'Ibuprofen', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (126, N'Lactulose', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (127, N'Loperamid', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (128, N'Mebeverin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (129, N'Miconazol', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (130, N'Minoxidil', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (131, N'Mupirocin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (132, N'Noscarpin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (133, N'Omeprazol', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (134, N'Panthenol', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (135, N'Piroxicam', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (136, N'Ranitidin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (137, N'Sucralfat', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (138, N'Tolnaftat', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (139, N'Albendazol', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (140, N'Attapulgit', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (141, N'Crotamiton', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (142, N'Dicyclomin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (143, N'Etofenamat', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (144, N'Ichthammol', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (145, N'Isoconazol', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (146, N'Kẽm sulfat', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (147, N'Ketoprofen', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (148, N'Loxoprofen', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (149, N'Mangiferin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (150, N'Mebendazol', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (151, N'Mequitazin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (152, N'Mometasone', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (153, N'Oxomemazin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (154, N'Picloxydin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (155, N'Terbinafin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (156, N'Butoconazol', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (157, N'Clorhexidin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (158, N'Clotrimazol', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (159, N'Dimethinden', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (160, N'Đồng sulfat', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (161, N'Fexofenadin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (162, N'Hydrotalcit', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (163, N'Sulbutiamin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (164, N'Acetylleucin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (165, N'Acid alginic', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (166, N'Carbocystein', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (167, N'Desloratadin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (168, N'Dexpanthenol', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (169, N'Fenticonazol', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (170, N'Flurbiprofen', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (171, N'Indomethacin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (172, N'Metronidazol', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (173, N'Oxymetazolin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (174, N'Pentoxyverin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (175, N'Phospholipid', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (176, N'Polysacharid', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (177, N'Selen sulfid', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (178, N'Acetylcystein', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (179, N'Dimenhydrinat', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (180, N'Levocetirizin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (181, N'Natri Docusat', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (182, N'Povidon Iodin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (183, N'Xanh Methylen', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (184, N'Acid mefenamic', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (185, N'Alcol polyvinyl', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (186, N'Tetrahydrozolin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (187, N'Bismuth dạng muối', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (188, N'Ciclopirox olamin', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (189, N'Clobetason butyrat', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (190, N'Acid acetylsalicylic', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (191, N'Diethylphtalat (DEP)', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (192, N'Lactoserum atomisate', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (193, N'Chitosan (Polyglusam)', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (194, N'Ephedrin Hydrochlorid', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (195, N'Ossein hydroxy apatit', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (196, N'Isopropyl Methylphenol', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (197, N'Mercurocrom (Thuốc đỏ)', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (198, N'Saccharomyces boulardic', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (199, N'Cetirizin dihydrochlorid', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (200, N'Natri Monofluorophosphat', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (201, N'Phenylephrin Hydrochlorid', N'Vỉ', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (202, N'Sterculia (gum sterculia)', N'Vỉ', 20000, 30000)
GO
SET IDENTITY_INSERT [dbo].[Thuoc] OFF
GO
ALTER TABLE [dbo].[DoiTac] ADD  CONSTRAINT [DF_DoiTac_LaNhaCungCap]  DEFAULT ((0)) FOR [LaNhaCungCap]
GO
ALTER TABLE [dbo].[ChiTietHoaDon]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietHoaDon_HoaDon] FOREIGN KEY([MaHoaDon])
REFERENCES [dbo].[HoaDon] ([MaHoaDon])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ChiTietHoaDon] CHECK CONSTRAINT [FK_ChiTietHoaDon_HoaDon]
GO
ALTER TABLE [dbo].[ChiTietHoaDon]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietHoaDon_Thuoc] FOREIGN KEY([MaThuoc])
REFERENCES [dbo].[Thuoc] ([MaThuoc])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ChiTietHoaDon] CHECK CONSTRAINT [FK_ChiTietHoaDon_Thuoc]
GO
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD  CONSTRAINT [FK_HoaDon_DoiTac] FOREIGN KEY([MaDoiTac])
REFERENCES [dbo].[DoiTac] ([MaDoiTac])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[HoaDon] CHECK CONSTRAINT [FK_HoaDon_DoiTac]
GO
