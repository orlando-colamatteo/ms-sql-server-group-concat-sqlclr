﻿/*
Installation script for GROUP_CONCAT functions. Tested in SSMS 2008R2.
*/
SET NOCOUNT ON ;
GO

-- !! MODIFY TO SUIT YOUR TEST ENVIRONMENT !!
USE GroupConcatTest
GO

-------------------------------------------------------------------------------------------------------------------------------
-- Turn advanced options on
EXEC sys.sp_configure @configname = 'show advanced options', @configvalue = 1 ;
GO
RECONFIGURE WITH OVERRIDE ;
GO
-- Enable CLR
EXEC sys.sp_configure @configname = 'clr enabled', @configvalue = 1 ;
GO
RECONFIGURE WITH OVERRIDE ;
GO
-------------------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, QUOTED_IDENTIFIER ON;
SET CONCAT_NULL_YIELDS_NULL, NUMERIC_ROUNDABORT OFF;
GO
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#tmpErrors')) DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION
GO
-------------------------------------------------------------------------------------------------------------------
PRINT N'Creating [GroupConcat]...';
GO
CREATE ASSEMBLY [GroupConcat]
    AUTHORIZATION [dbo]
    FROM 0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000800000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A2400000000000000504500004C0103002454634F0000000000000000E00002210B010800001E00000008000000000000DE3C0000002000000040000000004000002000000002000004000000000000000400000000000000008000000002000000000000030040850000100000100000000010000010000000000000100000000000000000000000843C000057000000004000003804000000000000000000000000000000000000006000000C00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000080000000000000000000000082000004800000000000000000000002E74657874000000E41C000000200000001E000000020000000000000000000000000000200000602E7273726300000038040000004000000006000000200000000000000000000000000000400000402E72656C6F6300000C0000000060000000020000002600000000000000000000000000004000004200000000000000000000000000000000C03C0000000000004800000002000500382C00004C10000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002204036F0E00000A2A1E02280F00000A2A0000001330020024000000010000110F01FE16060000016F1300000A0A027B0200000406281400000A2C0702067D020000042A5E02731500000A7D01000004027E1600000A7D020000042A133004004F000000020000110F01281700000A2D450F01281800000A0A027B01000004066F1900000A2C1B027B01000004250B06250C07086F1A00000A17586F1B00000A2B0D027B0100000406176F1C00000A020428030000062A001B3005007D000000030000110F017B010000046F1D00000A0C2B541202281E00000A0A1200281F00000A0B027B01000004076F1900000A2C29027B01000004250D072513040911046F1A00000A0F017B01000004076F1A00000A586F1B00000A2B0D027B0100000407176F1C00000A1202282000000A2DA3DE0E1202FE160300001B6F2100000ADC2A0000000110000002000D00616E000E000000001B300300B300000004000011027B0100000439A1000000027B010000046F2200000A163E90000000732300000A0A027B010000046F1D00000A0D2B351203281E00000A0B160C2B1F061201281F00000A6F2400000A2606027B020000046F2400000A260817580C081201282500000A32D71203282000000A2DC2DE0E1203FE160300001B6F2100000ADC06066F2600000A027B020000046F2700000A59027B020000046F2700000A6F2800000A6F1300000A282900000A2A14282900000A2A000110000002002E004270000E00000000133003004500000005000011036F2A00000A0A0206732B00000A7D01000004160B2B1B027B01000004036F2C00000A036F2A00000A6F1C00000A0717580B0706175931DF02036F2C00000A7D020000042A0000001B300200670000000600001103027B010000046F2200000A6F2D00000A027B010000046F1D00000A0B2B221201281E00000A0A031200281F00000A6F2E00000A031200282500000A6F2D00000A1201282000000A2DD5DE0E1201FE160300001B6F2100000ADC03027B020000046F2E00000A2A000110000002001D002F4C000E00000000EA027B040000042D310F01282F00000A172E150F01282F00000A182E0B7201000070733000000A7A020F01282F00000A283100000A7D040000042A4E02731500000A7D0300000402167D040000042A00133004004F000000020000110F01281700000A2D450F01281800000A0A027B03000004066F1900000A2C1B027B03000004250B06250C07086F1A00000A17586F1B00000A2B0D027B0300000406176F1C00000A0204280A0000062A001B3005007D000000030000110F017B030000046F1D00000A0C2B541202281E00000A0A1200281F00000A0B027B03000004076F1900000A2C29027B03000004250D072513040911046F1A00000A0F017B03000004076F1A00000A586F1B00000A2B0D027B0300000407176F1C00000A1202282000000A2DA3DE0E1202FE160300001B6F2100000ADC2A0000000110000002000D00616E000E000000001B300300C800000007000011027B0300000439B6000000027B030000046F2200000A163EA5000000732300000A0B027B04000004183313027B030000047302000006733200000A0A2B0C027B03000004733300000A0A066F3400000A13052B3A1205283500000A0C1202281F00000A0D1613042B1A07096F2400000A260772670000706F2400000A2611041758130411041202282500000A32DB1205283600000A2DBDDE0E1205FE160600001B6F2100000ADC07076F2600000A1759176F2800000A6F1300000A282900000A2A14282900000A2A01100000020052004799000E00000000133003004500000005000011036F2A00000A0A0206732B00000A7D03000004160B2B1B027B03000004036F2C00000A036F2A00000A6F1C00000A0717580B0706175931DF02036F3700000A7D040000042A0000001B300200670000000600001103027B030000046F2200000A6F2D00000A027B030000046F1D00000A0B2B221201281E00000A0A031200281F00000A6F2E00000A031200282500000A6F2D00000A1201282000000A2DD5DE0E1201FE160300001B6F2100000ADC03027B040000046F3800000A2A000110000002001D002F4C000E000000001330020024000000010000110F01FE16060000016F1300000A0A027B0600000406281400000A2C0702067D060000042AEA027B070000042D310F01282F00000A172E150F01282F00000A182E0B7201000070733000000A7A020F01282F00000A283100000A7D070000042A7A02731500000A7D05000004027E1600000A7D0600000402167D070000042A00001330040056000000020000110F01281700000A2D4C0F01281800000A0A027B05000004066F1900000A2C1B027B05000004250B06250C07086F1A00000A17586F1B00000A2B0D027B0500000406176F1C00000A02042811000006020528120000062A00001B3005007D000000030000110F017B050000046F1D00000A0C2B541202281E00000A0A1200281F00000A0B027B05000004076F1900000A2C29027B05000004250D072513040911046F1A00000A0F017B05000004076F1A00000A586F1B00000A2B0D027B0500000407176F1C00000A1202282000000A2DA3DE0E1202FE160300001B6F2100000ADC2A0000000110000002000D00616E000E000000001B300300D700000008000011027B0500000439C5000000027B050000046F2200000A163EB4000000732300000A0B027B07000004183313027B050000047302000006733200000A0A2B0C027B05000004733300000A0A066F3400000A13042B351204283500000A0C160D2B1F071202281F00000A6F2400000A2607027B060000046F2400000A260917580D091202282500000A32D71204283600000A2DC2DE0E1204FE160600001B6F2100000ADC07076F2600000A027B060000046F2700000A59027B060000046F2700000A6F2800000A6F1300000A282900000A2A14282900000A2A0001100000020052004294000E00000000133003005100000005000011036F2A00000A0A0206732B00000A7D05000004160B2B1B027B05000004036F2C00000A036F2A00000A6F1C00000A0717580B0706175931DF02036F2C00000A7D0600000402036F3700000A7D070000042A0000001B300200730000000600001103027B050000046F2200000A6F2D00000A027B050000046F1D00000A0B2B221201281E00000A0A031200281F00000A6F2E00000A031200282500000A6F2D00000A1201282000000A2DD5DE0E1201FE160300001B6F2100000ADC03027B060000046F2E00000A03027B070000046F3800000A2A000110000002001D002F4C000E000000003202731500000A7D080000042A0000001330040047000000020000110F01281700000A2D3D0F01281800000A0A027B08000004066F1900000A2C1A027B08000004250B06250C07086F1A00000A17586F1B00000A2A027B0800000406176F1C00000A2A001B3005007D000000030000110F017B080000046F1D00000A0C2B541202281E00000A0A1200281F00000A0B027B08000004076F1900000A2C29027B08000004250D072513040911046F1A00000A0F017B08000004076F1A00000A586F1B00000A2B0D027B0800000407176F1C00000A1202282000000A2DA3DE0E1202FE160300001B6F2100000ADC2A0000000110000002000D00616E000E000000001B3003009B00000004000011027B080000043989000000027B080000046F2200000A16317B732300000A0A027B080000046F1D00000A0D2B341203281E00000A0B160C2B1E061201281F00000A6F2400000A260672670000706F2400000A260817580C081201282500000A32D81203282000000A2DC3DE0E1203FE160300001B6F2100000ADC06066F2600000A1759176F2800000A6F1300000A282900000A2A14282900000A2A000110000002002B00416C000E00000000133003003900000005000011036F2A00000A0A0206732B00000A7D08000004160B2B1B027B08000004036F2C00000A036F2A00000A6F1C00000A0717580B0706175931DF2A0000001B3002005B0000000600001103027B080000046F2200000A6F2D00000A027B080000046F1D00000A0B2B221201281E00000A0A031200281F00000A6F2E00000A031200282500000A6F2D00000A1201282000000A2DD5DE0E1201FE160300001B6F2100000ADC2A000110000002001D002F4C000E0000000042534A4201000100000000000C00000076322E302E35303732370000000005006C000000BC060000237E0000280700005405000023537472696E6773000000007C0C00006C00000023555300E80C0000100000002347554944000000F80C00005403000023426C6F6200000000000000020000015717A2090900000000FA253300160000010000002500000006000000080000001E0000001E0000000500000038000000180000000800000003000000040000000400000006000000010000000300000000000A00010000000000060081007A000600A30088000600AF007A000A00E000C5000600FF0088000A0032011D01060074016A01060086016A010A00AA011D010A00D401C50006001702050206002E02050206004B02050206006A02050206008302050206009C0205020600B70205020600D202050206000A03EB0206001E030502060057033703060077033703060095037A000600A6037A000A00BC03C5000A00DD03C5000600E403EB020600FA03EB0217005904000006007204880006009E047A000600C804BC04060010057A0006001A057A000E002905880006003C0588008F00590400000000000001000000000001000100010010001A002A000500010001000921100036002A000D00010003000921100045002A000D0003000A000921100054002A000D00050011000921100064002A000D000800190001000C011A0001001301220001000C011A000100A3014F0001000C011A000100130122000100A3014F0001000C011A00502000000000E601F100100001005920000000008618F9001600030064200000000081083C012500030094200000000086004A0116000400AC200000000086004F012B00040008210000000086005A0133000600A421000000008600600139000700742200000000E60181013E000800C82200000000E6019301440009004C23000000008108B20152000A0087230000000086004A0116000B009C230000000086004F0158000B00F8230000000086005A0160000D009424000000008600600139000E00782500000000E60181013E000F00CC2500000000E60193014400100050260000000081083C01250011008026000000008108B20152001200BB260000000086004A0116001300DC260000000086004F016B00130040270000000086005A0175001600DC27000000008600600139001700D02800000000E60181013E001800302900000000E601930144001900C0290000000086004A0116001A00D0290000000086004F0125001A00242A0000000086005A017B001B00C02A000000008600600139001C00782B00000000E60181013E001D00C02B00000000E601930144001E0000000100C40100000200C60100000100C80100000100CE0100000200E60100000100F00100000000000000000100F60100000100F80100000100C80100000100CE0100000200FA0100000100F00100000000000000000100F60100000100F80100000100C80100000100C80100000100CE0100000200E60100000300FA0100000100F00100000000000000000100F60100000100F80100000100CE0100000100F00100000000000000000100F60100000100F80102000600030011000400110005001100060011005100F90016005900F900BA006100F900BA006900F900BA007100F900BA007900F900BA008100F900BA008900F900BA009100F900BA009900F900BF00A100F900BA00A900F900C400B100F9001600B9009C03C9000900F9001600C100F9001600C900F900CE00D900F9004701090005044D01B9000E0451011400F9001600B9001C04220031002204620131002D044D01140037046601140043046C0114004C0473011400550473011400640486011C008104980124008D04AA011C0095046201F900AA0416001400B204C6010101F90016000101D604CA0124002D04D1010101DD04C601B900DD04C6010101E804D6013100EF04DE013900FB04C6011400F900C400390005054D0141009301C40041009301BA0049002D040B020901F900BA00110122050F022C00F9001C022C00F9002F022C0064043C0234008104980134009504620139004A050B02410093016C022E006B0035032E002B000E032E0013008C022E001B009D022E0023000E032E003B0014032E0033008C022E0043000E032E0053000E032E0063002C0363008B00D40083008B00D40084000B008100A3008B00D400A4000B009400C3008B00D400E4000B00A70064010B008100C4010B00A70064020B00810084020B009400E4020B00A70044030B00810084030B00A70057017B01AF01E401F701FC0150027102030001000400020005000300000099014A000000BD016600000099014A000000BD01660001000300030001000A0005000100110007000100120009000A005B019101A3011402480204800000010000006A119A370000000000002A00000002000000000000000000000001007100000000000200000000000000000000000100B9000000000002000000000000000000000001007A00000000000000003C4D6F64756C653E0047726F7570436F6E6361742E646C6C0052657665727365436F6D70617265720047726F7570436F6E6361740047524F55505F434F4E4341545F440047524F55505F434F4E4341545F530047524F55505F434F4E4341545F44530047524F55505F434F4E434154006D73636F726C69620053797374656D004F626A6563740053797374656D2E436F6C6C656374696F6E732E47656E657269630049436F6D706172657260310056616C7565547970650053797374656D2E44617461004D6963726F736F66742E53716C5365727665722E536572766572004942696E61727953657269616C697A6500436F6D70617265002E63746F720044696374696F6E61727960320076616C7565730064656C696D697465720053797374656D2E446174612E53716C54797065730053716C537472696E67007365745F44656C696D6974657200496E697400416363756D756C617465004D65726765005465726D696E6174650053797374656D2E494F0042696E61727952656164657200526561640042696E6172795772697465720057726974650044656C696D6974657200736F727442790053716C42797465007365745F536F7274427900536F72744279007800790076616C75650056414C55450053716C46616365744174747269627574650044454C494D495445520047726F75700072007700534F52545F4F524445520053797374656D2E5265666C656374696F6E00417373656D626C795469746C6541747472696275746500417373656D626C794465736372697074696F6E41747472696275746500417373656D626C79436F6E66696775726174696F6E41747472696275746500417373656D626C79436F6D70616E7941747472696275746500417373656D626C7950726F6475637441747472696275746500417373656D626C79436F7079726967687441747472696275746500417373656D626C7954726164656D61726B41747472696275746500417373656D626C7943756C747572654174747269627574650053797374656D2E52756E74696D652E496E7465726F70536572766963657300436F6D56697369626C6541747472696275746500417373656D626C7956657273696F6E4174747269627574650053797374656D2E52756E74696D652E436F6D70696C6572536572766963657300436F6D70696C6174696F6E52656C61786174696F6E734174747269627574650052756E74696D65436F6D7061746962696C69747941747472696275746500537472696E6700436F6D70617265546F0053657269616C697A61626C654174747269627574650053716C55736572446566696E656441676772656761746541747472696275746500466F726D6174005374727563744C61796F7574417474726962757465004C61796F75744B696E6400546F537472696E67006F705F496E657175616C69747900456D707479006765745F49734E756C6C006765745F56616C756500436F6E7461696E734B6579006765745F4974656D007365745F4974656D0041646400456E756D657261746F7200476574456E756D657261746F72004B657956616C7565506169726032006765745F43757272656E74006765745F4B6579004D6F76654E6578740049446973706F7361626C6500446973706F7365006765745F436F756E740053797374656D2E5465787400537472696E674275696C64657200417070656E64006765745F4C656E6774680052656D6F7665006F705F496D706C696369740052656164496E7433320052656164537472696E6700457863657074696F6E00436F6E7665727400546F4279746500536F7274656444696374696F6E6172796032004944696374696F6E61727960320052656164427974650000006549006E00760061006C0069006400200053006F0072007400420079002000760061006C00750065003A00200075007300650020003100200066006F007200200041005300430020006F00720020003200200066006F007200200044004500530043002E0000032C0000003D06AA77BA3EE241AA3E6C354E99AFF20008B77A5C561934E08905151209010E052002080E0E032000010706151215020E0802060E052001011119072002011119111905200101110C042000111905200101121D0520010112210428001119020605052001011125072002011119112505200101111004280011250920030111191119112505200101111405200101111812010001005408074D617853697A65A00F000012010001005408074D617853697A650400000012010001005408074D617853697A65FFFFFFFF042001010E04200101020420010108042001080E05200101116972010002000000050054080B4D61784279746553697A65FFFFFFFF5402124973496E76617269616E74546F4E756C6C73015402174973496E76617269616E74546F4475706C696361746573005402124973496E76617269616E74546F4F726465720154020D49734E756C6C4966456D707479010520010111710320000E050002020E0E0307010E06151215020E08032000020520010213000620011301130007200201130013010A07030E151215020E080E0A2000151175021300130106151175020E080A2000151179021300130106151179020E080420001300160705151179020E080E151175020E08151215020E080E032000080620011280810E0420001301072002128081080805000111190E120704128081151179020E0808151175020E0804070208080E0702151179020E08151175020E08032000050400010505071512808D020E08122002011512809102130013011512090113000C2001011512809102130013010B20001511809502130013010715118095020E081B07061512808D020E08128081151179020E080E0815118095020E0804200101051A07051512808D020E08128081151179020E080815118095020E081001000B47726F7570436F6E63617400007001006B537472696E6720636F6E636174656E6174696F6E2061676772656761746520666F722053514C205365727665722E2044726F702D696E207265706C6163656D656E7420666F72206275696C742D696E204D7953514C2047524F55505F434F4E4341542066756E74696F6E2E000005010000000017010012436F7079726967687420C2A920203230313100000801000800000000001E01000100540216577261704E6F6E457863657074696F6E5468726F777301AC3C00000000000000000000CE3C0000002000000000000000000000000000000000000000000000C03C00000000000000000000000000000000000000005F436F72446C6C4D61696E006D73636F7265652E646C6C0000000000FF2500204000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100100000001800008000000000000000000000000000000100010000003000008000000000000000000000000000000100000000004800000058400000E00300000000000000000000E00334000000560053005F00560045005200530049004F004E005F0049004E0046004F0000000000BD04EFFE00000100000001009A376A11000001009A376A113F000000000000000400000002000000000000000000000000000000440000000100560061007200460069006C00650049006E0066006F00000000002400040000005400720061006E0073006C006100740069006F006E00000000000000B00440030000010053007400720069006E006700460069006C00650049006E0066006F0000001C0300000100300030003000300030003400620030000000F0006C00010043006F006D006D0065006E0074007300000053007400720069006E006700200063006F006E0063006100740065006E006100740069006F006E002000610067006700720065006700610074006500200066006F0072002000530051004C0020005300650072007600650072002E002000440072006F0070002D0069006E0020007200650070006C006100630065006D0065006E007400200066006F00720020006200750069006C0074002D0069006E0020004D007900530051004C002000470052004F00550050005F0043004F004E004300410054002000660075006E00740069006F006E002E00000040000C000100460069006C0065004400650073006300720069007000740069006F006E0000000000470072006F007500700043006F006E00630061007400000040000F000100460069006C006500560065007200730069006F006E000000000031002E0030002E0034003400350038002E00310034003200330034000000000040001000010049006E007400650072006E0061006C004E0061006D0065000000470072006F007500700043006F006E006300610074002E0064006C006C0000004800120001004C006500670061006C0043006F007000790072006900670068007400000043006F0070007900720069006700680074002000A90020002000320030003100310000004800100001004F0072006900670069006E0061006C00460069006C0065006E0061006D0065000000470072006F007500700043006F006E006300610074002E0064006C006C00000038000C000100500072006F0064007500630074004E0061006D00650000000000470072006F007500700043006F006E00630061007400000044000F000100500072006F006400750063007400560065007200730069006F006E00000031002E0030002E0034003400350038002E00310034003200330034000000000048000F00010041007300730065006D0062006C0079002000560065007200730069006F006E00000031002E0030002E0034003400350038002E003100340032003300340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000C000000E03C00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
    WITH PERMISSION_SET = SAFE;
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END
IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END
GO
EXEC sys.sp_addextendedproperty 
    @name = N'URL',
    @value = N'http://groupconcat.codeplex.com',
    @level0type = N'ASSEMBLY',
    @level0name = N'GroupConcat'
