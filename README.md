# REST API - Call Detail Record (CDR)
This project contains source code and supporting files for a perl base REST API application of call detail record.

## Features
- Application allows user to upload csv file using post API
- Application allows user to get information related to average call cost, longest calls, average number of calls for a given time period.

## Tech
Below are list of technologies used.
- [Perl] - Used Mojolicious framework to develop the API
- [Sqlite] - Used to save uploaded csv file to sqlite db


## Package installation steps

User should ensure below packages are locally installed on your server in case you are facing any issue to install this. 
```bash
Mojolicious::Lite
DBI::SQLite
Text::CSV_XS
```

User should copy below files on server:
```bash
cdr.pl
DB.pm
CDR.pm
```
Before using API run below command:
```bash
morbo cdr.pl
```
### Assumptions


### Testing
Manual unit testing done for upload and GET APIS in postman
GET http://URL:3000/call?opr=long-call
GET http://URL/call?opr=call-cost

POST http://URL:3000/upload
select "form-data" ratio button from Body tab in postman to upload file.


### Limitations
average number of calls API is not delevoped due to time contraints.
testing for uploding very big files not done due to development environment contraints.


### GIT Details

https://github.com/nitishagiradkar/cdr.git



## License
MIT
