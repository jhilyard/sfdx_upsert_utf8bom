# Salesforce DX Project: Bug Repro Steps
## [sfdx force:data:bulk:upsert fails for UTF-8 BOM encoding .csv](https://github.com/forcedotcom/cli/issues/720)

The file Repro.bat contains all of these steps except the final force:data:bulk:status call which requires Ids,
however force:org:create drops you back to the command prompt so it's essentially a manual test script, like below:

Spin up a vanilla scratch org with your default Dev Hub

```
sfdx force:org:create -a MyScratchOrg -f config/project-scratch-def.json -s
```

Push source to get an unfiltered "All" Accounts list view

```
sfdx force:source:push
```

Do a successful Account upsert:

```
sfdx force:data:bulk:upsert -s Account -f ./Account_UTF8_NO_BOM.csv -i Id -w 2
```

Observe that an Account is created with the Name "No_BOM"

Do a failing Account upsert with a UTF-8 BOM .csv file:

```
sfdx force:data:bulk:upsert -s Account -f ./Account_UTF8_BOM.csv -i Id -w 2
```

Observe that the CLI starts building the job but then exists without waiting for the timeout to complete,
and that there is no Account with the Name "BOM" in the org

Using the job and batch IDs, check status:

```
sfdx force:data:bulk:status -i <jobId> -b <batchId>
```

Example output:

```
=== Batch Status
jobId:                   7501g000004hTGfAAM
state:                   Failed
stateMessage:            InvalidBatch : Field name not found : ﻿Name
createdDate:             2020-11-03T02:43:28.000Z
systemModstamp:          2020-11-03T02:43:30.000Z
numberRecordsProcessed:  0
numberRecordsFailed:     0
totalProcessingTime:     0
apiActiveProcessingTime: 0
apexProcessingTime:      0
Getting Status... done
```

NOTE: I have also seen the command not exit prematurely, but instead display the stateMessage above to the console.

When I copied the console output to VS Code, you can see a diamond question mark character indicating a non-printable character in front of the not found field name Name -- but this character (the file encoding byte order mark) is not visible in the console or in rendered mark down.

I was pointed in the right direction by: https://trailblazers.salesforce.com/answers?id=9063A000000Dx7yQAC
