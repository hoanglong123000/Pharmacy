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
select GetDate() NgayHoaDon, N'T???ng c???ng: ' TenDoiTac,  Sum(ThanhTienMuaHang) ThanhTienMuaHang, sum(ThanhTienBanHang)  ThanhTienBanHang
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
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (362, N'Ho??ng Duy An', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (363, N'Ph???m Ng???c B???o An', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (364, N'Nguy???n Ng???c Minh An', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (365, N'?????ng Ph????ng Anh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (366, N'Tr???n Ph????ng Anh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (367, N'Tr???n Ng?? H?? Anh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (368, N'Nguy???n H?? Anh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (369, N'Nguy???n H?? Minh Anh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (370, N'Nguy???n Ng???c Anh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (371, N'Nguy???n D????ng Duy', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (372, N'Nguy???n Quang ?????c', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (373, N'D????ng Ch??u Giang', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (374, N'Nguy???n ?????c Giang', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (375, N'C???n H???i Hi???p', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (376, N'Ph???m V?? Hi???p', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (377, N'Ph???m ?????c Hi???u', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (378, N'Ho??ng Anh Huy', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (379, N'????? Minh Khang A', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (380, N'????? Minh Khang B', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (381, N'V????ng Mai Khanh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (382, N'L?? Quang Kh??nh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (383, N'L?? Nguy???n ????ng Khoa', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (384, N'L?? Tu??? Lam', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (385, N'Ho??ng T??ng L??m', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (386, N'????m Gia Linh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (387, N'Tr???n L?? Ph????ng Linh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (388, N'V?? Kh??nh Nam', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (389, N'????m B???o Ng???c', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (390, N'Nguy???n B???o Ng???c', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (391, N'V?? T??ng Qu??n', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (392, N'?????ng Ng???c S??n', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (393, N'Ho??ng Thu Th???y', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (394, N'Ph???m B???o Tr??m', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (395, N'Tr???n Minh Tu???n', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (396, N'??inh Gia V??', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (397, N'L?? Kh??nh Vy', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (398, N'Nguy???n H?? Vi', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (399, N'Nguy???n H???i Y???n', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (400, N'Ho??ng ?????c Anh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (401, N'????? Ho??ng Anh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (402, N'Ph???m H???i Ng???c Anh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (403, N'Ph???m Th??? Ph????ng Anh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (404, N'Nguy???n Trang Anh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (405, N'Nguy???n Ng???c Tr??m Anh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (406, N'V?? ??inh Minh Ch??u', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (407, N'B??i Tr?? D??ng', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (408, N'Ho??ng Minh ?????t', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (409, N'V?? Ng??n H??', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (410, N'V?? Ng???c H??', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (411, N'Nguy???n Ng???c B???o H??n', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (412, N'Nguy???n Tu???n H??ng', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (413, N'Nguy???n Ch???n H??ng', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (414, N'Nguy???n Minh Khang', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (415, N'Nguy???n ????ng Khoa', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (416, N'Tr???n ????ng Kh??i', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (417, N'Tr???nh Tu???n Kh??i', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (418, N'Nguy???n Ch?? Ki??n', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (419, N'Tr???nh T??ng L??m', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (420, N'Ph???m H?? Linh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (421, N'Nguy???n Ng???c Linh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (422, N'Tr???n Quang Minh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (423, N'Ph???m H???i Nam', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (424, N'Tr???n B???o Ng???c', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (425, N'L????ng Uy??n Nhi', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (426, N'????? Nam Phong', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (427, N'Nguy???n ????nh Ph??', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (428, N'L?? Xu??n Ph??c', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (429, N'Nguy???n Tr???n H?? Ph????ng', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (430, N'Nguy???n ????nh Qu??', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (431, N'Tr???n Minh S??n', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (432, N'Tr???n Anh Th??', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (433, N'Nguy???n Kh??nh To??n', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (434, N'?????ng Th??nh Trang', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (435, N'Lai ????nh Uy', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (436, N'V?? T?????ng Vi', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (437, N'Tr???nh Vy Vy', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (438, N'?????ng Th???o An', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (439, N'Ph???m ??o??n H???ng Anh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (440, N'Nguy???n Y???n Anh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (441, N'?????ng Huy???n Thu Anh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (442, N'B??i Th??? Ho??i Anh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (443, N'B??i V?? Minh Anh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (444, N'Tr???n Nguy???n Ph????ng Anh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (445, N'Nguy???n Ho??ng H???ng Anh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (446, N'V?? Nguy???n K??? Anh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (447, N'Tr???n ????? Di???p Anh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (448, N'Ho??ng Kh??nh Chi', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (449, N'Nguy???n Th??y Chi', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (450, N'V?? M???nh C?????ng', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (451, N'Tr???n Minh ?????c', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (452, N'Ph???m B???o H??n', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (453, N'Nguy???n Huy Ho??ng', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (454, N'Nguy???n Ng???c Minh Huy', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (455, N'V?? Thu Huy???n', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (456, N'Nguy???n Quang H??ng', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (457, N'V?? Th??nh H??ng', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (458, N'Phan ????ng Khoa', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (459, N'V?? Ho??ng L??m', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (460, N'Nguy???n B???o Linh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (461, N'B??i H?? Linh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (462, N'Ng?? Ho??ng Minh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (463, N'V?? Minh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (464, N'Nguy???n Ph????ng Ng??n', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (465, N'??inh Tr???ng Ngh??a', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (466, N'L????ng Gia B???o Ng???c', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (467, N'V???? Kh??i Nguy??n', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (468, N'Nguy???n Ng???c Thanh Th???y', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (469, N'Tr???n Th??? Thanh Th???y', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (470, N'V?? Tr???n Minh Ti???n', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (471, N'??inh ?????c T??ng', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (472, N'Nguy???n H???i M??? Uy??n', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (473, N'????o Ph????ng Anh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (474, N'Tr???n Minh Anh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (475, N'Tr???nh Th??? M??? Anh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (476, N'V?? Th??? Ng???c Anh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (477, N'V?? H???i Anh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (478, N'Nguy???n L?? Ng???c B??ch', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (479, N'Phan Th??? B??ch Di???p', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (480, N'Ph???m Nguy???n H???ng Di???p', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (481, N'????o Tu??? D????ng', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (482, N'H?? Tr???n H????ng Giang', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (483, N'????o Ng??n H??', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (484, N'Nguy???n B???o H??n', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (485, N'V?? Ho??ng Trung Hi???u', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (486, N'Ng Kh???ng Quang H??ng', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (487, N'Ph???m V??n ????ng Kh??i', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (488, N'Ho??ng V??n Th???y Khanh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (489, N'V????ng Minh Khu??', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (490, N'Ph???m Ho??ng Linh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (491, N'L?? Nguy???n Th???o Linh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (492, N'Ph???m Nguy???n B??nh Minh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (493, N'Ph???m Quang Minh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (494, N'Tr???n B??nh Minh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (495, N'????o C??ng Minh', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (496, N'Nguy???n Linh Ng??n', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (497, N'V?? Ho??ng Th??nh Nh??n', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (498, N'Ph???m Nguy???n Nh?? Nhi', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (499, N'Nguy???n Ho??ng Hi???u Phan', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (500, N'T?? H???ng Ph??c', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (501, N'Ph???m Ho??ng Ph??c', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (502, N'Nguy???n Ph????ng Kh??nh Ng???c', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (503, N'Nguy???n Mai Ph????ng', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (504, N'????? Ho??ng Ph????ng', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (505, N'V?? Tr???ng T??n', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (506, N'Ph???m ?????c Th???nh', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (507, N'Ph???m Th??? Minh Th??', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (508, N'L?? Tu???n T??', N'H???i Ph??ng', NULL, 0)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (509, N'Ph???m Anh Tu???n', N'H???i Ph??ng', NULL, 1)
GO
INSERT [dbo].[DoiTac] ([MaDoiTac], [TenDoiTac], [DiaChi], [DienThoai], [LaNhaCungCap]) VALUES (510, N'Tr???nh Thanh T??ng', N'H???i Ph??ng', NULL, 0)
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
INSERT [dbo].[HoaDon] ([MaHoaDon], [NgayHoaDon], [MaDoiTac], [HoaDonMua], [GhiChu]) VALUES (17, CAST(N'2020-10-27' AS Date), 494, 1, N'Mua nhi???u th?? nh???p tay cho ?????n bao gi???????')
GO
INSERT [dbo].[HoaDon] ([MaHoaDon], [NgayHoaDon], [MaDoiTac], [HoaDonMua], [GhiChu]) VALUES (18, CAST(N'2020-10-27' AS Date), 470, 0, N'b??n nh??? check kho xem c?? hay ko nh??')
GO
SET IDENTITY_INSERT [dbo].[HoaDon] OFF
GO
SET IDENTITY_INSERT [dbo].[Thuoc] ON 
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (102, N'Almagat', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (103, N'Argyron', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (104, N'Boldine', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (105, N'Aspartam', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (106, N'Berberin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (107, N'Carbomer', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (108, N'Lactitol', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (109, N'Macrogol', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (110, N'Mequinol', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (111, N'Naproxen', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (112, N'Orlistat', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (113, N'Oxeladin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (114, N'Pyrantel', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (115, N'Acyclovir', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (116, N'Azelastin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (117, N'Bisacodyl', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (118, N'Budesonid', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (119, N'Cimetidin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (120, N'Cinarizin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (121, N'Citrullin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (122, N'Clorophyl', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (123, N'Eprazinon', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (124, N'Famotidin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (125, N'Ibuprofen', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (126, N'Lactulose', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (127, N'Loperamid', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (128, N'Mebeverin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (129, N'Miconazol', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (130, N'Minoxidil', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (131, N'Mupirocin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (132, N'Noscarpin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (133, N'Omeprazol', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (134, N'Panthenol', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (135, N'Piroxicam', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (136, N'Ranitidin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (137, N'Sucralfat', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (138, N'Tolnaftat', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (139, N'Albendazol', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (140, N'Attapulgit', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (141, N'Crotamiton', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (142, N'Dicyclomin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (143, N'Etofenamat', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (144, N'Ichthammol', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (145, N'Isoconazol', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (146, N'K???m sulfat', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (147, N'Ketoprofen', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (148, N'Loxoprofen', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (149, N'Mangiferin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (150, N'Mebendazol', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (151, N'Mequitazin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (152, N'Mometasone', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (153, N'Oxomemazin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (154, N'Picloxydin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (155, N'Terbinafin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (156, N'Butoconazol', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (157, N'Clorhexidin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (158, N'Clotrimazol', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (159, N'Dimethinden', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (160, N'?????ng sulfat', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (161, N'Fexofenadin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (162, N'Hydrotalcit', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (163, N'Sulbutiamin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (164, N'Acetylleucin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (165, N'Acid alginic', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (166, N'Carbocystein', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (167, N'Desloratadin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (168, N'Dexpanthenol', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (169, N'Fenticonazol', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (170, N'Flurbiprofen', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (171, N'Indomethacin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (172, N'Metronidazol', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (173, N'Oxymetazolin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (174, N'Pentoxyverin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (175, N'Phospholipid', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (176, N'Polysacharid', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (177, N'Selen sulfid', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (178, N'Acetylcystein', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (179, N'Dimenhydrinat', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (180, N'Levocetirizin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (181, N'Natri Docusat', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (182, N'Povidon Iodin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (183, N'Xanh Methylen', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (184, N'Acid mefenamic', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (185, N'Alcol polyvinyl', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (186, N'Tetrahydrozolin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (187, N'Bismuth d???ng mu???i', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (188, N'Ciclopirox olamin', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (189, N'Clobetason butyrat', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (190, N'Acid acetylsalicylic', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (191, N'Diethylphtalat (DEP)', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (192, N'Lactoserum atomisate', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (193, N'Chitosan (Polyglusam)', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (194, N'Ephedrin Hydrochlorid', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (195, N'Ossein hydroxy apatit', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (196, N'Isopropyl Methylphenol', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (197, N'Mercurocrom (Thu???c ?????)', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (198, N'Saccharomyces boulardic', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (199, N'Cetirizin dihydrochlorid', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (200, N'Natri Monofluorophosphat', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (201, N'Phenylephrin Hydrochlorid', N'V???', 20000, 30000)
GO
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [DonViTinh], [DonGiaMua], [DonGiaBan]) VALUES (202, N'Sterculia (gum sterculia)', N'V???', 20000, 30000)
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
