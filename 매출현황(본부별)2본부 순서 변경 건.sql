
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('BODITECH_SSLSalesCentralListQuery_test_24') AND sysstat & 0xf = 4)
DROP PROCEDURE dbo.BODITECH_SSLSalesCentralListQuery_test_24
GO

/****** Object:  StoredProcedure [dbo].[BODITECH_SSLSalesCentralListQuery_test]    Script Date: 2023-05-04 오전 9:59:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************************    
 설    명 - SP - 매출현황 본부별(순서변경 테스트)
작 성 일 - 2023.07.10
작 성 자 - 김영웅
*************************************************************************************************/    
Create PROC [dbo].[BODITECH_SSLSalesCentralListQuery_test_24]  
    @xmlDocument    NVARCHAR(MAX)           -- Xml데이터
   ,@xmlFlags       INT             = 0     -- XmlFlag
   ,@ServiceSeq     INT             = 0     -- 서비스 번호
   ,@WorkingTag     NVARCHAR(10)    = ''    -- WorkingTag
   ,@CompanySeq     INT             = 1     -- 회사 번호
   ,@LanguageSeq    INT             = 1     -- 언어 번호
   ,@UserSeq        INT             = 0     -- 사용자 번호
   ,@PgmSeq         INT             = 0     -- 프로그램 번호
AS
    -- 영 나누기 오류 없앰
    SET ANSI_WARNINGS OFF  
    SET ARITHIGNORE ON  
    SET ARITHABORT OFF

    -- 변수선언 (조회조건)
    DECLARE  @docHandle     INT,
             @BizUnit       INT,
             @StdDate       NCHAR(8),
             @ExRate        DECIMAL(19,5),
             @SalesEmpSeq   INT,
             @SCMEmpSeq     INT,
             @CentralSeq    DECIMAL(19,5),
             @FYFMFD        NCHAR(8),
                         @YM1        NCHAR(6),
                         @YM2        NCHAR(6),
                         @YM3        NCHAR(6)






SET @YM2  =   left(convert(varchar(8),dateadd(year,+1,getdate()),112),4)+'01'



SET @YM3  =   left(convert(varchar(8),dateadd(year,+1,getdate()),112),4)+'02'


    -- Xml데이터 변수에 담기
    EXEC sp_xml_preparedocument @docHandle OUTPUT, @xmlDocument      
    SELECT @BizUnit     = ISNULL(BizUnit    ,0) ,
           @StdDate     = ISNULL(StdDate    ,''),
           @ExRate      = ISNULL(ExRate     ,0) ,
           @SalesEmpSeq = ISNULL(SalesEmpSeq,0) ,
           @SCMEmpSeq   = ISNULL(SCMEmpSeq  ,0) ,
           @CentralSeq  = ISNULL(CentralSeq ,0)
                   -- @CentralSeq  = CentralSeq
      FROM  OPENXML(@docHandle, N'/ROOT/DataBlock1', @xmlFlags)
      WITH (
              BizUnit       INT,
              StdDate       NCHAR(8),
              ExRate        DECIMAL(19,5),
              SalesEmpSeq   INT,
              SCMEmpSeq     INT,
              CentralSeq    INT
           )

    IF @StdDate = '' 
    BEGIN
        SET @StdDate = LEFT(CONVERT(NCHAR(8),GETDATE(),112),4)
    END

    SET @FYFMFD = LEFT(CONVERT(NCHAR(8),DATEADD(YY,-1,@StdDate),112),4) + '0101'

    
        DECLARE    @StdDate2       NCHAR(6)

        SET @StdDate2  = LEFT(CONVERT(NCHAR(8),GETDATE(),112),6)

    
    CREATE TABLE #Result
    (
        CentralName  NVARCHAR(100)  ,
        TeamName     NVARCHAR(100)  ,
        SalesEmpName NVARCHAR(100)  ,
        CountryName  NVARCHAR(100)  ,
        Month1       DECIMAL(19,5)  ,
        Month2       DECIMAL(19,5)  ,
        Month3       DECIMAL(19,5)  ,
        Month4       DECIMAL(19,5)  ,
        Month5       DECIMAL(19,5)  ,
        Month6       DECIMAL(19,5)  ,
        Month7       DECIMAL(19,5)  ,
        Month8       DECIMAL(19,5)  ,
        Month9       DECIMAL(19,5)  ,
        Month10      DECIMAL(19,5)  ,
        Month11      DECIMAL(19,5)  ,
        Month12      DECIMAL(19,5)  ,
        T_Month      DECIMAL(19,5)  ,
        L_Year       DECIMAL(19,5)  ,
        CentralSeq2   INT            ,
                 CentralSeq    DECIMAL(19,5),
        TeamSeq2      INT            ,
                 TeamSeq      DECIMAL(19,5),
        SalesEmpSeq  INT            ,
        CountrySeq   INT            ,
        Sort         INT            ,
        Color        INT
    )

    INSERT INTO #Result
    SELECT ISNULL(I.MinorName,' ')   AS CentralName   ,
           J.DeptName    AS TeamName      ,
           F.EmpName     AS SalesEmpName  ,
           L.MinorName   AS CountryName   ,

                   
                   SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '01' 
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END) 
                   
                                   AS Month1 ,

           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '02'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)       AS Month2        ,
           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '03'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)       AS Month3        ,
           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '04'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)       AS Month4        ,
           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '05'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)       AS Month5        ,
           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '06'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)       AS Month6        ,
           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '07'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)       AS Month7        ,
           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '08'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)       AS Month8        ,
           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '09'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)       AS Month9        ,

             SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '10'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)       AS Month10,  
                         
                         /*SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '10'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END) AS Month10       ,*/


                 /*CASE WHEN @StdDate2 < @StdDate+'10' THEN

           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '10'  
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END) 
                                          
                         ELSE
                         
                         SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '10' AND E1.ValueText = '1'  AND A.IsDelvCfm  = '1'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)   END
                         
                      AS Month10       ,*/




           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '11'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)       AS Month11       ,
           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '12'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)       AS Month12       , 


