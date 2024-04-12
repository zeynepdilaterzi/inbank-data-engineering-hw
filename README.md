# inbank-data-engineering-hw

## how to run?

### Part 2
* Install Postgres locally or spin up a container.
  The script includes creating and populating the tables.
 #### for local postgres:
  * log in to psql then run this command:
    (might need to adjust file path)
  ```bash
 $ \i aggregated_monthly_payments.sql
  ```
#### for docker:
* The docker image with init.db is available in the docker hub
* run the following command to 
  

```bash
$ docker-compose up -d --build 
$ docker-compose exec web alembic upgrade head
```

##

