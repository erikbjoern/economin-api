# economin API documentation

## Endpoints
### /api/budgets#POST
Required params: `amount:integer, start_date:date, end_date:date`

Responds with `{ budget: { id, amount, start_date, end_date } }` 
or `{ message: { *error message* } }, status 400`

### /api/budgets#GET
Required params: `requested_date:date string`

Responds with `{ budget: { id, amount, start_date, end_date } }` 
or `{ message: { *error message* } }, status 400/404`