/*
           CASE WHEN @StdDate2 < @StdDate+'01' THEN

           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '01' 
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END) 
                                          
                         ELSE
                         
                         SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '01' AND E1.ValueText = '1'  AND A.IsDelvCfm  = '1'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)   END
                         
                      AS Month1       ,



                    
           CASE WHEN @StdDate2 < @StdDate+'02' THEN

           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '02' 
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END) 
                                          
                         ELSE
                         
                         SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '02' AND E1.ValueText = '1'  AND A.IsDelvCfm  = '1'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)   END
                         
                      AS Month2       ,

                            
           CASE WHEN @StdDate2 < @StdDate+'03' THEN

           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '03' 
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END) 
                                          
                         ELSE
                         
                         SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '03' AND E1.ValueText = '1'  AND A.IsDelvCfm  = '1'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)   END
                         
                      AS Month3       ,


                    CASE WHEN @StdDate2 < @StdDate+'04' THEN

           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '04' 
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END) 
                                          
                         ELSE
                         
                         SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '04' AND E1.ValueText = '1'  AND A.IsDelvCfm  = '1'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)   END
                         
                      AS Month4       ,


                             CASE WHEN @StdDate2 < @StdDate+'05' THEN

           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '05' 
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END) 
                                          
                         ELSE
                         
                         SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '05' AND E1.ValueText = '1'  AND A.IsDelvCfm  = '1'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)   END
                         
                      AS Month5       ,


                 CASE WHEN @StdDate2 < @StdDate+'06' THEN

           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '06' 
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END) 
                                          
                         ELSE
                         
                         SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '06' AND E1.ValueText = '1'  AND A.IsDelvCfm  = '1'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)   END
                         
                      AS Month6       ,


                             CASE WHEN @StdDate2 < @StdDate+'07' THEN

           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '07' 
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END) 
                                          
                         ELSE
                         
                         SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '07' AND E1.ValueText = '1'  AND A.IsDelvCfm  = '1'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)   END
                         
                      AS Month7       ,


                             CASE WHEN @StdDate2 < @StdDate+'08' THEN

           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '08' 
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END) 
                                          
                         ELSE
                         
                         SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '08' AND E1.ValueText = '1'  AND A.IsDelvCfm  = '1'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)   END
                         
                      AS Month8       ,

                             CASE WHEN @StdDate2 < @StdDate+'09' THEN

           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '09' 
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END) 
                                          
                         ELSE
                         
                         SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '09' AND E1.ValueText = '1'  AND A.IsDelvCfm  = '1'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)   END
                         
                      AS Month9       ,

                             CASE WHEN @StdDate2 < @StdDate+'10' THEN

           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '10' 
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END) 
                                          
                         ELSE
                         
                         SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '10' AND E1.ValueText = '1'  AND A.IsDelvCfm  = '1'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)   END
                         
                      AS Month10       ,

                             CASE WHEN @StdDate2 < @StdDate+'11' THEN

           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '11' 
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END) 
                                          
                         ELSE
                         
                         SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '11' AND E1.ValueText = '1'  AND A.IsDelvCfm  = '1'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)   END
                         
                      AS Month11       ,

                             CASE WHEN @StdDate2 < @StdDate+'12' THEN

           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '12' 
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END) 
                                          
                         ELSE
                         
                         SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = LEFT(@StdDate,4) + '12' AND E1.ValueText = '1'  AND A.IsDelvCfm  = '1'
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)   END
                         
                      AS Month12       ,



*/


           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),4) = LEFT(@StdDate,4)
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)        AS T_Month,


           SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),4) = LEFT(@FYFMFD,4)
                    THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                              WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                              ELSE 0 END
                    ELSE 0 END)       AS L_Year ,

           ISNULL(I.MinorSeq,2147483647) AS CentralSeq2    ,  

                     SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = SUBSTRING(@YM2,1,6)


                THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                            WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                            ELSE 0 END
                ELSE 0 END)       AS CentralSeq       , 


           E.DeptSeq                     AS TeamSeq2,


              SUM(CASE WHEN LEFT(ISNULL(CASE WHEN ISNULL(B.ETD, '') = '' OR LEN(B.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(B.ETD, '') END,A.InvoiceDate),6) = SUBSTRING(@YM3,1,6)


                THEN CASE WHEN A.CurrSeq IN (2)        THEN (C.CurAmt)
                            WHEN A.CurrSeq IN (23,4,3,1) THEN (C.DomAmt / 1280)
                            ELSE 0 END
                ELSE 0 END)                                    AS TeamSeq       ,



           E.EmpSeq                      AS SalesEmpSeq   ,
           ISNULL(K.MngValSeq,0)         AS CountrySeq    ,
           1                             AS Sort          ,
           -657931                       AS Color          
      FROM _TSLInvoice                   AS A  WITH(NOLOCK)
      LEFT OUTER JOIN _TSLExpInvoice     AS B  WITH(NOLOCK) ON A.CompanySeq = B.CompanySeq
                                                           AND A.InvoiceSeq = B.InvoiceSeq
      JOIN _TSLInvoiceItem               AS C  WITH(NOLOCK) ON A.CompanySeq = C.CompanySeq
                                                           AND A.InvoiceSeq = C.InvoiceSeq
      LEFT OUTER JOIN _TDACust           AS D  WITH(NOLOCK) ON A.CompanySeq = D.CompanySeq
                                                           AND A.CustSeq    = D.CustSeq
      LEFT OUTER JOIN _TSLCustSalesEmp   AS E  WITH(NOLOCK) ON D.CompanySeq = E.CompanySeq
                                                           AND D.CustSeq    = E.CustSeq
      LEFT OUTER JOIN _TDAEmp            AS F  WITH(NOLOCK) ON E.CompanySeq = F.CompanySeq
                                                           AND E.EmpSeq     = F.EmpSeq
      LEFT OUTER JOIN _TDAUMinorValue    AS G  WITH(NOLOCK) ON F.CompanySeq = G.CompanySeq     -- 본부별 영업담당자 (영업담당자)
                                                           AND F.EmpSeq     = G.ValueSeq
                                                           AND G.Serl       = 1000002
                                                           AND G.MajorSeq   = 1025250
      LEFT OUTER JOIN _TDAUMinorValue    AS H  WITH(NOLOCK) ON G.CompanySeq = H.CompanySeq     -- 본부별 영업담당자 (본부)
                                                           AND G.MinorSeq   = H.MinorSeq
                                                           AND H.Serl       = 1000001
                                                           AND H.MajorSeq   = 1025250
      LEFT OUTER JOIN _TDAUMinor         AS I  WITH(NOLOCK) ON H.CompanySeq = I.CompanySeq     -- 본부
                                                           AND H.ValueSeq   = I.MinorSeq
                                                           AND I.MajorSeq   = 1025249
      LEFT OUTER JOIN _TDADept      AS J  WITH(NOLOCK) ON E.CompanySeq = J.CompanySeq
                                                           AND E.DeptSeq    = J.DeptSeq
      LEFT OUTER JOIN _TDACustUserDefine AS K  WITH(NOLOCK) ON D.CompanySeq = K.CompanySeq
                                                           AND D.CustSeq    = K.CustSeq
                                                           AND K.MngSerl    = 1000002
      LEFT OUTER JOIN _TDAUMinor         AS L  WITH(NOLOCK) ON K.CompanySeq = L.CompanySeq
                                                           AND K.MngValSeq  = L.MinorSeq
      LEFT OUTER JOIN _TDACustUserDefine AS CI WITH(NOLOCK) ON D.CompanySeq  = CI.CompanySeq
                                                           AND D.CustSeq     = CI.CustSeq
                                                           AND CI.MngSerl    = 1000003   -- 지역일련번호 : Territory
      LEFT OUTER JOIN _TDAUMinorValue    AS E1 WITH(NOLOCK) ON CI.CompanySeq = E1.CompanySeq
                                                           AND CI.MngValSeq  = E1.MinorSeq
                                                           AND E1.Serl       = 1000001
      LEFT OUTER JOIN _TDACustUserDefine AS M  WITH(NOLOCK) ON D.CompanySeq  = M.CompanySeq
                                                           AND D.CustSeq     = M.CustSeq
                                                           AND M.MngSerl     = 1000005   -- SCM담당자 일련번호 : 1000005
      LEFT OUTER JOIN _TDAEmp            AS N  WITH(NOLOCK) ON N.CompanySeq  = M.CompanySeq
                                                           AND N.EmpSeq      = M.MngValSeq
     WHERE A.CompanySeq = @CompanySeq
       AND (@BizUnit       = 0  OR  @BizUnit     = ISNULL(A.BizUnit ,0))
       AND (@SalesEmpSeq   = 0  OR  @SalesEmpSeq = ISNULL(F.EmpSeq  ,0))
       AND (@SCMEmpSeq     = 0  OR  @SCMEmpSeq   = ISNULL(N.EmpSeq  ,0))
       AND (@CentralSeq    = 0  OR  @CentralSeq  = ISNULL(I.MinorSeq,0))
       AND D.SMCustStatus <> 2004003
       AND ISNULL(F.EmpSeq,0) <> 0
       AND E1.ValueText = '1'


                 AND (CASE WHEN ISNULL(b.ETD, '') = '' or len(b.ETD) <= 0  THEN ISNULL(A.InvoiceDate, '') ELSE ISNULL(b.ETD, '') END)   BETWEEN @FYFMFD AND /*@StdDate*/ /*substring('2022',1,4)+'1231'*/ SUBSTRING(@YM2,1,4)+'1231'

        

     GROUP BY I.MinorSeq ,I.MinorName,E.DeptSeq  ,J.DeptName ,E.EmpSeq   ,F.EmpName  ,ISNULL(K.MngValSeq,0),L.MinorName 
    ORDER BY I.MinorSeq, E.DeptSeq, ISNULL(K.MngValSeq,0),E.EmpSeq, L.MinorName



	update #Result set CentralName = R.CentralName,CentralSeq = R.CentralSeq, CentralSeq2 = R.CentralSeq2 from #Result as R join #Result as A on R.CentralSeq=A.CentralSeq and R.CentralName = '영업2본부' where SalesEmpName like '%KHUDO%' --KHUDO 사원 본부값이 들어가 있지 않음(유럽팀에는 소속되어있음)
	update #Result set CentralName = R.CentralName,CentralSeq = R.CentralSeq, CentralSeq2 = R.CentralSeq2 from #Result as R join #Result as A on R.CentralSeq=A.CentralSeq and R.CentralName = '영업1본부' where SalesEmpName = '서민지' and TeamName = '국내팀' --KHUDO 사원 본부값이 들어가 있지 않음(유럽팀에는 소속되어있음)

    
    INSERT INTO #Result -- 담당자별 소계
    SELECT SalesEmpName+' 합계'    AS CentralName   ,
           ''             AS TeamName      ,
           ''             AS SalesEmpName  ,
           ''             AS CountryName   ,
           SUM(A.Month1 ) AS Month1        ,
           SUM(A.Month2 ) AS Month2        ,
           SUM(A.Month3 ) AS Month3        ,
           SUM(A.Month4 ) AS Month4        ,
           SUM(A.Month5 ) AS Month5        ,
           SUM(A.Month6 ) AS Month6        ,
           SUM(A.Month7 ) AS Month7        ,
           SUM(A.Month8 ) AS Month8        ,
           SUM(A.Month9 ) AS Month9        ,
           SUM(A.Month10) AS Month10       ,
           SUM(A.Month11) AS Month11       ,
           SUM(A.Month12) AS Month12       ,
           SUM(A.T_Month) AS T_Month       ,
           SUM(A.L_Year ) AS L_Year        ,
           a.CentralSeq2   AS CentralSeq2    , 
                    SUM(A.CentralSeq) AS CountrySeq    ,

                    A.TeamSeq2              AS TeamSeq2       ,
           SUM(A.TeamSeq)              AS TeamSeq       ,
           A.SalesEmpSeq  AS SalesEmpSeq   ,
           0              AS CountrySeq2    ,
           2              AS Sort          ,
           -76359         AS Color
      FROM #Result AS A WITH(NOLOCK)
     WHERE Sort = 1
     GROUP BY CentralSeq2, SalesEmpSeq, TeamSeq2,SalesEmpName

    INSERT INTO #Result -- 팀별 소계
    SELECT TeamName+' 합계'         AS CentralName   ,
           ''             AS TeamName      ,
           ''             AS SalesEmpName  ,
           ''             AS CountryName   ,
           SUM(A.Month1 ) AS Month1        ,
           SUM(A.Month2 ) AS Month2        ,
           SUM(A.Month3 ) AS Month3        ,
           SUM(A.Month4 ) AS Month4        ,
           SUM(A.Month5 ) AS Month5        ,
           SUM(A.Month6 ) AS Month6        ,
           SUM(A.Month7 ) AS Month7        ,
           SUM(A.Month8 ) AS Month8        ,
           SUM(A.Month9 ) AS Month9        ,
           SUM(A.Month10) AS Month10       ,
           SUM(A.Month11) AS Month11       ,
           SUM(A.Month12) AS Month12       ,
           SUM(A.T_Month) AS T_Month       ,
           SUM(A.L_Year ) AS L_Year        ,
           a.CentralSeq2   AS CentralSeq2    , 
                    SUM(A.CentralSeq) AS CountrySeq    ,
           A.TeamSeq2      AS TeamSeq2       ,
                    SUM(A.TeamSeq)          AS TeamSeq       ,
           2147483646     AS SalesEmpSeq   ,
           0              AS CountrySeq    ,
           3              AS Sort          ,
           -4921870              AS Color
      FROM #Result AS A WITH(NOLOCK)
     WHERE Sort = 1
     GROUP BY A.CentralSeq2, A.TeamSeq2,TeamName

    INSERT INTO #Result -- 본부별 소계
    SELECT CentralName+' 합계'         AS CentralName   ,
           ''             AS TeamName      ,
           ''             AS SalesEmpName  ,
           ''             AS CountryName   ,
           SUM(A.Month1 ) AS Month1        ,
           SUM(A.Month2 ) AS Month2        ,
           SUM(A.Month3 ) AS Month3        ,
           SUM(A.Month4 ) AS Month4        ,
           SUM(A.Month5 ) AS Month5        ,
           SUM(A.Month6 ) AS Month6        ,
           SUM(A.Month7 ) AS Month7        ,
           SUM(A.Month8 ) AS Month8        ,
           SUM(A.Month9 ) AS Month9        ,
           SUM(A.Month10) AS Month10       ,
           SUM(A.Month11) AS Month11       ,
           SUM(A.Month12) AS Month12       ,
           SUM(A.T_Month) AS T_Month       ,
           SUM(A.L_Year ) AS L_Year        ,
           a.CentralSeq2   AS CentralSeq2    , 
                    SUM(A.CentralSeq) AS CountrySeq    ,
                    2147483647             AS TeamSeq2       ,
           SUM(A.TeamSeq)                 AS TeamSeq       ,
           2147483647     AS SalesEmpSeq   ,
           0              AS CountrySeq    ,
           4              AS Sort          ,
           -128       AS Color
      FROM #Result AS A WITH(NOLOCK)
     WHERE Sort = 1
     GROUP BY A.CentralSeq2,CentralName

    IF EXISTS (SELECT 1 FROM #Result)
    BEGIN 
        INSERT INTO #Result
        SELECT 'Total'         AS CentralName   , 
               ''             AS TeamName      ,
               ''             AS SalesEmpName  ,
               ''             AS CountryName   ,
               SUM(A.Month1 ) AS Month1        ,
               SUM(A.Month2 ) AS Month2        ,
               SUM(A.Month3 ) AS Month3        ,
               SUM(A.Month4 ) AS Month4        ,
               SUM(A.Month5 ) AS Month5        ,
               SUM(A.Month6 ) AS Month6        ,
               SUM(A.Month7 ) AS Month7        ,
               SUM(A.Month8 ) AS Month8        ,
               SUM(A.Month9 ) AS Month9        ,
               SUM(A.Month10) AS Month10       ,
               SUM(A.Month11) AS Month11       ,
               SUM(A.Month12) AS Month12       ,
               SUM(A.T_Month) AS T_Month       ,
               SUM(A.L_Year ) AS L_Year        ,
               0   AS CentralSeq2    , 
                        SUM(A.CentralSeq) AS CountrySeq    , 
               0              AS TeamSeq2       ,
                            SUM(A.TeamSeq)                   AS TeamSeq       ,
               0              AS SalesEmpSeq   ,
               0              AS CountrySeq    ,
               0              AS Sort          ,
               -2031936       AS Color
          FROM #Result AS A WITH(NOLOCK)
         WHERE Sort = 1
                 -- group by CentralSeq2
    END

    SELECT * FROM #Result 
    ORDER BY CentralSeq2,
			case when TeamName like '%유럽팀%' and SalesEmpName = '김을환' then 0 
					when CentralName like '%김을환%' then 1
					when TeamName like '%유럽팀%' and SalesEmpName = '김혜성' then 2
					when CentralName like '%김혜성%' then 3
					when TeamName like '%유럽팀%' and SalesEmpName like '%CATIA%' then 4
					when CentralName like '%CATIA%' then 5
					when TeamName like '%유럽팀%' and SalesEmpName like '%NICOLAS%' then 6 
					when CentralName like '%NICOLAS%' then 7
					when TeamName like '%유럽팀%' and SalesEmpName like '%AINURA%' then 8 
					when CentralName like '%AINURA%' then 9
					when TeamName like '%유럽팀%' and SalesEmpName = '성현주' then 10 
					when CentralName like '%성현주%' then 11
					when TeamName like '%유럽팀%' and SalesEmpName like '%JENNIE%' then 12 
					when CentralName like '%JENNIE%' then 13
					when TeamName like '%유럽팀%' and SalesEmpName like '%KHUDO%' then 14
					when CentralName like '%KHUDO%' then 15
			when CentralName like '%유럽팀%' then  16
				when TeamName like '%MENA팀%' and SalesEmpName = '강덕현' then 17
					when CentralName like '%강덕현%' then 18
					when TeamName like '%MENA팀%' and SalesEmpName = '이세림' then 19
					when CentralName like '%이세림%' then 20
					when TeamName like '%MENA팀%' and SalesEmpName like '%SOUMIA%' then 21
					when CentralName like '%SOUMIA%' then 22
			when CentralName like '%MENA팀%' then 23
				when TeamName like '%아프리카팀%' and SalesEmpName = '김선준' then 24
				when CentralName like '%김선준%' then 25
				when TeamName like '%아프리카팀%' and SalesEmpName like '%AROUNA%' then 26
				when CentralName like '%AROUNA%' then 27
				when TeamName like '%아프리카팀%' and SalesEmpName = '임태욱' then 28
				when CentralName like '%임태욱%' then 29
			when CentralName like '%아프리카팀%' then 30
			else TeamSeq2 end,
			SalesEmpSeq,
			Sort,
			CountryName
    

RETURN
