# REST API - Call Detail Record (CDR)
This project contains source code and supporting files for a perl base REST API application of call detail record.

## Features
- Application allows user to upload csv file using post API
- Application allows user to get information related to average call cost, longest calls, average number of calls for a given time period.

## Tech
Below are list of technologies used.
- [Perl] - Used Mojolicious framework to develop the API
- [Sqlite] - Used to save uploaded csv file to sqlite db


## Package depencies

User should ensure below packages are locally installed on your server 
```bash
Mojolicious::Lite
DBI::SQLite
Text::CSV_XS
```
## Package installation steps
User should follow below steps to start CDR Application:
```bash
git clone https://github.com/nitishagiradkar/cdr.git
cd cdr
morbo cdr.pl &
```
## Usage
User can use below endpoints though postman to use the application:

POST http://URL:3000/cdr
select "form-data" ratio button and content type as text/csv from Body tab in postman to upload file.

GET http://URL:3000/call?opr=long-call
GET http://URL:3000/call?opr=call-cost

### Limitations
- In current version "average number of calls" API is not supported.
- Currently this application is tested for file size of 500MB
- application is currently working with morbo in background, in future version it can be extended to start/stop in command line prompt.
- Authentication is not supported in current  version.


### GIT Details

https://github.com/nitishagiradkar/cdr.git



## License
MIT