REM Spin up a vanilla scratch org with an "All" Accounts list view using your default Dev Hub
sfdx force:org:create -a MyScratchOrg -f config/project-scratch-def.json -s

REM the scratch org create drops out of the batch file, so this is more like a manual test script
sfdx force:source:push

REM Upsert a single account CSV successfully
sfdx force:data:bulk:upsert -s Account -f ./Account_UTF8_NO_BOM.csv -i Id -w 2

REM Observe that an Account is created with the Name "No_BOM"
REM Go to Sales->Accounts and select "All" list view
REM sfdx force:org:open

REM Fail to Upsert when file uses UTF-8 with BOM encoding
sfdx force:data:bulk:upsert -s Account -f ./Account_UTF8_BOM.csv -i Id -w 2

REM Observe that the CLI starts building the job but then exists without waiting for the timeout to complete,
REM and that there is no Account with the Name "BOM" in the org

echo Using the job and batch IDs, check status:

echo sfdx force:data:bulk:status -i <jobId> -b <batchId>