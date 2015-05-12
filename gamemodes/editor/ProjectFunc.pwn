static bool:gsProjectActive;
static gsProjectName[MAX_PROJECT_NAME_LEN];

IsValidProjectName(const name[])
{
    for(new i = 0; name[i] != EOS; ++i)
	{
        switch(name[i])
		{
            case '0'..'9', 'A'..'Z', 'a'..'z': continue;
            default: return 0;
        }
    }
    return 1;
}

bool:IsProjectActive()
{
	return gsProjectActive;
}

SetProjectActive(bool:active)
{
	gsProjectActive = active;
	return 1;
}

SetProjectName(const name[])
{
	gsProjectName[0] = EOS;
	strcat(gsProjectName, name, MAX_PROJECT_NAME_LEN);
	return 1;
}

GetProjectName(name[MAX_PROJECT_NAME_LEN])
{
	if (IsProjectActive())
	{
		strcat(name, gsProjectName, MAX_PROJECT_NAME_LEN);
		return 1;
	}
	return 0;
}

CreateProjectFile(name[])
{
	new filename[200];
	format(filename, sizeof(filename), EDITOR_PROJECT_DIR, name);

	if (!fexist(filename))
	{
		new DB:dbhandle = db_open(filename);
		if(dbhandle != DB:0)
		{
			new query[256];
			format(query, sizeof(query), "CREATE TABLE objects (key NUMERIC, modelid NUMERIC, pos_x NUMERIC, pos_y NUMERIC, pos_z NUMERIC, rot_x NUMERIC, rot_y NUMERIC, rot_z NUMERIC)");
			
			new DBResult:dbresult = db_query(dbhandle, query);
			db_free_result(dbresult);

			db_close(dbhandle);
			return 1;
		}
	}
	return 0;
}

DB:OpenProjectFile(name[])
{
	new filename[200];
	format(filename, sizeof(filename), EDITOR_PROJECT_DIR, name);

	if (fexist(filename))
	{
		new DB:dbhandle = db_open(filename);
		if(dbhandle != DB:0)
		{
			return DB:dbhandle;
		}
	}
	return DB:0;
}

/*Project_AddObject(slot, model, Float:pos_x, Float:pos_y, Float:pos_z, Float:rot_x, Float:rot_y, Float:rot_z, bool:update)
{
	new project_name[MAX_PROJECT_NAME_LEN];

	if (GetProjectName(project_name))
	{
		new DB:dbhandle = OpenProjectFile(project_name);
		if (dbhandle != DB:0)
		{
			new query[256];
			if (update)
			{
				format(
					query, sizeof(query), "UPDATE objects SET model = %d, pos_x = %f, pos_y = %f, pos_z = %d, rot_x = %f, rot_y = %f, rot_z = %d WHERE key = %d",
					model, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, slot
				);

				db_query(dbhandle, query);
			}
			else
			{
				format(
					query, sizeof(query), "INSERT INTO objects (key, model, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z)",
					slot, model, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, slot
				);
			}
			db_close(dbhandle);
			return 1;
		}
	}
	return 0;
}*/