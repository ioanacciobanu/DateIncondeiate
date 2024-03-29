	--use FB_insights;
	
if object_id('source.post', 'u') is not null 
  drop table source.post;
 go
  
  
create table source.post
([Post ID] varchar(max)
,[Permalink] varchar(max)
,[Post Message] varchar(max)
,[Type] varchar(50)
,[Countries] varchar(max)
,[Languages] varchar(max)
,[Posted] datetime
,[Audience Targeting] varchar(max)
,[Lifetime Post Total Reach] int default 0
,[Lifetime Post Total Impressions] int default 0
,[Lifetime Post Consumers] int default 0
,[Lifetime Post Consumptions] int default 0
,[Lifetime Negative Feedback from Users] int default 0
,[Lifetime Post Impressions by people who have liked your Page] int default 0
,[Lifetime Post reach by people who like your Page] int default 0
,[Lifetime Post Stories by action type - share] int default 0
,[Lifetime Post Stories by action type - like] int default 0
,[Lifetime Post Stories by action type - comment] int default 0
,[Lifetime Post Consumptions by type - other clicks] int default 0
,[Lifetime Post Consumptions by type - link clicks] int default 0
,[Lifetime Post Consumptions by type - photo view] int default 0
);
go


/* Execut acasa */

bulk insert FB_insights.source.post
from 
	'D:\01_FB_Insights\04_Pagini\Foto-Idea\post.csv'
with (
		firstrow=2,
		fieldterminator = ',',
		rowterminator='0x0a'
	  )
;
go


/* Execut serviciu */
/*
bulk insert ChubbCPFUAT.source.post
from 
	'\\telvdfs01\briinstallations\Team Personal Folders\Ioana Ciobanu\PJ\Work on Dorins PC\Chubb CPF\Better queries UAT 2\post.csv'
with (
		firstrow=2,
		fieldterminator = ',',
		rowterminator='0x0a'
	  )
;
go
*/

-----

if object_id('source.page', 'u') is not null 
  drop table source.page;
go

	  
create table source.page
(	
[Date] datetime
,[Lifetime Total Likes] int default 0
,[Daily New Likes] int default 0
,[Daily Unlikes] int default 0
,[Daily Total Reach] int default 0
,[Daily Viral Reach] int default 0
,[Daily Reach Of Page Posts] int default 0
,[Daily Total Impressions] int default 0
,[Daily Total Consumers] int default 0
,[Daily Page Consumptions] int default 0
,[Daily Negative Feedback From Users] int default 0
,[Daily Negative Feedback From Users - hide_all_clicks] int default 0
,[Daily Negative Feedback From Users - hide_clicks] int default 0
,[Daily Negative Feedback From Users - report_spam_clicks] int default 0
,[Daily Negative Feedback From Users - unlike_page_clicks] int default 0
,[Daily Negative Feedback From Users - xbutton_clicks] int default 0
,[Daily Total: total action count per Page] int default 0
,[Daily Liked and Online - 0] int default 0
,[Daily Liked and Online - 1] int default 0
,[Daily Liked and Online - 2] int default 0
,[Daily Liked and Online - 3] int default 0
,[Daily Liked and Online - 4] int default 0
,[Daily Liked and Online - 5] int default 0
,[Daily Liked and Online - 6] int default 0
,[Daily Liked and Online - 7] int default 0
,[Daily Liked and Online - 8] int default 0
,[Daily Liked and Online - 9] int default 0
,[Daily Liked and Online - 10] int default 0
,[Daily Liked and Online - 11] int default 0
,[Daily Liked and Online - 12] int default 0
,[Daily Liked and Online - 13] int default 0
,[Daily Liked and Online - 14] int default 0
,[Daily Liked and Online - 15] int default 0
,[Daily Liked and Online - 16] int default 0
,[Daily Liked and Online - 17] int default 0
,[Daily Liked and Online - 18] int default 0
,[Daily Liked and Online - 19] int default 0
,[Daily Liked and Online - 20] int default 0
,[Daily Liked and Online - 21] int default 0
,[Daily Liked and Online - 22] int default 0
,[Daily Liked and Online - 23] int default 0

);
go