GO
-------------------------------------------------------------------------------------------------------------------
PRINT N'Creating [dbo].[GROUP_CONCAT_D]...';
GO
CREATE AGGREGATE [dbo].[GROUP_CONCAT_D](@VALUE NVARCHAR (4000), @DELIMITER NVARCHAR (4))
    RETURNS NVARCHAR (MAX)
    EXTERNAL NAME [GroupConcat].[GroupConcat.GROUP_CONCAT_D];
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END
IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END
GO
-------------------------------------------------------------------------------------------------------------------
PRINT N'Creating [dbo].[GROUP_CONCAT_S]...';
GO
CREATE AGGREGATE [dbo].[GROUP_CONCAT_S](@VALUE NVARCHAR (4000), @SORT_ORDER TINYINT)
    RETURNS NVARCHAR (MAX)
    EXTERNAL NAME [GroupConcat].[GroupConcat.GROUP_CONCAT_S];
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END
IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END
GO
-------------------------------------------------------------------------------------------------------------------
PRINT N'Creating [dbo].[GROUP_CONCAT_DS]...';
GO
CREATE AGGREGATE [dbo].[GROUP_CONCAT_DS](@VALUE NVARCHAR (4000), @DELIMITER NVARCHAR (4), @SORT_ORDER TINYINT)
    RETURNS NVARCHAR (MAX)
    EXTERNAL NAME [GroupConcat].[GroupConcat.GROUP_CONCAT_DS];
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END
IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END
GO
-------------------------------------------------------------------------------------------------------------------
PRINT N'Creating [dbo].[GROUP_CONCAT]...';
GO
CREATE AGGREGATE [dbo].[GROUP_CONCAT](@VALUE NVARCHAR (4000))
    RETURNS NVARCHAR (MAX)
    EXTERNAL NAME [GroupConcat].[GroupConcat.GROUP_CONCAT];
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END
IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END
GO
-------------------------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT N'The transacted portion of the database update succeeded.'
COMMIT TRANSACTION
END
ELSE PRINT N'The transacted portion of the database update failed.'
GO
DROP TABLE #tmpErrors
-------------------------------------------------------------------------------------------------------------------
GO
