# economin API documentation

## Endpoints
### /api/budgets#POST
Required params: `amount:integer, start_date:date, end_date:date`

Responds with `{ budget: { id, amount, start_date, end_date, created_at, updated_at } }, status 200` 
or `{ message: { *error message* } }, status 400`