/*Execut acasa*/

bulk insert FB_insights.source.page
from 
	'D:\01_FB_Insights\04_Pagini\Foto-Idea\page.csv'
with (
		firstrow=2,
		fieldterminator = ',',
		rowterminator='0x0a'
	  )
;
go


/*Execut la serviciu*/
/*
bulk insert ChubbCPFUAT.source.page
from 
	'\\telvdfs01\briinstallations\Team Personal Folders\Ioana Ciobanu\PJ\Work on Dorins PC\Chubb CPF\Better queries UAT 2\page.csv'
with (
		firstrow=2,
		fieldterminator = ',',
		rowterminator='0x0a'
	  )
;
go
*/
			   	

----


alter table source.post
add [Rownum] int
;
go
	
----

with cte as
(
	select [Post ID], Posted, [Post Message], [Type], row_number() over (order by [Posted]) as rownum from source.post
)

update ps
set ps.rownum = cte.rownum
from source.post as ps, cte
where ps.Posted = cte.posted
;
go

alter table source.page
add [Rownum] int
;
go

----

with cte as
(
	select [Date], row_number() over (order by [Date]) as rownum from source.page
)

update pg
set pg.rownum = cte.rownum
from source.page as pg, cte
where pg.[Date] = cte.[Date]
;
go

--- create tables with metrics of interest:

if object_id('target.post', 'u') is not null 
drop table target.post;
go

select  Rownum,
		[Post ID], 
		[Posted],
		cast(null as datetime) as [Next Posted],
		cast(null as datetime) as [Next Posted Diff Day],
		[Permalink],
		[Post Message],
		[Type],
		[Countries],
		[Languages],
		[Audience targeting],
		[Lifetime Post Total Reach],
		[Lifetime Post Total Impressions],
		[Lifetime Post Consumers],
		[Lifetime Post Consumptions],
		[Lifetime Negative feedback from users],
		[Lifetime Post impressions by people who have liked your Page],
		[Lifetime Post reach by people who like your Page],
		[Lifetime Post stories by action type - share],
		[Lifetime Post stories by action type - like],
		[Lifetime Post stories by action type - comment],
		[Lifetime Post consumptions by type - other clicks],
		[Lifetime Post consumptions by type - link clicks],
		[Lifetime Post consumptions by type - photo view]			
	into target.post			
	from source.post
	order by rownum
;
go	

----

if object_id('target.page', 'u') is not null 
	drop table target.page;
go
	
select  Rownum,
		[Date],
		[Lifetime Total Likes],
		[Daily New Likes],
		[Daily Unlikes],
		[Daily Total Reach],
		[Daily Viral Reach],
		[Daily Reach of Page Posts],
		[Daily Total Impressions],
		[Daily Total Consumers],
		[Daily Page Consumptions],
		[Daily Negative feedback from users],
		[Daily Negative feedback from users - hide_all_clicks],
		[Daily Negative feedback from users - hide_clicks],
		[Daily Negative feedback from users - report_spam_clicks],
		[Daily Negative feedback from users - unlike_page_clicks],
		[Daily Negative feedback from users - xbutton_clicks],
		[Daily total: Total action count per Page],
		[Daily Liked and online - 0],
		[Daily Liked and online - 1],
		[Daily Liked and online - 2],
		[Daily Liked and online - 3],
		[Daily Liked and online - 4],
		[Daily Liked and online - 5],
		[Daily Liked and online - 6],
		[Daily Liked and online - 7],
		[Daily Liked and online - 8],
		[Daily Liked and online - 9],
		[Daily Liked and online - 10],
		[Daily Liked and online - 11],
		[Daily Liked and online - 12],
		[Daily Liked and online - 13],
		[Daily Liked and online - 14],
		[Daily Liked and online - 15],
		[Daily Liked and online - 16],
		[Daily Liked and online - 17],
		[Daily Liked and online - 18],
		[Daily Liked and online - 19],
		[Daily Liked and online - 20],
		[Daily Liked and online - 21],
		[Daily Liked and online - 22],
		[Daily Liked and online - 23]
into target.page
from source.page
order by rownum
;
go
	
			

