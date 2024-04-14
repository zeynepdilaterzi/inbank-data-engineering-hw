# inbank-data-engineering-hw

## how to run?

### Part 1
* Install Postgres locally or spin up a container.
  The script includes creating and populating the tables.
 #### for local postgres:
  * log in to psql then run this command:
    (might need to adjust file path)
  ```bash
 $ \i aggregated_monthly_payments.sql
  ```
#### for docker:
* The docker image with init.db is available in the docker hub.
* After running the command below, the final table will be visible in the terminal.
  

```bash
$ docker run --rm zeynepdilaterzi/inbank-db 2>&1
```

### Part 2
* Install Jupyter Notebook.
* Launch a terminal instance in the directory.

run:
```bash
$ jupyter notebook

```
