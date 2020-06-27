USE [github-database-notes]
GO


IF OBJECT_ID('Child', 'U') IS NOT NULL
	ALTER TABLE [dbo].[Child] DROP CONSTRAINT FK_Child_Parent

IF OBJECT_ID('Parent', 'U') IS NOT NULL
	ALTER TABLE [dbo].[Parent] DROP CONSTRAINT [FK_Parent_Family]
GO


IF OBJECT_ID('Family', 'U') IS NOT NULL
	DROP TABLE [Family];

IF OBJECT_ID('Parent', 'U') IS NOT NULL
	DROP TABLE [Parent];

IF OBJECT_ID('Child', 'U') IS NOT NULL
	DROP TABLE [Child];
GO



CREATE TABLE [Family] 
(	
	familyId	INT	IDENTITY(1, 1) NOT NULL,
	number		INT,
	CONSTRAINT [PK_Family_FamilyId] PRIMARY KEY NONCLUSTERED (familyId ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
);


CREATE TABLE [Parent] 
(	
	parentId	INT	IDENTITY(1, 1) NOT NULL,
	age			INT,
    familyId    INT            NOT NULL,
	CONSTRAINT [PK_Parent_ParentId] PRIMARY KEY NONCLUSTERED (parentId ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_Parent_Family] FOREIGN KEY (familyId) REFERENCES [Family] (familyId),
);
CREATE UNIQUE CLUSTERED INDEX [CIX_Parent_FamilyId_ParentId]
    ON [Parent](familyId ASC, parentId ASC)
	WITH (ONLINE = ON, FILLFACTOR = 100, DATA_COMPRESSION = PAGE);
GO


CREATE TABLE [Child]
(
	childId		INT	IDENTITY(1, 1),
	parentId	INT,
	CONSTRAINT FK_Child_Parent FOREIGN KEY (parentId) REFERENCES [Parent] (parentId)
);
GO

DECLARE @referencedFamilyId INT
DECLARE @referencedId INT

INSERT INTO [Family] VALUES (5);
SELECT @referencedFamilyId = SCOPE_IDENTITY();

BEGIN TRANSACTION
	INSERT INTO [Parent] VALUES (30, @referencedFamilyId)
	SELECT @referencedId = SCOPE_IDENTITY();
	INSERT INTO [Child] VALUES (@referencedId)
	
	--INSERT INTO [Parent] VALUES (40, @referencedFamilyId)
	--SELECT @referencedId = SCOPE_IDENTITY();
	--INSERT INTO [Child] VALUES (@referencedId)
COMMIT TRANSACTION

--select * from Parent
