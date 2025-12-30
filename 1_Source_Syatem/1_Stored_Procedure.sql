/****** Object:  Table [ETL].[Source_System]    Script Date: 12/30/2025 12:27:40 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ETL].[Source_System](
	[Source_System_Id] [int] IDENTITY(1,1) NOT NULL,
	[Source_Name] [varchar](128) NOT NULL,
	[System_Owner_Name] [varchar](255) NULL,
	[System_Owner_Email] [varchar](255) NULL,
	[File_Feed_Json] [text] NULL,
	[Drop_Folder] [varchar](255) NULL,
	[Database_Vendor] [varchar](30) NULL,
	[Database_Vendor_Version] [varchar](10) NULL,
	[Igc_Rid] [varchar](255) NULL,
	[Updated_By] [nvarchar](255) NOT NULL,
	[Update_Datetime] [datetime] NOT NULL,
	[Integration_Runtime] [varchar](30) NOT NULL,
 CONSTRAINT [Source_System_Pk] PRIMARY KEY CLUSTERED 
(
	[Source_System_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [ETL].[Source_System] ADD  CONSTRAINT [Source_System_Updated_By_DF]  DEFAULT (suser_sname()) FOR [Updated_By]
GO

ALTER TABLE [ETL].[Source_System] ADD  CONSTRAINT [Source_System_Update_Datetime_DF]  DEFAULT ([ETL].[udfGetTimeZoneEST](sysdatetimeoffset())) FOR [Update_Datetime]
GO

ALTER TABLE [ETL].[Source_System] ADD  CONSTRAINT [Source_System_Integration_Runtime_DF]  DEFAULT ('sen-ir-onprem-primary') FOR [Integration_Runtime]
GO


